const sqlite3 = require('sqlite3').verbose();
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());


const cors = require('cors');


// Enable CORS for all origins
app.use(cors());



// Create a new database or open an existing one
const db = new sqlite3.Database('./e_receipt_app.db', (err) => {
  if (err) {
    console.error('Error opening database', err.message);
  } else {
    console.log('Connected to SQLite database.');
    db.run(
      `CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        firstName TEXT,
        lastName TEXT,
        password TEXT
      )`
    );
  }
});

// Endpoint for user registration
app.post('/api/register', (req, res) => {
  const { email, firstName, lastName, password } = req.body;

  if (!email || !firstName || !lastName || !password) {
    return res.status(400).json({ success: false, message: 'All fields are required' });
  }

  const query = `INSERT INTO users (email, firstName, lastName, password) VALUES (?, ?, ?, ?)`;

  db.run(query, [email, firstName, lastName, password], function (err) {
    if (err) {
      if (err.message.includes('UNIQUE')) {
        return res.status(400).json({ success: false, message: 'Email is already registered' });
      }
      console.error(err.message);
      return res.status(500).json({ success: false, message: 'Database error' });
    }

    res.status(200).json({
      success: true,
      message: 'Registration successful',
      userId: this.lastID,
    });
  });
});


// GET user by email
app.get('/api/user', (req, res) => {
  const email = req.query.email;

  if (!email) {
    return res.status(400).json({ success: false, message: 'Email is required' });
  }

  const query = 'SELECT * FROM users WHERE email = ?';
  db.get(query, [email], (err, row) => {
    if (err) {
      console.error(err.message);
      return res.status(500).json({ success: false, message: 'Database error' });
    }

    if (row) {
      res.status(200).json({ success: true, user: row });
    } else {
      res.status(404).json({ success: false, message: 'User not found' });
    }
  });
});

// Endpoint to get all users
app.get('/api/users', (req, res) => {
  const query = 'SELECT * FROM users';

  db.all(query, [], (err, rows) => {
    if (err) {
      console.error('Database error:', err.message);
      return res.status(500).json({ success: false, message: 'Database error' });
    }

    res.status(200).json({ success: true, users: rows });
  });
});

app.post('/api/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res
      .status(400)
      .json({ success: false, message: 'Email and password are required.' });
  }

  const query = 'SELECT * FROM users WHERE email = ?';
  db.get(query, [email], (err, row) => {
    if (err) {
      console.error(err.message);
      return res.status(500).json({ success: false, message: 'Database error' });
    }

    if (!row) {
      return res
        .status(404)
        .json({ success: false, message: 'Email not found.' });
    }

    if (row.password !== password) {
      return res
        .status(401)
        .json({ success: false, message: 'Incorrect password.' });
    }

    res.status(200).json({
      success: true,
      message: 'Login successful',
      user: { email: row.email, firstName: row.firstName, lastName: row.lastName },
    });
  });
});


app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
