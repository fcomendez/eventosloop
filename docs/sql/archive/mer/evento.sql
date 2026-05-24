-- LOOP / Supabase — MER: evento
-- Requiere: usuario.sql, comuna.sql
-- Opcional despues de comunidades.sql: FK comunidad_id_comunidad

create table if not exists public.evento (
  id_evento bigint generated always as identity primary key,
  nombre text not null,
  titulo text not null,
  descripcion text,
  ubicacion_direccion text,
  edad_min integer,
  edad_max integer,
  direccion text,
  cupos_max integer,
  latitud double precision,
  longitud double precision,
  fecha_creacion timestamptz not null default now(),
  fecha_realizacion timestamptz,
  estado text not null default 'ACTIVO',
  es_privado boolean not null default false,
  whatsapp_link text,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  comuna_id_comuna bigint references public.comuna(id_comuna) on delete set null,
  comunidad_id_comunidad bigint references public.comunidades(id_comunidad) on delete set null
);

create index if not exists idx_evento_creador
  on public.evento(usuario_id_usuario);

create index if not exists idx_evento_comuna
  on public.evento(comuna_id_comuna);

create index if not exists idx_evento_comunidad
  on public.evento(comunidad_id_comunidad);

create index if not exists idx_evento_fecha
  on public.evento(fecha_realizacion);

alter table public.evento enable row level security;

drop policy if exists evento_select_authenticated on public.evento;
create policy evento_select_authenticated
on public.evento
for select
to authenticated
using (estado = 'ACTIVO');

drop policy if exists evento_insert_own on public.evento;
create policy evento_insert_own
on public.evento
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists evento_update_owner on public.evento;
create policy evento_update_owner
on public.evento
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists evento_delete_owner on public.evento;
create policy evento_delete_owner
on public.evento
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
