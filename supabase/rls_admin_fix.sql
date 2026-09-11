-- CampusPulse: safe admin RLS allow-path repair
-- Run in the SAME Supabase project used by VITE_SUPABASE_URL.
-- This does not expose a service-role key and does not disable RLS.

-- Confirm the promoted profile before/after applying this patch:
-- select id, role, length(role) from public.profiles
-- where id = '<ADMIN_AUTH_USER_UUID>';

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public, pg_temp
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

alter table public.events enable row level security;
alter table public.announcements enable row level security;

drop policy if exists "admins can read all events" on public.events;
create policy "admins can read all events"
  on public.events for select
  to authenticated
  using (public.is_admin());

drop policy if exists "admins can read all announcements" on public.announcements;
create policy "admins can read all announcements"
  on public.announcements for select
  to authenticated
  using (public.is_admin());

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

-- If the profile row is missing, run this separately after replacing the UUID:
-- insert into public.profiles (id, role)
-- values ('<ADMIN_AUTH_USER_UUID>', 'admin')
-- on conflict (id) do update set role = 'admin', updated_at = now();

-- Verify policy attachment without changing data:
-- select policyname, tablename, cmd, roles, qual, with_check
-- from pg_policies
-- where schemaname = 'public'
--   and tablename in ('events', 'announcements')
-- order by tablename, cmd, policyname;
