-- CampusPulse: read-only admin RLS diagnostics
-- Run in the SAME Supabase project where the Auth user and tables live.
-- Replace <ADMIN_AUTH_USER_UUID> with the UUID from Authentication -> Users.

select id, role, length(role) as role_length, quote_literal(role) as exact_role
from public.profiles
where id = '<ADMIN_AUTH_USER_UUID>';

select relname as table_name, relrowsecurity as rls_enabled, relforcerowsecurity as force_rls
from pg_class
where oid in ('public.events'::regclass, 'public.announcements'::regclass);

select policyname, tablename, permissive, roles, cmd, qual, with_check
from pg_policies
where schemaname = 'public'
  and tablename in ('events', 'announcements')
order by tablename, cmd, policyname;

select
  has_table_privilege('authenticated', 'public.events', 'INSERT') as authenticated_can_insert_events,
  has_table_privilege('authenticated', 'public.events', 'UPDATE') as authenticated_can_update_events,
  has_table_privilege('authenticated', 'public.events', 'DELETE') as authenticated_can_delete_events,
  has_table_privilege('authenticated', 'public.announcements', 'INSERT') as authenticated_can_insert_announcements,
  has_table_privilege('authenticated', 'public.announcements', 'UPDATE') as authenticated_can_update_announcements,
  has_table_privilege('authenticated', 'public.announcements', 'DELETE') as authenticated_can_delete_announcements;

select n.nspname as schema_name, p.proname, p.prosecdef as security_definer, p.proconfig
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public' and p.proname = 'is_admin';
