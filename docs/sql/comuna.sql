-- LOOP / Supabase — MER: comuna
-- Requiere: region.sql

create table if not exists public.comuna (
  id_comuna bigint generated always as identity primary key,
  nombre text not null,
  region_id_region bigint not null references public.region(id_region) on delete restrict,
  created_at timestamptz not null default now(),
  unique (nombre, region_id_region)
);

-- Migracion: si comuna ya existia con columna region (text), agregar FK y eliminar columna legacy.
alter table public.comuna add column if not exists region_id_region bigint references public.region(id_region) on delete restrict;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'comuna'
      and column_name = 'region'
  ) then
    update public.comuna c
    set region_id_region = r.id_region
    from public.region r
    where c.region_id_region is null
      and (
        (c.region = 'Metropolitana' and r.nombre = 'Metropolitana de Santiago')
        or (c.region = 'Valparaiso' and r.nombre = 'Valparaiso')
        or (c.region = 'Biobio' and r.nombre = 'Biobio')
        or (c.region = 'Araucania' and r.nombre = 'La Araucania')
        or (c.region = 'OHiggins' and r.nombre = 'O Higgins')
        or c.region = r.nombre
      );

    alter table public.comuna drop column if exists region;
  end if;
end $$;

insert into public.comuna (nombre, region_id_region)
select v.nombre, r.id_region
from (values
  ('Arica', 'Arica y Parinacota'),
  ('Camarones', 'Arica y Parinacota'),
  ('Putre', 'Arica y Parinacota'),
  ('General Lagos', 'Arica y Parinacota'),
  ('Iquique', 'Tarapaca'),
  ('Alto Hospicio', 'Tarapaca'),
  ('Pozo Almonte', 'Tarapaca'),
  ('Antofagasta', 'Antofagasta'),
  ('Calama', 'Antofagasta'),
  ('Mejillones', 'Antofagasta'),
  ('Tocopilla', 'Antofagasta'),
  ('Copiapo', 'Atacama'),
  ('Caldera', 'Atacama'),
  ('Vallenar', 'Atacama'),
  ('Chanaral', 'Atacama'),
  ('La Serena', 'Coquimbo'),
  ('Coquimbo', 'Coquimbo'),
  ('Ovalle', 'Coquimbo'),
  ('Illapel', 'Coquimbo'),
  ('Valparaiso', 'Valparaiso'),
  ('Vina del Mar', 'Valparaiso'),
  ('Quilpue', 'Valparaiso'),
  ('San Antonio', 'Valparaiso'),
  ('Santiago', 'Metropolitana de Santiago'),
  ('Puente Alto', 'Metropolitana de Santiago'),
  ('Maipu', 'Metropolitana de Santiago'),
  ('Las Condes', 'Metropolitana de Santiago'),
  ('La Florida', 'Metropolitana de Santiago'),
  ('Providencia', 'Metropolitana de Santiago'),
  ('Nunoa', 'Metropolitana de Santiago'),
  ('Rancagua', 'O Higgins'),
  ('San Fernando', 'O Higgins'),
  ('Rengo', 'O Higgins'),
  ('Santa Cruz', 'O Higgins'),
  ('Talca', 'Maule'),
  ('Curico', 'Maule'),
  ('Linares', 'Maule'),
  ('Constitucion', 'Maule'),
  ('Chillan', 'Nuble'),
  ('San Carlos', 'Nuble'),
  ('Bulnes', 'Nuble'),
  ('Quillon', 'Nuble'),
  ('Concepcion', 'Biobio'),
  ('Talcahuano', 'Biobio'),
  ('Los Angeles', 'Biobio'),
  ('Chiguayante', 'Biobio'),
  ('Temuco', 'La Araucania'),
  ('Padre Las Casas', 'La Araucania'),
  ('Villarrica', 'La Araucania'),
  ('Angol', 'La Araucania'),
  ('Valdivia', 'Los Rios'),
  ('La Union', 'Los Rios'),
  ('Rio Bueno', 'Los Rios'),
  ('Panguipulli', 'Los Rios'),
  ('Puerto Montt', 'Los Lagos'),
  ('Osorno', 'Los Lagos'),
  ('Castro', 'Los Lagos'),
  ('Puerto Varas', 'Los Lagos'),
  ('Coyhaique', 'Aysen'),
  ('Aysen', 'Aysen'),
  ('Chile Chico', 'Aysen'),
  ('Cochrane', 'Aysen'),
  ('Punta Arenas', 'Magallanes y de la Antartica Chilena'),
  ('Puerto Natales', 'Magallanes y de la Antartica Chilena'),
  ('Porvenir', 'Magallanes y de la Antartica Chilena'),
  ('Cabo de Hornos', 'Magallanes y de la Antartica Chilena')
) as v(nombre, region_nombre)
inner join public.region r on r.nombre = v.region_nombre
on conflict (nombre, region_id_region) do nothing;

create index if not exists idx_comuna_region
  on public.comuna(region_id_region);

alter table public.comuna enable row level security;

drop policy if exists comuna_select_authenticated on public.comuna;
create policy comuna_select_authenticated
on public.comuna
for select
to authenticated
using (true);
