const { spawn, exec } = require('child_process');
const path = require('path');
const fs = require('fs');
const multer = require('multer'); // <-- add this
const express = require('express');
const mysql = require('mysql2/promise');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const upload = multer({ dest: path.join(__dirname, 'uploads') });

const app = express();
// const PORT = process.env.PORT || 8080;

const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

function authenticateToken(req, res, next) {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) return res.sendStatus(401);

    jwt.verify(token, process.env.JWT_SECRET || 'yoursecret', (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

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

async function addLog(userId, action, details) {
    try {
        await pool.query(
            'INSERT INTO logs (user_id, action, details) VALUES (?, ?, ?)',
            [userId || null, action, details]
        );
    } catch (err) {
        console.error('Error inserting log:', err);
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

        await addLog(user.id, 'Login', `User ${user.email} logged in`);

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

// Add new course endpoint (programs.html)
app.get('/api/courses', async (req, res) => {
    try {
        const status = req.query.status;

        let query = `
            SELECT
                c.course_id,
                c.course_code,
                c.course_description,
                c.units,
                p.program_name
            FROM courses c
            JOIN programs p ON c.program_id = p.program_id
        `;

        const params = [];

        if (status === 'offered' || status === 'not offered') {
            query += ' WHERE c.offered = ?';
            params.push(status);
        }

        const [rows] = await pool.query(query, params);

        res.json(rows);
    } catch (error) {
        console.error('Error fetching courses:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// ✅ Add this route for updating offered status (progrmams.html)
app.patch('/api/courses/:id/status', async (req, res) => {
    const { id } = req.params;
    const { offered } = req.body;

    try {
        const [result] = await pool.query(
            'UPDATE courses SET offered = ? WHERE course_id = ?',
            [offered, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Course not found' });
        }

        res.json({ message: 'Course status updated successfully.' });
    } catch (error) {
        console.error('Error updating course status:', error);
        res.status(500).json({ error: 'Failed to update course status.' });
    }

    await addLog(req.user.id, 'Course Status Update', `Set course ${req.params.id} to ${req.body.status}`);
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

    await addLog(req.user.id, 'Enrollment', `Enrolled in ${selectedCourses.length} courses`);
});


// Fetch courses endpoint(courses_offered.html)
function formatSchedule(raw) {
    if (!raw || raw.toUpperCase() === 'TBA') return null;

    const match = raw.match(/^([\d:]+)-([\d:]+)([MTWFS]|Th)$/);
    if (!match) return raw;

    const [_, start, end, dayCode] = match;

    const dayMap = {
        M: 'Monday',
        T: 'Tuesday',
        W: 'Wednesday',
        Th: 'Thursday',
        F: 'Friday',
        S: 'Saturday'
    };

    const day = dayMap[dayCode] || dayCode;

    const isSaturday = dayCode === 'S';

    const formatTime = (t) => {
        if (t.includes(':')) {
            let [h, m] = t.split(':').map(Number);
            if (!isSaturday && h < 12) h += 12;
            const suffix = h >= 12 ? 'PM' : 'AM';
            h = h > 12 ? h - 12 : h;
            return `${h}:${String(m).padStart(2, '0')} ${suffix}`;
        } else {
            let h = parseInt(t);
            let suffix = isSaturday ? 'AM' : 'PM';
            if (!isSaturday && h < 12) h += 12;
            h = h > 12 ? h - 12 : h;
            return `${h}:00 ${suffix}`;
        }
    };

    return `${formatTime(start)} - ${formatTime(end)} (${day})`;
}

app.get('/api/courses/offered-detailed', async (req, res) => {
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
            schedules: course.schedules
                ? course.schedules
                    .split(',')
                    .map(s => formatSchedule(s))
                    .filter(Boolean)
                : [],
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

// Dashboard statistics (admin.html)
app.get('/api/dashboard/students-per-program', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT p.program_name, COUNT(u.id) AS student_count
            FROM users u
            JOIN programs p ON u.program_id = p.program_id
            WHERE u.user_level = 'student'
            GROUP BY p.program_name
        `);
        res.json(rows.map(row => ({
            program: row.program_name,
            students: row.student_count
        })));
    } catch (error) {
        console.error('Error fetching students per program:', error);
        res.status(500).json({ error: 'Server error' });
    }
});

app.get('/api/dashboard/enrollments-per-month', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT DATE_FORMAT(date_applied, '%b') AS month, COUNT(*) AS total
            FROM enrollments
            GROUP BY month
            ORDER BY STR_TO_DATE(month, '%b')
        `);
        res.json(rows.map(row => ({
            date: row.month,
            enrollments: row.total
        })));
    } catch (error) {
        console.error('Error fetching enrollments per month:', error);
        res.status(500).json({ error: 'Server error' });
    }
});


// Add chatbot response (chatbotAdmin.html)
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

    await addLog(req.user.id, 'Chatbot Entry Added', `Keyword: ${req.body.keyword}`);
});

// Get all responses (chatbotAdmin.html)
app.get('/api/chatbot/all', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM chatbot_responses ORDER BY id DESC');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Fetch failed' });
    }
});

// Toggle active status (chatbotAdmin.html)
app.patch('/api/chatbot/toggle/:id', async (req, res) => {
    try {
        await pool.query('UPDATE chatbot_responses SET is_active = NOT is_active WHERE id = ?', [req.params.id]);
        res.json({ message: 'Status toggled' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Toggle failed' });
    }
});

// Delete response (chatbotAdmin.html)
app.delete('/api/chatbot/delete/:id', async (req, res) => {
    try {
        await pool.query('DELETE FROM chatbot_responses WHERE id = ?', [req.params.id]);
        res.json({ message: 'Deleted' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Delete failed' });
    }

    await addLog(req.user.id, 'Chatbot Entry Deleted', `Deleted response ID ${req.params.id}`);
});

// Get all students (students.html)
app.get('/api/students', async (req, res) => {
    try {
        const [students] = await pool.query(`
            SELECT 
                enrollments.student_id,
                users.id,
                users.email,
                users.full_name,
                MIN(enrollments.status) AS status,
                programs.program_name
            FROM enrollments 
            JOIN users ON enrollments.student_id = users.id
            LEFT JOIN programs ON enrollments.program_id = programs.program_id
            GROUP BY enrollments.student_id
            ORDER BY enrollments.date_applied DESC
        `);
        res.json(students);
    } catch (err) {
        console.error('Error fetching enrolled students:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get single student details for modal (students.html)
app.get('/api/students/:id', async (req, res) => {
    const studentId = req.params.id;
    try {
        const [[student]] = await pool.query(`
            SELECT 
                u.full_name AS student_name,
                u.email AS student_email,
                u.id AS student_id,
                u.id AS student_id_number,
                e.program_id,
                e.address,
                e.status,
                p.program_name
            FROM users u
            LEFT JOIN enrollments e ON u.id = e.student_id
            LEFT JOIN programs p ON e.program_id = p.program_id
            WHERE u.id = ?
            LIMIT 1;
        `, [studentId]);

        const [enrolledCourses] = await pool.query(`
            SELECT courses.course_code, courses.course_description, courses.units
            FROM enrollments
            JOIN courses ON enrollments.course_id = courses.course_id
            WHERE enrollments.student_id = ?
        `, [studentId]);

        res.json({
            ...student,
            courses: enrolledCourses
        });
    } catch (err) {
        console.error('Error fetching student detail:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Update student status (students.html)
app.patch('/api/students/:id/status', async (req, res) => {
    const { id } = req.params;
    const { status } = req.body;
    try {
        await pool.query('UPDATE enrollments SET status = ? WHERE student_id = ?', [status, id]);
        res.json({ message: 'Student status updated successfully.' });
    } catch (err) {
        console.error('Status update error:', err);
        res.status(500).json({ error: 'Failed to update status.' });
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

    await addLog(req.user.id, 'Enrollment', `Enrolled in ${selectedCourses.length} courses`);
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

    await addLog(req.user.id, 'Enrollment Deletion', `Deleted all enrollments for student ${req.params.student_id}`);
});


// Check if a user is enrolled in any courses (enrollment.html)
app.get('/api/enrollment/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const [rows] = await pool.query(`
            SELECT 
                e.enrollment_id,
                c.course_code,
                c.course_description,
                c.units,
                g.grade
            FROM enrollments e
            JOIN courses c ON e.course_id = c.course_id
            LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
            WHERE e.student_id = ?
            ORDER BY c.course_code ASC
        `, [userId]);

        // Keep your original shape { enrolled, data } if you want
        res.json({
            enrolled: true,
            data: rows
        });
    } catch (err) {
        console.error('Error fetching enrollment checklist:', err);
        res.status(500).json({ error: 'Database error' });
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

// Get all faculty members (teacher-home.html)
app.get('/api/teacher/students/:facultyId', async (req, res) => {
    const { facultyId } = req.params;
    try {
        const [rows] = await pool.query(`
            SELECT 
                e.enrollment_id,
                e.student_id,
                u.full_name AS student_name,
                u.email AS student_email,
                c.course_code,
                c.course_description,
                g.grade
            FROM course_faculty cf
            JOIN courses c ON cf.course_id = c.course_id
            JOIN enrollments e ON c.course_id = e.course_id
            JOIN users u ON e.student_id = u.id
            LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
            WHERE cf.faculty_id = ?
            GROUP BY e.enrollment_id
        `, [facultyId]);

        res.json(rows);
    } catch (err) {
        console.error('Error fetching students:', err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.post('/api/teacher/grades', async (req, res) => {
    const { enrollment_id, grade } = req.body;
    if (!enrollment_id || !grade) {
        return res.status(400).json({ success: false, message: 'Missing data' });
    }

    try {
        // Check if grade exists
        const [existing] = await pool.query(`SELECT * FROM grades WHERE enrollment_id = ?`, [enrollment_id]);
        if (existing.length > 0) {
            await pool.query(`UPDATE grades SET grade = ? WHERE enrollment_id = ?`, [grade, enrollment_id]);
        } else {
            await pool.query(`INSERT INTO grades (enrollment_id, grade) VALUES (?, ?)`, [enrollment_id, grade]);
        }
        res.json({ success: true });
    } catch (err) {
        console.error('Error posting grade:', err);
        res.status(500).json({ success: false, message: 'Database error' });
    }
});


app.get('/api/faculty/by-user/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const [[row]] = await pool.query('SELECT faculty_id FROM faculty WHERE user_id = ?', [userId]);
        if (!row) return res.status(404).json({ error: 'Faculty not found' });
        res.json(row);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});


// Add this to the bottom of server.js
app.post('/api/admin/end-term', async (req, res) => {
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        // 1. Backup current state (optional for undo - simple version stores in memory, real version would use a table)
        const [backups] = await connection.query(`
            SELECT * FROM courses WHERE offered = 'offered'
        `);

        global._previousOfferedCourses = backups.map(course => ({
            course_id: course.course_id
        }));

        // 2. Set all courses to 'not offered'
        await connection.query(`UPDATE courses SET offered = 'not offered' WHERE offered = 'offered'`);

        // 3. Remove all schedules linked to offered courses
        await connection.query(`DELETE FROM schedules WHERE course_id IN (SELECT course_id FROM courses)`);

        // 4. Remove all faculty assignments linked to offered courses
        await connection.query(`DELETE FROM course_faculty WHERE course_id IN (SELECT course_id FROM courses)`);

        await connection.commit();
        res.json({ message: 'Term successfully ended. All offerings reset.' });
    } catch (error) {
        await connection.rollback();
        console.error('End term error:', error);
        res.status(500).json({ error: 'Failed to end term.' });
    } finally {
        connection.release();
    }

    await addLog(req.user.id, 'End Term', 'Reset all offered courses');
});

// ✅ Undo endpoint
app.post('/api/admin/undo-end-term', async (req, res) => {
    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        const backups = global._previousOfferedCourses || [];
        if (!backups.length) {
            return res.status(400).json({ error: 'No previous state to undo.' });
        }

        for (const course of backups) {
            await connection.query(`UPDATE courses SET offered = 'offered' WHERE course_id = ?`, [course.course_id]);
        }

        global._previousOfferedCourses = []; // Clear after undo

        await connection.commit();
        res.json({ message: 'Undo successful. Course offerings restored.' });
    } catch (error) {
        await connection.rollback();
        console.error('Undo error:', error);
        res.status(500).json({ error: 'Failed to undo end term.' });
    } finally {
        connection.release();
    }

    await addLog(req.user.id, 'Undo End Term', 'Restored previous course offerings');
});

// Utility: Validate schedule format (e.g. 8-12S or 5:30-7:30F)
function isValidScheduleFormat(schedule) {
    return /^\d{1,2}(:\d{2})?-\d{1,2}(:\d{2})?(M|T|W|Th|F|S)$/.test(schedule);
}


// Manually assign schedule and faculty name to offered course
app.post('/api/courses/:courseId/schedule-faculty', async (req, res) => {
    const { courseId } = req.params;
    const { schedule, faculty_name } = req.body;

    if (!schedule || !faculty_name) {
        return res.status(400).json({ error: 'Schedule and faculty name are required.' });
    }

    if (!isValidScheduleFormat(schedule)) {
        return res.status(400).json({ error: 'Invalid schedule format. Use e.g. 8-12S or 5:30-7:30F.' });
    }

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        // Insert schedule
        await connection.query(
            'INSERT INTO schedules (course_id, day_time) VALUES (?, ?)',
            [courseId, schedule]
        );

        // Insert faculty manually (if not already in faculty table)
        const [existing] = await connection.query(
            'SELECT faculty_id FROM faculty WHERE name = ?',
            [faculty_name]
        );

        let facultyId;
        if (existing.length) {
            facultyId = existing[0].faculty_id;
        } else {
            const [inserted] = await connection.query(
                'INSERT INTO faculty (name) VALUES (?)',
                [faculty_name]
            );
            facultyId = inserted.insertId;
        }

        // Link course with faculty
        await connection.query(
            'INSERT INTO course_faculty (course_id, faculty_id) VALUES (?, ?)',
            [courseId, facultyId]
        );

        await connection.commit();
        res.json({ message: 'Schedule and faculty assigned successfully.' });
    } catch (err) {
        await connection.rollback();
        console.error('Assign error:', err);
        res.status(500).json({ error: 'Failed to assign schedule and faculty.' });
    } finally {
        connection.release();
    }

    await addLog(req.user.id, 'Schedule/Faculty Assignment', `Assigned schedule ${req.body.schedule} and faculty ${req.body.facultyName} to course ${req.params.courseId}`);
});

// Get all faculty with linked email (for facultyAdmin.html)
app.get('/api/faculty/all', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT f.faculty_id, f.name, u.email
            FROM faculty f
            LEFT JOIN users u ON f.user_id = u.id
            ORDER BY f.name ASC
        `);
        res.json(rows);
    } catch (err) {
        console.error('Fetch faculty failed:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// Create new faculty account + link to faculty table
app.post('/api/faculty/create-account', async (req, res) => {
    const { name, email, password } = req.body;
    if (!name || !email || !password) {
        return res.status(400).json({ error: 'Missing fields' });
    }

    const connection = await pool.getConnection();
    try {
        await connection.beginTransaction();

        // Check for existing user with same email
        const [existing] = await connection.query(
            `SELECT * FROM users WHERE email = ?`, 
            [email]
        );
        if (existing.length) {
            return res.status(400).json({ error: 'Email already exists' });
        }

        // Create user
        const hashed = await bcrypt.hash(password, 10);
        const [userResult] = await connection.query(
            `INSERT INTO users (full_name, email, password, user_level) VALUES (?, ?, ?, 'teacher')`,
            [name, email, hashed]
        );
        const userId = userResult.insertId;

        // Link or insert faculty record
        const [faculties] = await connection.query(
            `SELECT faculty_id FROM faculty WHERE name = ?`, 
            [name]
        );
        if (faculties.length) {
            await connection.query(
                `UPDATE faculty SET user_id = ? WHERE name = ?`, 
                [userId, name]
            );
        } else {
            await connection.query(
                `INSERT INTO faculty (name, user_id) VALUES (?, ?)`, 
                [name, userId]
            );
        }

        await connection.commit();

        // Success response
        res.json({ message: 'Faculty user created and linked.' });

        // Log action (after response to avoid blocking)
        addLog(req.user.id, 'Faculty Created', `Created faculty account for ${name}`);

    } catch (err) {
        await connection.rollback();
        console.error('Create faculty error:', err);
        res.status(500).json({ error: 'Failed to create faculty account' });
    } finally {
        connection.release();
    }
});


// (admin.html)
app.get('/api/dashboard/faculty-load', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT f.name AS faculty_name, COUNT(cf.course_id) AS course_count
            FROM faculty f
            LEFT JOIN course_faculty cf ON f.faculty_id = cf.faculty_id
            GROUP BY f.name
            ORDER BY course_count DESC
        `);
        res.json(rows);
    } catch (err) {
        console.error('Error fetching faculty load:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// Get latest announcements (admin.html, home.html)
app.get('/api/announcements', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT a.*, u.full_name AS author 
            FROM announcements a
            LEFT JOIN users u ON a.created_by = u.id
            ORDER BY a.created_at DESC
            LIMIT 5
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch announcements' });
    }
});

// GET: All announcements
app.get('/api/announcements', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT a.*, u.full_name AS author 
            FROM announcements a
            LEFT JOIN users u ON a.created_by = u.id
            ORDER BY a.created_at DESC
            LIMIT 10
        `);
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch announcements' });
    }
});

// POST: New announcement
app.post('/api/announcements', async (req, res) => {
    const { title, message, created_by } = req.body;
    if (!title || !message || !created_by) {
        return res.status(400).json({ error: 'Missing fields' });
    }

    try {
        await pool.query(
            'INSERT INTO announcements (title, message, created_by) VALUES (?, ?, ?)',
            [title, message, created_by]
        );
        res.json({ success: true });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to post announcement' });
    }
});

app.get('/api/admin/backup', (req, res) => {
    const dbUser = 'root';
    const dbPass = '';
    const dbName = 'cgs';
    const mysqldumpPath = 'D:\\xampp\\mysql\\bin\\mysqldump.exe';

    res.setHeader('Content-Disposition', `attachment; filename="cgs_backup_${Date.now()}.sql"`);
    res.setHeader('Content-Type', 'application/sql');

    let args = [];
    if (dbPass) {
        args = [`-u${dbUser}`, `-p${dbPass}`, dbName];
    } else {
        args = [`-u${dbUser}`, dbName];
    }

    const dumpProcess = spawn(mysqldumpPath, args);

    dumpProcess.stdout.pipe(res);

    dumpProcess.stderr.on('data', (data) => {
        console.error(`mysqldump error: ${data}`);
    });

    dumpProcess.on('error', (err) => {
        console.error('Failed to start mysqldump:', err);
        res.status(500).end('Backup failed.');
    });
});


app.post('/api/admin/restore', upload.single('backup'), (req, res) => {
    if (!req.file) {
        return res.status(400).json({ success: false, message: 'No file uploaded' });
    }

    const dbUser = 'root';
    const dbPass = '';
    const dbName = 'cgs';
    const mysqlPath = 'D:\\xampp\\mysql\\bin\\mysql.exe';
    const backupFile = req.file.path;

    let restoreCmd = '';
    if (dbPass) {
        restoreCmd = `"${mysqlPath}" -u${dbUser} -p${dbPass} ${dbName} < "${backupFile}"`;
    } else {
        restoreCmd = `"${mysqlPath}" -u${dbUser} ${dbName} < "${backupFile}"`;
    }

    exec(restoreCmd, (err, stdout, stderr) => {
        // Remove uploaded file after restore
        fs.unlinkSync(backupFile);

        if (err) {
            console.error('Restore error:', stderr);
            return res.status(500).json({ success: false, message: 'Restore failed' });
        }

        // Optionally log the restore
        const userId = req.user?.id || null;
        const userEmail = req.user?.email || 'Unknown';
        db.query(
            'INSERT INTO logs (user_id, user_email, action, details) VALUES (?, ?, ?, ?)',
            [userId, userEmail, 'Database Restore', 'Database restored from backup file'],
            (logErr) => {
                if (logErr) console.error('Failed to log restore:', logErr);
            }
        );

        res.json({ success: true, message: 'Database restored successfully.' });
    });
});

app.get('/api/admin/logs', async (req, res) => {
    try {
        const [rows] = await pool.query(
            `SELECT l.id, l.action, l.details, l.created_at, u.email AS user_email
             FROM logs l
             LEFT JOIN users u ON l.user_id = u.id
             ORDER BY l.created_at DESC
             LIMIT 100`
        );
        res.json(rows);
    } catch (err) {
        console.error('Error fetching logs:', err);
        res.status(500).json({ message: 'Error fetching logs.' });
    }
});


// Start server
app.listen(PORT, async () => {
    await testConnection();
    console.log(`Server running on http://localhost:${PORT}`);
});
