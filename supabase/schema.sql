-- CampusPulse / BNMIT Supabase schema
-- Run this in the Supabase SQL editor. No fabricated seed rows are included.

create extension if not exists pgcrypto;

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null check (category in ('Technical','Cultural','Sports','Workshop','Competition','Club Event')),
  date_iso timestamptz,
  time text,
  location text,
  organizer text,
  seats integer check (seats is null or seats >= 0),
  capacity integer check (capacity is null or capacity >= 0),
  description text,
  image_url text,
  tags text[] not null default '{}',
  status text not null default 'official' check (status in ('official','demo')),
  registration_link text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.clubs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null default 'BNMIT student club',
  description text,
  faculty_coordinator text,
  student_coordinator text,
  official_url text,
  social_url text,
  members integer check (members is null or members >= 0),
  upcoming_event text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  priority text not null default 'General' check (priority in ('Important','General','Event','Academic')),
  published_at timestamptz not null default now(),
  unread boolean not null default true,
  official_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.resources (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  type text not null,
  status text not null default 'Unavailable' check (status in ('Available','Busy','Maintenance','Unavailable')),
  detail text,
  official_url text,
  capacity text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.campus_locations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  official_url text,
  latitude double precision,
  longitude double precision,
  x double precision,
  y double precision,
  status text not null default 'Available' check (status in ('Available','Busy','Maintenance','Unavailable')),
  hours text,
  availability text,
  activity text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists events_date_iso_idx on public.events (date_iso);
create index if not exists events_category_idx on public.events (category);
create index if not exists clubs_name_idx on public.clubs (name);
create index if not exists clubs_category_idx on public.clubs (category);
create index if not exists announcements_published_at_idx on public.announcements (published_at desc);

alter table public.events enable row level security;
alter table public.clubs enable row level security;
alter table public.announcements enable row level security;
alter table public.resources enable row level security;
alter table public.campus_locations enable row level security;

drop policy if exists "public can read events" on public.events;
create policy "public can read events" on public.events for select using (true);
drop policy if exists "public can read clubs" on public.clubs;
create policy "public can read clubs" on public.clubs for select using (true);
drop policy if exists "public can read announcements" on public.announcements;
create policy "public can read announcements" on public.announcements for select using (true);
drop policy if exists "public can read resources" on public.resources;
create policy "public can read resources" on public.resources for select using (true);
drop policy if exists "public can read locations" on public.campus_locations;
create policy "public can read locations" on public.campus_locations for select using (true);

-- Keep writes restricted until Supabase Auth/admin identity mapping is configured.
