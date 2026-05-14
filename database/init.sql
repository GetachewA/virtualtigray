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

create index if not exists users_email_idx on users (email);

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

create unique index if not exists professionals_email_unique_idx on professionals (email) where email is not null;
create unique index if not exists tradespeople_phone_unique_idx on tradespeople (phone) where phone is not null;
create unique index if not exists businesses_name_location_unique_idx on businesses (name, location);
create unique index if not exists education_title_provider_unique_idx on education_opportunities (title, provider);
