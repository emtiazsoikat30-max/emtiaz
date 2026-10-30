-- Run once in Supabase Dashboard → SQL Editor → New query.
-- The public website can submit a lead, but it can never read, update, or delete leads.
create table if not exists public.contact_leads (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 2 and 100),
  email text not null check (char_length(email) between 5 and 254),
  message text not null check (char_length(message) between 10 and 2000),
  created_at timestamptz not null default now()
);

alter table public.contact_leads enable row level security;

revoke all on table public.contact_leads from anon, authenticated;
grant insert on table public.contact_leads to anon;
grant usage on sequence public.contact_leads_id_seq to anon;

drop policy if exists "Anyone can submit a contact lead" on public.contact_leads;
create policy "Anyone can submit a contact lead"
  on public.contact_leads
  for insert
  to anon
  with check (true);
