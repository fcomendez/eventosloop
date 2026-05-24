-- LOOP / Supabase — MER: region
-- Ejecutar antes de comuna.sql (comuna referencia region).

create table if not exists public.region (
  id_region bigint generated always as identity primary key,
  nombre text not null unique,
  created_at timestamptz not null default now()
);

insert into public.region (nombre)
values
  ('Arica y Parinacota'),
  ('Tarapaca'),
  ('Antofagasta'),
  ('Atacama'),
  ('Coquimbo'),
  ('Valparaiso'),
  ('Metropolitana de Santiago'),
  ('O Higgins'),
  ('Maule'),
  ('Nuble'),
  ('Biobio'),
  ('La Araucania'),
  ('Los Rios'),
  ('Los Lagos'),
  ('Aysen'),
  ('Magallanes y de la Antartica Chilena')
on conflict (nombre) do nothing;

alter table public.region enable row level security;

drop policy if exists region_select_authenticated on public.region;
create policy region_select_authenticated
on public.region
for select
to authenticated
using (true);
