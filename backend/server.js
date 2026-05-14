const bcrypt = require('bcryptjs');
const cors = require('cors');
const express = require('express');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');

const app = express();
const port = Number(process.env.PORT || 3000);
const jwtSecret = process.env.JWT_SECRET;
const corsOrigin = process.env.CORS_ORIGIN || '*';

if (!jwtSecret) {
  throw new Error('JWT_SECRET is required');
}

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || 'virtualtigray',
  user: process.env.DB_USER || 'vtg_user',
  password: process.env.DB_PASSWORD,
});

app.use(cors({
  origin: corsOrigin === '*' ? true : corsOrigin.split(',').map((origin) => origin.trim()),
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

async function initializeDatabase() {
  await pool.query(`
    create extension if not exists pgcrypto;

    create table if not exists users (
      id uuid primary key default gen_random_uuid(),
      email text not null unique,
      name text not null,
      password_hash text not null,
      profile_image_url text,
      user_type text not null,
      registration_status text not null default 'pending',
      created_at timestamptz not null default now(),
      updated_at timestamptz not null default now()
    );

    create table if not exists professionals (
      id uuid primary key default gen_random_uuid(),
      name text not null,
      title text not null,
      organization text,
      location text,
      email text,
      skills text[] not null default '{}',
      bio text not null,
      created_at timestamptz not null default now()
    );

    create table if not exists tradespeople (
      id uuid primary key default gen_random_uuid(),
      name text not null,
      trade text not null,
      location text,
      phone text,
      rating numeric(2, 1) not null default 5.0,
      description text not null,
      created_at timestamptz not null default now()
    );

    create table if not exists businesses (
      id uuid primary key default gen_random_uuid(),
      name text not null,
      category text not null,
      location text,
      phone text,
      website text,
      description text not null,
      created_at timestamptz not null default now()
    );

    create table if not exists education_opportunities (
      id uuid primary key default gen_random_uuid(),
      title text not null,
      provider text not null,
      level text not null,
      deadline date,
      link text,
      description text not null,
      created_at timestamptz not null default now()
    );

    create index if not exists users_email_idx on users (email);
    create unique index if not exists professionals_email_unique_idx on professionals (email) where email is not null;
    create unique index if not exists tradespeople_phone_unique_idx on tradespeople (phone) where phone is not null;
    create unique index if not exists businesses_name_location_unique_idx on businesses (name, location);
    create unique index if not exists education_title_provider_unique_idx on education_opportunities (title, provider);
  `);

  const users = [
    {
      name: 'Virtual Tigray Admin',
      email: 'admin@virtualtigray.org',
      password: 'Password123!',
      userType: 'admin',
      status: 'approved',
    },
    {
      name: 'Selam Hagos',
      email: 'selam@example.com',
      password: 'Password123!',
      userType: 'professional',
      status: 'approved',
    },
    {
      name: 'Dawit Gebre',
      email: 'dawit@example.com',
      password: 'Password123!',
      userType: 'business_owner',
      status: 'approved',
    },
  ];

  for (const user of users) {
    const passwordHash = await bcrypt.hash(user.password, 12);
    await pool.query(
      `insert into users (name, email, password_hash, user_type, registration_status)
       values ($1, $2, $3, $4, $5)
       on conflict (email) do update set
         name = excluded.name,
         password_hash = excluded.password_hash,
         user_type = excluded.user_type,
         registration_status = excluded.registration_status,
         updated_at = now()`,
      [user.name, user.email, passwordHash, user.userType, user.status],
    );
  }

  await pool.query(`
    insert into professionals (name, title, organization, location, email, skills, bio)
    values
      ('Selam Hagos', 'Civil Engineer', 'Mekelle Infrastructure Studio', 'Mekelle / Remote', 'selam@example.com', array['civil engineering', 'project management', 'water systems'], 'Infrastructure specialist supporting resilient community projects.'),
      ('Amanuel Tesfay', 'Software Developer', 'Diaspora Tech Network', 'Denver / Remote', 'amanuel@example.com', array['flutter', 'node.js', 'cloud deployment'], 'Full-stack developer helping Tigrayan organizations launch digital services.'),
      ('Feven Berhe', 'Public Health Advisor', 'Community Health Initiative', 'Addis Ababa / Remote', 'feven@example.com', array['public health', 'program evaluation', 'training'], 'Advisor focused on health access, reporting, and community education.')
    on conflict do nothing;

    insert into tradespeople (name, trade, location, phone, rating, description)
    values
      ('Tekle Weldemariam', 'Electrician', 'Mekelle', '+251-900-000-101', 4.9, 'Residential and small-business electrical installation and repair.'),
      ('Mulu Desta', 'Tailor', 'Adigrat', '+251-900-000-102', 4.8, 'Traditional clothing, alterations, and event garments.'),
      ('Haile Alem', 'Carpenter', 'Axum', '+251-900-000-103', 4.7, 'Furniture repair, cabinets, doors, and practical woodwork.')
    on conflict do nothing;

    insert into businesses (name, category, location, phone, website, description)
    values
      ('Tigray Coffee Collective', 'Food and Beverage', 'Mekelle', '+251-900-000-201', 'https://example.com/coffee', 'Coffee sourcing and roasting collective connecting local producers with buyers.'),
      ('Axum Heritage Tours', 'Travel', 'Axum', '+251-900-000-202', 'https://example.com/tours', 'Cultural tour planning and guide services.'),
      ('Diaspora Market Link', 'Commerce', 'Online', '+1-555-010-0203', 'https://example.com/market', 'Marketplace support for diaspora and local business discovery.')
    on conflict do nothing;

    insert into education_opportunities (title, provider, level, deadline, link, description)
    values
      ('STEM Mentorship Cohort', 'Virtual Tigray Education Desk', 'High school and university', '2026-08-31', 'https://example.com/stem-mentorship', 'Mentorship program pairing students with diaspora STEM professionals.'),
      ('Community Scholarship Fund', 'Tigray Scholars Network', 'Undergraduate', '2026-09-15', 'https://example.com/scholarship', 'Need-based scholarship support for undergraduate students.'),
      ('Digital Skills Bootcamp', 'Diaspora Tech Network', 'Beginner to intermediate', '2026-07-30', 'https://example.com/bootcamp', 'Practical training in web basics, mobile apps, and cloud tools.')
    on conflict do nothing;
  `);
}

function publicUser(row) {
  return {
    id: row.id,
    email: row.email,
    name: row.name,
    profile_image_url: row.profile_image_url,
    user_type: row.user_type,
    registration_status: row.registration_status,
    created_at: row.created_at,
  };
}

function signToken(user) {
  return jwt.sign({ sub: user.id, email: user.email }, jwtSecret, {
    expiresIn: '7d',
  });
}

async function requireAuth(req, res, next) {
  const header = req.get('authorization') || '';
  const [, token] = header.match(/^Bearer\s+(.+)$/i) || [];

  if (!token) {
    return res.status(401).json({ error: 'Missing bearer token' });
  }

  try {
    const payload = jwt.verify(token, jwtSecret);
    const result = await pool.query(
      `select id, email, name, profile_image_url, user_type, registration_status, created_at
       from users
       where id = $1`,
      [payload.sub],
    );

    if (result.rowCount === 0) {
      return res.status(401).json({ error: 'User not found' });
    }

    req.user = result.rows[0];
    return next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid bearer token' });
  }
}

app.get('/health', async (_req, res) => {
  await pool.query('select 1');
  res.json({ status: 'ok' });
});

app.get('/', (_req, res) => {
  res.json({
    name: 'Virtual Tigray API',
    status: 'ok',
    endpoints: [
      '/health',
      '/api/auth/login',
      '/api/auth/register',
      '/api/auth/me',
      '/api/professionals',
      '/api/tradespeople',
      '/api/businesses',
      '/api/education',
    ],
  });
});

app.post('/api/auth/register', async (req, res) => {
  const { name, email, password, user_type: userType } = req.body || {};

  if (!name || !email || !password || !userType) {
    return res.status(400).json({ error: 'name, email, password, and user_type are required' });
  }

  if (password.length < 8) {
    return res.status(400).json({ error: 'Password must be at least 8 characters' });
  }

  const normalizedEmail = String(email).trim().toLowerCase();
  const passwordHash = await bcrypt.hash(password, 12);

  try {
    const result = await pool.query(
      `insert into users (name, email, password_hash, user_type)
       values ($1, $2, $3, $4)
       returning id, email, name, profile_image_url, user_type, registration_status, created_at`,
      [String(name).trim(), normalizedEmail, passwordHash, userType],
    );

    return res.status(201).json({ user: publicUser(result.rows[0]) });
  } catch (error) {
    if (error.code === '23505') {
      return res.status(409).json({ error: 'Email already registered' });
    }

    console.error('Registration failed', error);
    return res.status(500).json({ error: 'Registration failed' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body || {};

  if (!email || !password) {
    return res.status(400).json({ error: 'email and password are required' });
  }

  const result = await pool.query(
    `select id, email, name, profile_image_url, user_type, registration_status, created_at, password_hash
     from users
     where email = $1`,
    [String(email).trim().toLowerCase()],
  );

  if (result.rowCount === 0) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }

  const user = result.rows[0];
  const matches = await bcrypt.compare(password, user.password_hash);

  if (!matches) {
    return res.status(401).json({ error: 'Invalid email or password' });
  }

  return res.json({
    access_token: signToken(user),
    user: publicUser(user),
  });
});

app.get('/api/auth/me', requireAuth, (req, res) => {
  res.json(publicUser(req.user));
});

app.get('/api/professionals', async (_req, res) => {
  const result = await pool.query(
    `select id, name, title, organization, location, email, skills, bio, created_at
     from professionals
     order by name`,
  );
  res.json({ data: result.rows });
});

app.get('/api/tradespeople', async (_req, res) => {
  const result = await pool.query(
    `select id, name, trade, location, phone, rating, description, created_at
     from tradespeople
     order by name`,
  );
  res.json({ data: result.rows });
});

app.get('/api/businesses', async (_req, res) => {
  const result = await pool.query(
    `select id, name, category, location, phone, website, description, created_at
     from businesses
     order by name`,
  );
  res.json({ data: result.rows });
});

app.get('/api/education', async (_req, res) => {
  const result = await pool.query(
    `select id, title, provider, level, deadline, link, description, created_at
     from education_opportunities
     order by deadline nulls last, title`,
  );
  res.json({ data: result.rows });
});

app.use((_req, res) => {
  res.status(404).json({ error: 'Not found' });
});

initializeDatabase()
  .then(() => {
    app.listen(port, '0.0.0.0', () => {
      console.log(`Virtual Tigray API listening on port ${port}`);
    });
  })
  .catch((error) => {
    console.error('Failed to initialize database', error);
    process.exit(1);
  });
