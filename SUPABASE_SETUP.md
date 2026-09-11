# CampusPulse Supabase setup

CampusPulse reads the `events`, `clubs`, `announcements`, `resources`, and `campus_locations` tables through the browser-safe Supabase client. The frontend uses `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`; the service-role key is intentionally not used.

## Apply the schema

Open the Supabase SQL Editor for the project and run [`supabase/schema.sql`](./supabase/schema.sql). The migration creates the five tables, indexes, public read policies, and no fabricated seed rows.

## Add content

Populate rows from verified BNMIT sources. Events with a future `date_iso` appear in Upcoming; expired rows are filtered out in the client. Announcements are sorted by `published_at` descending. The Clubs and Resources pages query their tables and show explicit empty/error/unconfigured states.

## Admin access

The `/admin` route checks the existing CampusPulse/Manus user role and exposes event and announcement creation forms for an authorized admin. Supabase row-level security must be extended with the project’s chosen admin identity mapping before enabling writes in production. The public read policies do not grant public writes.

## Map behavior

The existing BNMIT OpenStreetMap fallback remains active with the verified campus coordinates and Google Maps/directions links. A future Google Maps embed can be added behind a configured key without changing the page layout.
