// server.js - CGS Registration Backend
const express = require('express');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const cors = require('cors');
const jwt = require('jsonwebtoken'); // Import JWT for token generation

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Database configuration (replace with your actual credentials)
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'cgs'
};

// Create MySQL connection pool
const pool = mysql.createPool(dbConfig);

// Test database connection
async function testConnection() {
    try {
        const connection = await pool.getConnection();
        console.log('Connected to MySQL database');
        connection.release();
    } catch (error) {
        console.error('Database connection failed:', error);
        process.exit(1);
    }
}

// Registration endpoint
app.post('/api/register', async (req, res) => {
    try {
        const { id_number, email, password } = req.body;

        // Basic validation
        if (!id_number || !email || !password) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Check if email or ID already exists
        const [existingUsers] = await pool.query(
            'SELECT * FROM users WHERE email = ? OR id_number = ?',
            [email, id_number]
        );

        if (existingUsers.length > 0) {
            const error = existingUsers.some(u => u.email === email)
                ? 'Email already registered'
                : 'ID number already registered';
            return res.status(400).json({ error });
        }

        // Hash password
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Insert new user
        const [result] = await pool.query(
            'INSERT INTO users (id_number, email, password) VALUES (?, ?, ?)',
            [id_number, email, hashedPassword]
        );

        res.status(201).json({
            message: 'User  registered successfully',
            userId: result.insertId
        });

    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Login endpoint
app.post('/api/login', async (req, res) => {
    try {
        const { id_number, password } = req.body;

        if (!id_number || !password) {
            return res.status(400).json({ error: 'ID Number and password are required' });
        }

        const [users] = await pool.query('SELECT * FROM users WHERE id_number = ?', [id_number]);
        if (users.length === 0) {
            return res.status(401).json({ error: 'Invalid ID Number or password' });
        }

        const user = users[0];
        console.log('User from DB:', user); // ✅ CORRECT place

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Invalid ID Number or password' });
        }

        const token = jwt.sign({ id: user.id, id_number: user.id_number }, 'your_jwt_secret', { expiresIn: '1h' });

        res.json({
            message: 'Login successful',
            token,
            user: {
                id: user.id,
                id_number: user.id_number,
                email: user.email,
                created_at: user.created_at,
                user_level: user.user_level
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Fetch courses endpoint
app.get('/api/courses', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT
                c.course_code,
                p.program_name,
                c.course_description,
                c.units,
                GROUP_CONCAT(DISTINCT s.day_time) AS schedules,
                GROUP_CONCAT(DISTINCT f.name) AS faculty
            FROM courses c
            JOIN programs p ON c.program_id = p.program_id
            LEFT JOIN schedules s ON c.course_id = s.course_id
            LEFT JOIN course_faculty cf ON c.course_id = cf.course_id
            LEFT JOIN faculty f ON cf.faculty_id = f.faculty_id
            WHERE c.offered = 'offered'
            GROUP BY c.course_id
            `);


        const formatted = rows.map(course => ({
            course_code: course.course_code,
            program_name: course.program_name,
            course_description: course.course_description,
            units: course.units,
            schedules: course.schedules ? course.schedules.split(',') : [],
            faculty: course.faculty ? course.faculty.split(',') : []
        }));

        res.json(formatted);
    } catch (error) {
        console.error('Error fetching courses:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get all programs (for dropdown)
app.get('/api/programs', async (req, res) => {
    try {
        const [programs] = await pool.query('SELECT program_id, program_name FROM programs ORDER BY program_name');
        res.json(programs);
    } catch (error) {
        console.error('Error fetching programs:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// Fetch programs endpoint
app.get('/api/student-courses', async (req, res) => {
    const studentId = req.query.studentId;

    try {
        const [[user]] = await pool.query(
            'SELECT program_id FROM users WHERE id = ?',
            [studentId]
        );

        if (!user || !user.program_id) {
            return res.status(400).json({ error: 'Student or program not found' });
        }

        const programId = user.program_id;

        const [rows] = await pool.query(`
            SELECT 
                c.course_id,
                c.course_code,
                c.course_description,
                c.units,
                c.offered,
                e.status,
                e.rating,
                e.semester
            FROM courses c
            LEFT JOIN student_courses e
                ON c.course_id = e.course_id AND e.student_id = ?
            WHERE c.program_id = ?
        `, [studentId, programId]);

        const formatted = rows.map(c => ({
            ...c,
            status: c.status || null,
            rating: c.rating || '',
            semester: c.semester || ''
        }));

        res.json(formatted);
    } catch (error) {
        console.error('Error in /api/student-courses:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});



app.post('/api/admin/enroll-student', async (req, res) => {
    const { id_number, email, password, program_id, course_ids = [] } = req.body;

    if (!id_number || !email || !password || !program_id) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const [existing] = await pool.query(
            'SELECT * FROM users WHERE email = ? OR id_number = ?',
            [email, id_number]
        );
        if (existing.length > 0) {
            return res.status(400).json({ error: 'Student already exists' });
        }

        const hashed = await bcrypt.hash(password, 10);

        // Insert user
        const [userResult] = await pool.query(
            'INSERT INTO users (id_number, email, password, program_id, user_level) VALUES (?, ?, ?, ?, ?)',
            [id_number, email, hashed, program_id, 'student']
        );

        const userId = userResult.insertId;

        // Insert into student_courses
        const courseInserts = course_ids.map(course_id => [
            userId,
            course_id,
            'enrolled',
            null,
            null
        ]);

        if (courseInserts.length > 0) {
            await pool.query(
                'INSERT INTO student_courses (student_id, course_id, status, rating, semester) VALUES ?',
                [courseInserts]
            );
        }

        res.status(201).json({ message: 'Student and courses enrolled successfully', studentId: userId });

    } catch (err) {
        console.error('Enroll student error:', err);
        res.status(500).json({ error: 'Failed to enroll student' });
    }
});



app.get('/api/courses/offered/:programId', async (req, res) => {
    const programId = req.params.programId;
    try {
        const [courses] = await pool.query(`
            SELECT course_id, course_code, course_description
            FROM courses
            WHERE program_id = ? AND offered = 'offered'
        `, [programId]);
        res.json(courses);
    } catch (err) {
        console.error('Error fetching program courses:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Chatbot response endpoint
app.get('/api/chatbot', async (req, res) => {
    const query = (req.query.q || '').toLowerCase().trim();

    try {
        const [rows] = await pool.query(`
            SELECT keyword, response FROM chatbot_responses
            WHERE ? LIKE CONCAT('%', keyword, '%') AND is_active = 1
            ORDER BY LENGTH(keyword) DESC
            LIMIT 1
        `, [query]);

        if (rows.length > 0) {
            res.json({ response: rows[0].response });
        } else {
            res.json({ response: "Sorry, I don't know how to respond to that yet. Please try asking something else." });
        }
    } catch (error) {
        console.error('Chatbot query error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// Add chatbot response
app.post('/api/chatbot/add', async (req, res) => {
    const { keyword, response } = req.body;
    try {
        await pool.query(
            'INSERT INTO chatbot_responses (keyword, response, is_active) VALUES (?, ?, 1)',
            [keyword, response]
        );
        res.json({ message: 'Response added' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Insert failed' });
    }
});

// Get all responses
app.get('/api/chatbot/all', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM chatbot_responses ORDER BY id DESC');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Fetch failed' });
    }
});

// Toggle active status
app.patch('/api/chatbot/toggle/:id', async (req, res) => {
    try {
        await pool.query('UPDATE chatbot_responses SET is_active = NOT is_active WHERE id = ?', [req.params.id]);
        res.json({ message: 'Status toggled' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Toggle failed' });
    }
});

// Delete response
app.delete('/api/chatbot/delete/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM chatbot_responses WHERE id = ?', [req.params.id]);
        res.json({ message: 'Deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Delete failed' });
    }
});

// Get all students
app.get('/api/students', async (req, res) => {
    try {
        const [students] = await pool.query(`
            SELECT u.id, u.id_number, u.email, u.created_at, p.program_name
            FROM users u
            LEFT JOIN programs p ON u.program_id = p.program_id
            WHERE u.user_level = 'student'
            ORDER BY u.created_at DESC
        `);
        res.json(students);
    } catch (err) {
        console.error('Error fetching students:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get a single student's full info
app.get('/api/students/:id', async (req, res) => {
    const studentId = req.params.id;
    try {
        const [[user]] = await pool.query(`
            SELECT u.id, u.id_number, u.email, u.created_at, p.program_name
            FROM users u
            LEFT JOIN programs p ON u.program_id = p.program_id
            WHERE u.id = ?
        `, [studentId]);

        const [courses] = await pool.query(`
            SELECT c.course_code, c.course_description, sc.status, sc.rating, sc.semester
            FROM student_courses sc
            JOIN courses c ON sc.course_id = c.course_id
            WHERE sc.student_id = ?
        `, [studentId]);

        res.json({ user, courses });
    } catch (err) {
        console.error('Error fetching student detail:', err);
        res.status(500).json({ error: 'Failed to fetch student' });
    }
});


// Start server
app.listen(PORT, async () => {
    await testConnection();
    console.log(`Server running on http://localhost:${PORT}`);
});
