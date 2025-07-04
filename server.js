const path = require('path');

// server.js - CGS Registration Backend
const express = require('express');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const cors = require('cors');
const jwt = require('jsonwebtoken'); // Import JWT for token generation

const app = express();
// const PORT = process.env.PORT || 8080;


const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Database configuration
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'cgs'
};


// const dbConfig = {
//     host: process.env.DB_HOST,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME,
//     ssl: { rejectUnauthorized: true }
// };


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

// Login endpoint (index.html)
app.post('/api/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ error: 'Email and password are required' });
        }

        const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: 'Invalid email or password' });
        }

        const token = jwt.sign({ id: user.id, email: user.email }, 'your_jwt_secret', { expiresIn: '1h' });

        res.json({
            message: 'Login successful',
            token,
            user: {
                id: user.id,
                email: user.email,
                created_at: user.created_at,
                user_level: user.user_level,
                program_id: user.program_id,
                enrollment_status: user.enrollment_status
            }
        });

    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// Fetch offered courses for a specific program (courses_curriculum.html)
app.get('/api/courses/offered/:programId', async (req, res) => {
    const programId = req.params.programId;
    try {
        const [courses] = await pool.query(`
            SELECT 
                c.course_id,
                c.course_code,
                c.course_description,
                c.units
            FROM courses c
            WHERE c.program_id = ? AND c.offered = 'offered'
        `, [programId]);
        res.json(courses);
    } catch (err) {
        console.error('Error fetching offered courses:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Registration endpoint (registration.html)
app.post('/api/register', async (req, res) => {
    try {
        const { full_name, email, password } = req.body;

        if (!full_name || !email || !password) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Check if email already exists
        const [existingUsers] = await pool.query(
            'SELECT * FROM users WHERE email = ?',
            [email]
        );

        if (existingUsers.length > 0) {
            return res.status(400).json({ error: 'Email already registered' });
        }

        // Hash password
        const saltRounds = 10;
        const hashedPassword = await bcrypt.hash(password, saltRounds);

        // Insert user
        const [result] = await pool.query(
            'INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)',
            [full_name, email, hashedPassword]
        );

        res.status(201).json({
            message: 'User registered successfully',
            userId: result.insertId
        });

    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});


// Fetch courses endpoint(courses_offered.html)
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

// Get all programs (for dropdown) (courses_curriculum.html)
app.get('/api/programs', async (req, res) => {
    try {
        const [programs] = await pool.query('SELECT program_id, program_name FROM programs ORDER BY program_name');
        res.json(programs);
    } catch (error) {
        console.error('Error fetching programs:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Chatbot response endpoint (chatbot.html)
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


// Add chatbot response (admin.html)
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

// Get all responses (admin.html)
app.get('/api/chatbot/all', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM chatbot_responses ORDER BY id DESC');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Fetch failed' });
    }
});

// Toggle active status (admin.html)
app.patch('/api/chatbot/toggle/:id', async (req, res) => {
    try {
        await pool.query('UPDATE chatbot_responses SET is_active = NOT is_active WHERE id = ?', [req.params.id]);
        res.json({ message: 'Status toggled' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Toggle failed' });
    }
});

// Delete response (admin.html)
app.delete('/api/chatbot/delete/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM chatbot_responses WHERE id = ?', [req.params.id]);
        res.json({ message: 'Deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Delete failed' });
    }
});

// Get all students (students.html)
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

// Student enrollment with metadata (enrollment.html)
app.post('/api/student-courses/enroll', async (req, res) => {
    const {
        student_name,
        student_id,
        student_email,
        student_id_number,
        program_id,
        course_ids,
        term,
        student_category,
        academic_year,
        address
    } = req.body;

    if (!student_id || !course_ids?.length || !term || !student_category || !academic_year) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        const insertPromises = course_ids.map(course_id =>
            connection.query(
                `INSERT INTO enrollments 
                (student_id, course_id, term, student_category, academic_year, address,
                student_name, student_email, student_id_number, program_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    student_id, course_id, term, student_category, academic_year, address,
                    student_name, student_email, student_id_number, program_id
                ]
            )
        );
        await Promise.all(insertPromises);

        // Calculate total units
        const [courses] = await connection.query(
            `SELECT units FROM courses WHERE course_id IN (${course_ids.map(() => '?').join(',')})`,
            course_ids
        );
        const totalUnits = courses.reduce((sum, course) => sum + course.units, 0);

        // Determine tuition per unit
        const [[{ program_level }]] = await connection.query(
            'SELECT program_level FROM programs WHERE program_id = ?',
            [program_id]
        );
        const perUnit = program_level === 'Doctorate' ? 500 : 400;
        const tuition = totalUnits * perUnit;

        const isNew = student_category.toLowerCase() === 'new';
        const misc =
            (isNew ? 100 : 0) + // Entrance
            150 +               // ILS
            500 +               // Energy
            150 +               // Registration
            150 +               // Athletic
            100 +               // Cultural
            200 +               // Library
            (isNew ? 100 : 0) + // School ID
            200 +               // Internet
            200 +               // Laboratory
            1275 +              // Development
            150 +               // Medical
            100;                // Guidance

        const total = tuition + misc;

        await connection.query(
            `INSERT INTO enrollment_fees 
            (student_id, total_units, tuition_fee, misc_fee, total_fee)
            VALUES (?, ?, ?, ?, ?)`,
            [student_id, totalUnits, tuition, misc, total]
        );

        await connection.commit();
        res.json({ message: 'Enrollment and fee calculated successfully.' });
    } catch (err) {
        await connection.rollback();
        console.error(err);
        res.status(500).json({ error: 'Enrollment failed' });
    } finally {
        connection.release();
    }
});

// (enrollment.html)
app.get('/api/enrollment-fees/:studentId', async (req, res) => {
    try {
        const { studentId } = req.params;
        const [rows] = await pool.query(
            'SELECT * FROM enrollment_fees WHERE student_id = ?',
            [studentId]
        );
        if (!rows.length) return res.status(404).json({ error: 'No fee record found' });
        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch fee data' });
    }
});


// Delete student courses by ID number (enrollment.html)
app.delete('/api/student-courses/delete/:student_id', async (req, res) => {
    const { student_id } = req.params;

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        await connection.query('DELETE FROM enrollments WHERE student_id = ?', [student_id]);
        await connection.query('DELETE FROM enrollment_fees WHERE student_id = ?', [student_id]);

        await connection.commit();
        res.json({ message: 'Enrollment and fees deleted successfully.' });
    } catch (err) {
        await connection.rollback();
        console.error('Delete error:', err);
        res.status(500).json({ error: 'Failed to delete enrollment and fees.' });
    } finally {
        connection.release();
    }
});


// Check if a user is enrolled in any courses (enrollment.html)
app.get('/api/enrollment/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const [enrollments] = await pool.query(
            `SELECT 
                e.*, 
                c.course_code, 
                c.course_description, 
                c.units
             FROM enrollments e
             JOIN courses c ON e.course_id = c.course_id
             WHERE e.student_id = ?`,
            [userId]
        );

        if (enrollments.length === 0) {
            return res.json({ enrolled: false });
        }

        res.json({ enrolled: true, data: enrollments });
    } catch (err) {
        console.error('Fetch enrollment error:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get programs filtered by program level (used only in enrollment.html)
app.get('/api/programs/by-level', async (req, res) => {
    try {
        const { level } = req.query;
        if (!level) {
            return res.status(400).json({ error: 'Program level is required' });
        }

        const [programs] = await pool.query(
            'SELECT program_id, program_name, program_level FROM programs WHERE program_level = ? ORDER BY program_name',
            [level]
        );

        res.json(programs);
    } catch (error) {
        console.error('Error fetching programs by level:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// (enrollment.html)
app.get('/api/program-details/:programId', async (req, res) => {
    const { programId } = req.params;
    try {
        const [rows] = await pool.query(
            'SELECT program_name, program_level FROM programs WHERE program_id = ?',
            [programId]
        );
        if (rows.length === 0) return res.status(404).json({ error: 'Program not found' });
        res.json(rows);
    } catch (err) {
        console.error('Program details fetch error:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});



// // ✅ Correct for your actual folder
// app.use(express.static(path.join(__dirname, '../client')));

// app.get('*', (req, res) => {
//     res.sendFile(path.join(__dirname, '../client/login.html'));
// });


// Start server
app.listen(PORT, async () => {
    await testConnection();
    console.log(`Server running on http://localhost:${PORT}`);
});
