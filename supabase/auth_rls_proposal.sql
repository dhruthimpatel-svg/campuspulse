-- CampusPulse Supabase Auth + RLS proposal
-- REVIEW ONLY: do not run until the policy design is approved and tested.
-- This file contains no service-role key and is not executed by CampusPulse.

-- 1. Supabase Auth identity profile.
-- Supabase Auth owns authentication in auth.users. This table stores the app role.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null default 'student' check (role in ('student', 'admin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

drop policy if exists "users can read own profile" on public.profiles;
create policy "users can read own profile"
  on public.profiles for select
  to authenticated
  using (id = auth.uid());

-- New Supabase Auth users start as students. Admin promotion is a deliberate
-- operator action in the SQL editor; it is never accepted from browser input.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, role)
  values (new.id, 'student')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- The security-definer helper prevents policy recursion and reads only the
-- trusted profile row for the current Supabase Auth subject.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

-- 2. Add explicit publication flags. These are additive and preserve existing rows.
alter table public.events add column if not exists is_published boolean not null default true;
alter table public.clubs add column if not exists is_published boolean not null default true;
alter table public.announcements add column if not exists is_published boolean not null default true;
alter table public.resources add column if not exists is_published boolean not null default true;
alter table public.campus_locations add column if not exists is_published boolean not null default true;

-- 3. Replace permissive public-read policies with published-row policies.
-- The DROP statements replace policy definitions only; they do not delete data.
drop policy if exists "public can read events" on public.events;
drop policy if exists "public can read published events" on public.events;
create policy "public can read published events"
  on public.events for select
  to anon, authenticated
  using (is_published = true);

drop policy if exists "public can read clubs" on public.clubs;
drop policy if exists "public can read published clubs" on public.clubs;
create policy "public can read published clubs"
  on public.clubs for select
  to anon, authenticated
  using (is_published = true);

drop policy if exists "public can read announcements" on public.announcements;
drop policy if exists "public can read published announcements" on public.announcements;
create policy "public can read published announcements"
  on public.announcements for select
  to anon, authenticated
  using (is_published = true);

drop policy if exists "public can read resources" on public.resources;
drop policy if exists "public can read published resources" on public.resources;
create policy "public can read published resources"
  on public.resources for select
  to anon, authenticated
  using (is_published = true);

drop policy if exists "public can read locations" on public.campus_locations;
drop policy if exists "public can read published locations" on public.campus_locations;
create policy "public can read published locations"
  on public.campus_locations for select
  to anon, authenticated
  using (is_published = true);

-- 4. Explicit admin-only write policies. These are intentionally absent from
-- production until Auth identity + is_admin() have been tested.
drop policy if exists "admins can insert events" on public.events;
create policy "admins can insert events"
  on public.events for insert
  to authenticated
  with check (public.is_admin());

drop policy if exists "admins can update events" on public.events;
create policy "admins can update events"
  on public.events for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "admins can delete events" on public.events;
create policy "admins can delete events"
  on public.events for delete
  to authenticated
  using (public.is_admin());

drop policy if exists "admins can insert announcements" on public.announcements;
create policy "admins can insert announcements"
  on public.announcements for insert
  to authenticated
  with check (public.is_admin());

drop policy if exists "admins can update announcements" on public.announcements;
create policy "admins can update announcements"
  on public.announcements for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());

drop policy if exists "admins can delete announcements" on public.announcements;
create policy "admins can delete announcements"
  on public.announcements for delete
  to authenticated
  using (public.is_admin());

-- 5. Optional operator action, to be run only after the admin user's Auth UUID
-- is known and the RLS test plan has passed:
-- update public.profiles set role = 'admin', updated_at = now()
-- where id = '<SUPABASE_AUTH_USER_UUID>';

-- 6. Verification queries to run in a non-production/test project first:
-- select relname, relrowsecurity from pg_class where relname in
-- ('profiles','events','clubs','announcements','resources','campus_locations');
-- select policyname, tablename, roles, cmd from pg_policies
-- where schemaname = 'public' and tablename in
-- ('events','announcements','clubs','resources','campus_locations');
