-- ============================================================
-- Muayadfit Cash Flow — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

create table if not exists cashflow_data (
  id          uuid        default gen_random_uuid() primary key,
  period_key  text        unique not null,   -- e.g. "2026-04"
  month       int2        not null,
  year        int4        not null,
  clients1    float4      default 0,
  clients2    float4      default 0,
  clients3    float4      default 0,
  expenses    jsonb       default '[]'::jsonb,
  sponsors    jsonb       default '[]'::jsonb,
  updated_at  timestamptz default now()
);

-- Auto-update updated_at on every change
create or replace function set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger cashflow_updated_at
  before update on cashflow_data
  for each row execute function set_updated_at();

-- Disable RLS (personal tool — no per-user auth needed)
alter table cashflow_data disable row level security;
