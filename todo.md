# CampusPulse Supabase Upgrade Todo

## Infrastructure and configuration
- [x] Read fullstack and connector guidance
- [x] Upgrade project to database-capable infrastructure if required
- [x] Add Supabase URL/key configuration guidance without committing secrets
- [x] Add typed Supabase client and connection-status handling

## Database and services
- [x] Define SQL schema for events, clubs, announcements, resources, and campus_locations
- [x] Add safe seed/migration guidance without inserting fabricated live data
- [x] Replace hardcoded reads with Supabase adapters and loading/error/empty states
- [x] Add date-aware upcoming-event filtering and sorting

## Functional pages
- [x] Make Events dynamic with category/date filters
- [x] Make Clubs dynamic with search, category filtering, and details
- [x] Make Announcements dynamic and newest-first
- [x] Keep Resources dynamic and link-safe
- [x] Make Campus Map use configured Google embed or OpenStreetMap fallback
- [x] Add admin-ready `/admin` route with authorization-aware UI states

## Verification and delivery
- [x] Audit for hardcoded production data and secret leakage
- [x] Run TypeScript checks and production build
- [x] Verify representative desktop/mobile routes
- [x] Save checkpoint and deliver
- [x] Implement conditional Google Maps Embed rendering when a configured key/embed setting is present, with OpenStreetMap fallback
- [x] Re-run representative route verification on mobile viewports after the Supabase changes

## BNMIT seed data
- [x] Audit the existing verified BNMIT records and Supabase column mappings
- [x] Generate an idempotent seed SQL file for clubs, departments, resources, and campus_locations only
- [x] Leave events and announcements empty in the seed file
- [x] Validate the seed SQL syntax and deliver the file without changing frontend code
- [ ] User runs `supabase/seed_bnmit.sql` in the Supabase SQL Editor and confirms successful execution

## Supabase Auth and RLS review
- [x] Audit current auth, schema, and admin route
- [x] Draft proposed Supabase Auth and RLS structure
- [x] Present SQL policies for explicit user approval before applying changes
- [x] Implement approved policies and RLS-enforced admin writes through the Supabase client
- [ ] Test anonymous, authenticated, and admin read/write behavior
- [x] Implement approved Supabase email/password Auth and RLS enforcement after the user’s approval
- [x] Apply the approved Auth/RLS SQL to the selected Supabase project or obtain authenticated SQL-editor execution
- [ ] Verify anonymous, student, and admin RLS read/write behavior end to end
- [x] Keep admin writes disabled until the RLS tests pass, then document the enablement step
- [x] Verify the applied Auth/RLS policies through policy visibility and authenticated route checks
- [x] User confirmed the Auth/RLS SQL was run in Supabase SQL Editor
- [x] Verify a Supabase Auth student session is denied access to admin writes
- [x] Verify the Supabase Auth admin session is recognized by CampusPulse without enabling CampusPulse writes
- [x] Resolve the CampusPulse preview maintenance/unavailable state and retest `/auth` and `/admin`
- [x] Add Supabase forgot-password request and password-update flow to `/auth`
- [x] Verify the recovery UI and rebuild without enabling admin writes
- [ ] Verify RLS with a real Supabase student session by attempting controlled insert/update/delete against events and announcements and confirm denial
- [x] Verify RLS with the real Supabase admin session using controlled non-production test writes, then document results before enabling browser writes
- [x] Add an obvious Supabase sign-out control so users can switch between student and admin sessions
- [x] Add a safe auth-page reset control that signs out and clears only the local Supabase session
- [x] Strengthen the auth reset to clear Supabase local/session storage and recovery URL state, not just sign out
- [x] Add Google OAuth sign-in with email/password fallback and preserve Supabase RLS role checks
- [x] Remove Google OAuth UI and code so CampusPulse uses only free Supabase email/password authentication
- [x] Diagnose admin session being denied by events and announcements RLS and repair only the admin allow path
- [x] Collect exact Supabase profile, policy, grant, and project-alignment diagnostics after the admin RLS repair remained denied
- [x] Add an authenticated `is_admin()` probe to the RLS diagnostics page to distinguish role lookup failure from table-policy failure
- [x] Add admin-only SELECT policies for unpublished events and announcements so controlled write tests and draft management can return rows safely
- [x] Enable protected admin event and announcement writes after successful admin RLS verification
- [x] Add an explicit Supabase project-alignment check comparing the app URL/project ref with the SQL Editor project before final delivery
- [x] Replace hardcoded placeholder event mutation values in `/admin` with real admin-editable fields and validation
- [x] Perform and record an explicit comparison between the `/rls-check` project ref and the Supabase SQL Editor project `xrvtgzdnwwetyswizils`
- [x] Verify an actual admin add-event and add-announcement submission end to end under RLS
- [x] Add explicit draft/publish controls to admin mutations so test submissions do not publish unverified content
- [x] Add a regression test guarding the admin form against fabricated placeholder event fields
