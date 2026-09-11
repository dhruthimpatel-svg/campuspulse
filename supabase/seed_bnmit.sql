-- CampusPulse / BNMIT initial seed
-- Safe to run more than once. Uses only BNMIT records already verified in the project.
-- Intentionally contains no INSERT, UPDATE, or DELETE statements for events or announcements.

create table if not exists public.departments (
  id text primary key,
  name text not null,
  level text not null check (level in ('UG', 'PG', 'Foundation')),
  official_url text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.departments enable row level security;
drop policy if exists "public can read departments" on public.departments;
create policy "public can read departments" on public.departments for select using (true);

insert into public.clubs (id, name, category, description, faculty_coordinator, student_coordinator, official_url, social_url, members, upcoming_event)
values
  ('10000000-0000-4000-8000-000000000001', 'Nature Club', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/nature-club/', null, null, null),
  ('10000000-0000-4000-8000-000000000002', 'Tech-IT', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000003', 'Nexus Community', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000004', 'MUN', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000005', 'Evocative Voices', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000006', 'Kala Bhageerathi', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/students-life/cultural-kala-bhageerathi/', null, null, null),
  ('10000000-0000-4000-8000-000000000007', 'RPA', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000008', 'Under25xBNMIT', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000009', 'Q-Quotient', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000010', 'Bloom', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000011', 'Siggraph', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000012', 'TEDx BNMIT', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000013', 'Animatrix', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000014', 'Adventure Club', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/home/adventure-club/', null, null, null),
  ('10000000-0000-4000-8000-000000000015', 'RoboHawks', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null),
  ('10000000-0000-4000-8000-000000000016', 'HashVault', 'BNMIT student club', null, null, null, 'https://www.bnmit.org/clubs/', null, null, null)
on conflict (id) do update set
  name = excluded.name,
  category = excluded.category,
  description = excluded.description,
  faculty_coordinator = excluded.faculty_coordinator,
  student_coordinator = excluded.student_coordinator,
  official_url = excluded.official_url,
  social_url = excluded.social_url,
  members = excluded.members,
  upcoming_event = excluded.upcoming_event,
  updated_at = now();

insert into public.departments (id, name, level, official_url)
values
  ('department-1', 'Artificial Intelligence & Machine Learning', 'UG', 'https://www.bnmit.org/artificial-intelligence-machine-learning/'),
  ('department-2', 'Computer Science & Engineering', 'UG', 'https://www.bnmit.org/computer-science-engineering/'),
  ('department-3', 'Electronics & Communication Engineering', 'UG', 'https://www.bnmit.org/electronics-communication-engineering/'),
  ('department-4', 'Electrical & Electronics Engineering', 'UG', 'https://www.bnmit.org/electrical-electronics-engineering/'),
  ('department-5', 'Information Science & Engineering', 'UG', 'https://www.bnmit.org/information-science-engineering/'),
  ('department-6', 'Mechanical Engineering', 'UG', 'https://www.bnmit.org/mechanical-engineering/'),
  ('department-7', 'Business Administration', 'PG', 'https://www.bnmit.org/mba/'),
  ('department-8', 'Mathematics', 'Foundation', 'https://www.bnmit.org/department-of-mathematics/'),
  ('department-9', 'Physics', 'Foundation', 'https://www.bnmit.org/department-of-physics/'),
  ('department-10', 'Chemistry', 'Foundation', 'https://www.bnmit.org/department-of-chemistry/'),
  ('department-11', 'Humanities', 'Foundation', 'https://www.bnmit.org/department-of-humanities/')
on conflict (id) do update set
  name = excluded.name,
  level = excluded.level,
  official_url = excluded.official_url,
  updated_at = now();

insert into public.resources (id, name, type, status, detail, official_url, capacity)
values
  ('20000000-0000-4000-8000-000000000001', 'Library and Information Center', 'Student resource', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/library-information-centre/', null),
  ('20000000-0000-4000-8000-000000000002', 'Campus Tour', 'Campus facility', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/campus-tour/', null),
  ('20000000-0000-4000-8000-000000000003', 'Main Block', 'Infrastructure', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/about-us/main-block/', null),
  ('20000000-0000-4000-8000-000000000004', 'New Block', 'Infrastructure', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/about-us/new-block/', null),
  ('20000000-0000-4000-8000-000000000005', 'Auditorium Block', 'Infrastructure', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/about-us/auditorium-block/', null),
  ('20000000-0000-4000-8000-000000000006', 'S Block', 'Infrastructure', 'Unavailable', 'Information unavailable in the current official sync.', 'https://www.bnmit.org/about-us/s-block/', null)
on conflict (id) do update set
  name = excluded.name,
  type = excluded.type,
  status = excluded.status,
  detail = excluded.detail,
  official_url = excluded.official_url,
  capacity = excluded.capacity,
  updated_at = now();

insert into public.campus_locations (id, name, description, official_url, latitude, longitude, x, y, status, hours, availability, activity)
values
  ('30000000-0000-4000-8000-000000000001', 'B. N. M. Institute of Technology', 'Post Box No. 7087, 12th Main Road, 27th Cross, Banashankari II Stage, Bangalore – 560070', 'https://www.bnmit.org/', 12.921883, 77.5675933, null, null, 'Unavailable', null, null, null)
on conflict (id) do update set
  name = excluded.name,
  description = excluded.description,
  official_url = excluded.official_url,
  latitude = excluded.latitude,
  longitude = excluded.longitude,
  x = excluded.x,
  y = excluded.y,
  status = excluded.status,
  hours = excluded.hours,
  availability = excluded.availability,
  activity = excluded.activity,
  updated_at = now();

-- events and announcements intentionally remain unchanged and empty.
