-- LOOP â€” Esquema completo (tablas, RLS, RPCs)
-- Sin datos de catalogo ni demo. Ejecutar con scripts/apply-schema.ps1
-- Idempotente: se puede re-ejecutar en desarrollo.

-- LOOP / Supabase â€” MER: region
-- Ejecutar antes de comuna.sql (comuna referencia region).

create table if not exists public.region (
  id_region bigint generated always as identity primary key,
  nombre text not null unique,
  created_at timestamptz not null default now()
);


alter table public.region enable row level security;

drop policy if exists region_select_authenticated on public.region;
create policy region_select_authenticated
on public.region
for select
to authenticated
using (true);
-- LOOP / Supabase â€” MER: comuna
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


create index if not exists idx_comuna_region
  on public.comuna(region_id_region);

alter table public.comuna enable row level security;

drop policy if exists comuna_select_authenticated on public.comuna;
create policy comuna_select_authenticated
on public.comuna
for select
to authenticated
using (true);
-- LOOP / Supabase â€” MER: usuario
-- Requiere: comuna.sql
-- password_hash va en auth.users (Supabase Auth).

create table if not exists public.usuario (
  id_usuario bigint generated always as identity primary key,
  auth_user_id uuid unique references auth.users(id) on delete cascade,
  email text unique not null,
  username text unique,
  nombres text,
  apellidos text,
  fecha_nacimiento date,
  fecha_registro timestamptz not null default now(),
  genero text,
  token_recuperacion text,
  expiracion_token timestamptz,
  avatar_url text,
  estado_cuenta text not null default 'ACTIVO',
  rol_user text not null default 'USER',
  comuna_id_comuna bigint references public.comuna(id_comuna) on delete set null
);

create index if not exists idx_usuario_auth_user_id
  on public.usuario(auth_user_id);

create index if not exists idx_usuario_comuna
  on public.usuario(comuna_id_comuna);

alter table public.usuario enable row level security;

drop policy if exists usuario_select_authenticated on public.usuario;
create policy usuario_select_authenticated
on public.usuario
for select
to authenticated
using (estado_cuenta = 'ACTIVO');

drop policy if exists usuario_insert_own on public.usuario;
create policy usuario_insert_own
on public.usuario
for insert
to authenticated
with check (auth_user_id = auth.uid());

drop policy if exists usuario_update_own on public.usuario;
create policy usuario_update_own
on public.usuario
for update
to authenticated
using (auth_user_id = auth.uid())
with check (auth_user_id = auth.uid());
-- LOOP / Supabase
-- MER: tablas maestras de intereses + tabla puente usuario_intereses

create table if not exists public.intereses (
  id_interes bigint generated always as identity primary key,
  categoria text not null default 'GENERAL',
  nombre text not null unique,
  slug text not null unique,
  icono text,
  color_hex text default '#0682BC',
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.intereses
  add column if not exists categoria text not null default 'GENERAL';

create table if not exists public.usuario_intereses (
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  id_interes bigint not null references public.intereses(id_interes) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (auth_user_id, id_interes)
);

create index if not exists idx_usuario_intereses_user
  on public.usuario_intereses(auth_user_id);

create index if not exists idx_usuario_intereses_interes
  on public.usuario_intereses(id_interes);

alter table public.intereses enable row level security;
alter table public.usuario_intereses enable row level security;

-- Catalogo de intereses: lectura para usuarios autenticados
drop policy if exists intereses_select_authenticated on public.intereses;
create policy intereses_select_authenticated
on public.intereses
for select
to authenticated
using (activo = true);

-- Tabla puente: cada usuario solo puede leer/escribir sus intereses
drop policy if exists usuario_intereses_select_own on public.usuario_intereses;
create policy usuario_intereses_select_own
on public.usuario_intereses
for select
to authenticated
using (auth_user_id = auth.uid());

drop policy if exists usuario_intereses_insert_own on public.usuario_intereses;
create policy usuario_intereses_insert_own
on public.usuario_intereses
for insert
to authenticated
with check (auth_user_id = auth.uid());

drop policy if exists usuario_intereses_delete_own on public.usuario_intereses;
create policy usuario_intereses_delete_own
on public.usuario_intereses
for delete
to authenticated
using (auth_user_id = auth.uid());

-- LOOP / Supabase â€” MER: comunidades
-- Requiere: usuario.sql

create table if not exists public.comunidades (
  id_comunidad bigint generated always as identity primary key,
  nombre text not null,
  descripcion text,
  banner_url text,
  privacidad text not null default 'PUBLICA',
  fecha_creacion timestamptz not null default now(),
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade
);

create index if not exists idx_comunidades_creador
  on public.comunidades(usuario_id_usuario);

alter table public.comunidades enable row level security;

drop policy if exists comunidades_select_authenticated on public.comunidades;
create policy comunidades_select_authenticated
on public.comunidades
for select
to authenticated
using (true);

drop policy if exists comunidades_insert_own on public.comunidades;
create policy comunidades_insert_own
on public.comunidades
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comunidades_update_owner on public.comunidades;
create policy comunidades_update_owner
on public.comunidades
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comunidades_delete_owner on public.comunidades;
create policy comunidades_delete_owner
on public.comunidades
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: miembro_comunidad
-- Requiere: comunidades.sql, usuario.sql

create table if not exists public.miembro_comunidad (
  id_comunidad bigint not null references public.comunidades(id_comunidad) on delete cascade,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  rol text not null default 'MIEMBRO',
  fecha_union timestamptz not null default now(),
  primary key (id_comunidad, usuario_id_usuario)
);

create index if not exists idx_miembro_comunidad_usuario
  on public.miembro_comunidad(usuario_id_usuario);

alter table public.miembro_comunidad enable row level security;

drop policy if exists miembro_comunidad_select_authenticated on public.miembro_comunidad;
create policy miembro_comunidad_select_authenticated
on public.miembro_comunidad
for select
to authenticated
using (true);

drop policy if exists miembro_comunidad_insert_own on public.miembro_comunidad;
create policy miembro_comunidad_insert_own
on public.miembro_comunidad
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists miembro_comunidad_delete_own on public.miembro_comunidad;
create policy miembro_comunidad_delete_own
on public.miembro_comunidad
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: evento
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
  cover_url text,
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
-- LOOP / Supabase â€” MER: participantes_evento
-- Requiere: evento.sql, usuario.sql
-- Nota MER: se agrega usuario_id_usuario (necesario para inscripciones y solicitudes).

create table if not exists public.participantes_evento (
  id_participacion bigint generated always as identity primary key,
  evento_id_evento bigint not null references public.evento(id_evento) on delete cascade,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  estado_solicitud text not null default 'PENDIENTE',
  fecha_solicitud timestamptz not null default now(),
  unique (evento_id_evento, usuario_id_usuario)
);

create index if not exists idx_participantes_evento_usuario
  on public.participantes_evento(usuario_id_usuario);

create index if not exists idx_participantes_evento_estado
  on public.participantes_evento(estado_solicitud);

alter table public.participantes_evento enable row level security;

drop policy if exists participantes_evento_select_authenticated on public.participantes_evento;
create policy participantes_evento_select_authenticated
on public.participantes_evento
for select
to authenticated
using (true);

drop policy if exists participantes_evento_insert_own on public.participantes_evento;
create policy participantes_evento_insert_own
on public.participantes_evento
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists participantes_evento_update_owner_or_organizer on public.participantes_evento;
create policy participantes_evento_update_owner_or_organizer
on public.participantes_evento
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or evento_id_evento in (
    select e.id_evento
    from public.evento e
    inner join public.usuario u on u.id_usuario = e.usuario_id_usuario
    where u.auth_user_id = auth.uid()
  )
);

drop policy if exists participantes_evento_delete_own on public.participantes_evento;
create policy participantes_evento_delete_own
on public.participantes_evento
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: publicaciones
-- Requiere: usuario.sql, comunidades.sql

create table if not exists public.publicaciones (
  id_post bigint generated always as identity primary key,
  titulo text,
  contenido text not null,
  url_media text,
  fecha_publicacion timestamptz not null default now(),
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  comunidades_id_comunidad bigint references public.comunidades(id_comunidad) on delete set null
);

create index if not exists idx_publicaciones_usuario
  on public.publicaciones(usuario_id_usuario);

create index if not exists idx_publicaciones_comunidad
  on public.publicaciones(comunidades_id_comunidad);

create index if not exists idx_publicaciones_fecha
  on public.publicaciones(fecha_publicacion desc);

alter table public.publicaciones enable row level security;

drop policy if exists publicaciones_select_authenticated on public.publicaciones;
create policy publicaciones_select_authenticated
on public.publicaciones
for select
to authenticated
using (true);

drop policy if exists publicaciones_insert_own on public.publicaciones;
create policy publicaciones_insert_own
on public.publicaciones
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists publicaciones_update_own on public.publicaciones;
create policy publicaciones_update_own
on public.publicaciones
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists publicaciones_delete_own on public.publicaciones;
create policy publicaciones_delete_own
on public.publicaciones
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: comentario
-- Requiere: publicaciones.sql, usuario.sql

create table if not exists public.comentario (
  id_comentario bigint generated always as identity primary key,
  texto_comentario text not null,
  fecha_comentario timestamptz not null default now(),
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  publicaciones_id_post bigint not null references public.publicaciones(id_post) on delete cascade
);

create index if not exists idx_comentario_post
  on public.comentario(publicaciones_id_post);

create index if not exists idx_comentario_usuario
  on public.comentario(usuario_id_usuario);

alter table public.comentario enable row level security;

drop policy if exists comentario_select_authenticated on public.comentario;
create policy comentario_select_authenticated
on public.comentario
for select
to authenticated
using (true);

drop policy if exists comentario_insert_own on public.comentario;
create policy comentario_insert_own
on public.comentario
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comentario_update_own on public.comentario;
create policy comentario_update_own
on public.comentario
for update
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists comentario_delete_own on public.comentario;
create policy comentario_delete_own
on public.comentario
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: reacciones_post
-- Requiere: publicaciones.sql, usuario.sql

create table if not exists public.reacciones_post (
  id_reaccion bigint generated always as identity primary key,
  tipo_reaccion text not null default 'LIKE',
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  publicaciones_id_post bigint not null references public.publicaciones(id_post) on delete cascade,
  unique (usuario_id_usuario, publicaciones_id_post)
);

create index if not exists idx_reacciones_post_publicacion
  on public.reacciones_post(publicaciones_id_post);

alter table public.reacciones_post enable row level security;

drop policy if exists reacciones_post_select_authenticated on public.reacciones_post;
create policy reacciones_post_select_authenticated
on public.reacciones_post
for select
to authenticated
using (true);

drop policy if exists reacciones_post_insert_own on public.reacciones_post;
create policy reacciones_post_insert_own
on public.reacciones_post
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists reacciones_post_delete_own on public.reacciones_post;
create policy reacciones_post_delete_own
on public.reacciones_post
for delete
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: seguidores
-- Requiere: usuario.sql
-- Nota: tienev2 del MER no se usa; esta tabla cubre la relacion directamente.

create table if not exists public.seguidores (
  id_usuario_seguidor bigint not null references public.usuario(id_usuario) on delete cascade,
  id_usuario_seguido bigint not null references public.usuario(id_usuario) on delete cascade,
  fecha_follow timestamptz not null default now(),
  primary key (id_usuario_seguidor, id_usuario_seguido),
  check (id_usuario_seguidor <> id_usuario_seguido)
);

create index if not exists idx_seguidores_seguido
  on public.seguidores(id_usuario_seguido);

alter table public.seguidores enable row level security;

drop policy if exists seguidores_select_authenticated on public.seguidores;
create policy seguidores_select_authenticated
on public.seguidores
for select
to authenticated
using (true);

drop policy if exists seguidores_insert_own on public.seguidores;
create policy seguidores_insert_own
on public.seguidores
for insert
to authenticated
with check (
  id_usuario_seguidor in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists seguidores_delete_own on public.seguidores;
create policy seguidores_delete_own
on public.seguidores
for delete
to authenticated
using (
  id_usuario_seguidor in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);
-- LOOP / Supabase â€” MER: roles_sistema
-- Requiere: usuario.sql
-- Asignacion de roles administrativos por usuario (ADMIN, MODERADOR, etc.).

create table if not exists public.roles_sistema (
  id_roll bigint generated always as identity primary key,
  nombre_rol text not null,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  created_at timestamptz not null default now(),
  unique (usuario_id_usuario, nombre_rol)
);

create index if not exists idx_roles_sistema_usuario
  on public.roles_sistema(usuario_id_usuario);

create index if not exists idx_roles_sistema_nombre
  on public.roles_sistema(nombre_rol);

-- Helper para politicas RLS de moderacion/auditoria.
create or replace function public.es_admin_o_moderador()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.roles_sistema rs
    inner join public.usuario u on u.id_usuario = rs.usuario_id_usuario
    where u.auth_user_id = auth.uid()
      and rs.nombre_rol in ('ADMIN', 'MODERADOR')
  )
  or exists (
    select 1
    from public.usuario u
    where u.auth_user_id = auth.uid()
      and u.rol_user in ('ADMIN', 'MODERADOR')
  );
$$;

alter table public.roles_sistema enable row level security;

drop policy if exists roles_sistema_select_authenticated on public.roles_sistema;
create policy roles_sistema_select_authenticated
on public.roles_sistema
for select
to authenticated
using (true);

drop policy if exists roles_sistema_insert_admin on public.roles_sistema;
create policy roles_sistema_insert_admin
on public.roles_sistema
for insert
to authenticated
with check (public.es_admin_o_moderador());

drop policy if exists roles_sistema_update_admin on public.roles_sistema;
create policy roles_sistema_update_admin
on public.roles_sistema
for update
to authenticated
using (public.es_admin_o_moderador());

drop policy if exists roles_sistema_delete_admin on public.roles_sistema;
create policy roles_sistema_delete_admin
on public.roles_sistema
for delete
to authenticated
using (public.es_admin_o_moderador());
-- LOOP / Supabase â€” MER: reporte_publicacion
-- Requiere: publicaciones.sql, usuario.sql, roles_sistema.sql (funcion es_admin_o_moderador)

create table if not exists public.reporte_publicacion (
  id_reporte bigint generated always as identity primary key,
  motivo text not null,
  descripcion text,
  estado text not null default 'PENDIENTE',
  fecha_reporte timestamptz not null default now(),
  fecha_resolucion timestamptz,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  publicaciones_id_post bigint not null references public.publicaciones(id_post) on delete cascade,
  moderador_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_reporte_publicacion_post
  on public.reporte_publicacion(publicaciones_id_post);

create index if not exists idx_reporte_publicacion_estado
  on public.reporte_publicacion(estado);

create index if not exists idx_reporte_publicacion_reporter
  on public.reporte_publicacion(usuario_id_usuario);

alter table public.reporte_publicacion enable row level security;

drop policy if exists reporte_publicacion_select_own_or_admin on public.reporte_publicacion;
create policy reporte_publicacion_select_own_or_admin
on public.reporte_publicacion
for select
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or public.es_admin_o_moderador()
);

drop policy if exists reporte_publicacion_insert_own on public.reporte_publicacion;
create policy reporte_publicacion_insert_own
on public.reporte_publicacion
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists reporte_publicacion_update_admin on public.reporte_publicacion;
create policy reporte_publicacion_update_admin
on public.reporte_publicacion
for update
to authenticated
using (public.es_admin_o_moderador());
-- LOOP / Supabase â€” MER: adm_log
-- Requiere: usuario.sql, roles_sistema.sql (funcion es_admin_o_moderador)
-- Auditoria de acciones administrativas (moderacion, cambios de rol, etc.).

create table if not exists public.adm_log (
  id_log bigint generated always as identity primary key,
  accion_realizada text not null,
  detalle text,
  entidad_tipo text,
  entidad_id bigint,
  fecha_accion timestamptz not null default now(),
  usuario_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_adm_log_fecha
  on public.adm_log(fecha_accion desc);

create index if not exists idx_adm_log_usuario
  on public.adm_log(usuario_id_usuario);

create index if not exists idx_adm_log_entidad
  on public.adm_log(entidad_tipo, entidad_id);

alter table public.adm_log enable row level security;

drop policy if exists adm_log_select_admin on public.adm_log;
create policy adm_log_select_admin
on public.adm_log
for select
to authenticated
using (public.es_admin_o_moderador());

drop policy if exists adm_log_insert_admin on public.adm_log;
create policy adm_log_insert_admin
on public.adm_log
for insert
to authenticated
with check (
  public.es_admin_o_moderador()
  and (
    usuario_id_usuario is null
    or usuario_id_usuario in (
      select id_usuario from public.usuario where auth_user_id = auth.uid()
    )
  )
);
-- LOOP / Supabase
-- RPC: guardar intereses de usuario de forma atomica (transaccional).
-- Si falla el insert, el delete se revierte automaticamente.

create or replace function public.guardar_intereses_usuario(ids bigint[])
returns void
language plpgsql
security invoker
as $$
begin
  delete from public.usuario_intereses
  where auth_user_id = auth.uid();

  insert into public.usuario_intereses (auth_user_id, id_interes)
  select auth.uid(), unnest(ids);
end;
$$;


-- ---------------------------------------------------------------------------
-- Comunidades fase 2: estado, intereses puente, RLS avanzada, RPCs
-- ---------------------------------------------------------------------------
-- LOOP â€” Fase 2 comunidades: estado, intereses, RLS privacidad, RPCs admin/moderadores
-- Ejecutar DESPUES de apply-schema.ps1 (re-ejecutable)

-- Helpers
create or replace function public.usuario_actual_id()
returns bigint
language sql
stable
security definer
set search_path = public
as $$
  select id_usuario from public.usuario where auth_user_id = auth.uid() limit 1;
$$;

create or replace function public.es_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.usuario u
    where u.auth_user_id = auth.uid()
      and u.rol_user = 'ADMIN'
  )
  or exists (
    select 1
    from public.roles_sistema rs
    inner join public.usuario u on u.id_usuario = rs.usuario_id_usuario
    where u.auth_user_id = auth.uid()
      and rs.nombre_rol = 'ADMIN'
  );
$$;

create or replace function public.es_miembro_comunidad(p_comunidad_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.miembro_comunidad mc
    where mc.id_comunidad = p_comunidad_id
      and mc.usuario_id_usuario = public.usuario_actual_id()
  );
$$;

create or replace function public.es_lider_comunidad(p_comunidad_id bigint)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.miembro_comunidad mc
    where mc.id_comunidad = p_comunidad_id
      and mc.usuario_id_usuario = public.usuario_actual_id()
      and mc.rol = 'LIDER'
  );
$$;

-- Columna estado en comunidades
alter table public.comunidades
  add column if not exists estado text not null default 'PENDIENTE';

alter table public.comunidades
  drop constraint if exists comunidades_estado_check;
alter table public.comunidades
  add constraint comunidades_estado_check
  check (estado in ('PENDIENTE', 'ACTIVA', 'BLOQUEADA'));

alter table public.comunidades
  drop constraint if exists comunidades_privacidad_check;
alter table public.comunidades
  add constraint comunidades_privacidad_check
  check (privacidad in ('PUBLICA', 'PRIVADA'));

create index if not exists idx_comunidades_estado
  on public.comunidades(estado);

create index if not exists idx_comunidades_privacidad
  on public.comunidades(privacidad);

-- Tabla puente comunidad_intereses
create table if not exists public.comunidad_intereses (
  id_comunidad bigint not null references public.comunidades(id_comunidad) on delete cascade,
  id_interes bigint not null references public.intereses(id_interes) on delete cascade,
  primary key (id_comunidad, id_interes)
);

create index if not exists idx_comunidad_intereses_interes
  on public.comunidad_intereses(id_interes);

alter table public.comunidad_intereses enable row level security;

-- RLS comunidades: filtrar privadas y pendientes
drop policy if exists comunidades_select_authenticated on public.comunidades;
drop policy if exists comunidades_select_visible on public.comunidades;
create policy comunidades_select_visible
on public.comunidades
for select
to authenticated
using (
  public.es_admin()
  or usuario_id_usuario = public.usuario_actual_id()
  or (
    estado = 'ACTIVA'
    and (
      privacidad = 'PUBLICA'
      or public.es_miembro_comunidad(id_comunidad)
    )
  )
);

drop policy if exists comunidades_insert_own on public.comunidades;
create policy comunidades_insert_own
on public.comunidades
for insert
to authenticated
with check (
  usuario_id_usuario = public.usuario_actual_id()
  and estado = 'PENDIENTE'
);

drop policy if exists comunidades_update_owner on public.comunidades;
create policy comunidades_update_owner
on public.comunidades
for update
to authenticated
using (
  usuario_id_usuario = public.usuario_actual_id()
  and estado = 'PENDIENTE'
);

drop policy if exists comunidades_update_admin on public.comunidades;
create policy comunidades_update_admin
on public.comunidades
for update
to authenticated
using (public.es_admin());

-- RLS comunidad_intereses
drop policy if exists comunidad_intereses_select_visible on public.comunidad_intereses;
create policy comunidad_intereses_select_visible
on public.comunidad_intereses
for select
to authenticated
using (
  exists (
    select 1
    from public.comunidades c
    where c.id_comunidad = comunidad_intereses.id_comunidad
      and (
        public.es_admin()
        or c.usuario_id_usuario = public.usuario_actual_id()
        or (
          c.estado = 'ACTIVA'
          and (
            c.privacidad = 'PUBLICA'
            or public.es_miembro_comunidad(c.id_comunidad)
          )
        )
      )
  )
);

-- RLS miembro_comunidad: permitir update de rol por lider/admin
drop policy if exists miembro_comunidad_update_rol on public.miembro_comunidad;
create policy miembro_comunidad_update_rol
on public.miembro_comunidad
for update
to authenticated
using (
  public.es_admin()
  or public.es_lider_comunidad(id_comunidad)
);

-- RPC: solicitar crear comunidad (queda PENDIENTE)
create or replace function public.solicitar_comunidad(
  p_nombre text,
  p_descripcion text,
  p_privacidad text default 'PUBLICA',
  p_interes_ids bigint[] default '{}'
)
returns bigint
language plpgsql
security definer
set search_path = public
as $$
declare
  v_uid bigint;
  v_id bigint;
  v_interes bigint;
begin
  v_uid := public.usuario_actual_id();
  if v_uid is null then
    raise exception 'Usuario no encontrado';
  end if;
  if p_nombre is null or length(trim(p_nombre)) < 3 then
    raise exception 'El nombre debe tener al menos 3 caracteres';
  end if;
  if p_privacidad not in ('PUBLICA', 'PRIVADA') then
    raise exception 'Privacidad invalida';
  end if;

  insert into public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  )
  values (
    trim(p_nombre), nullif(trim(coalesce(p_descripcion, '')), ''),
    p_privacidad, 'PENDIENTE', v_uid
  )
  returning id_comunidad into v_id;

  foreach v_interes in array coalesce(p_interes_ids, '{}')
  loop
    insert into public.comunidad_intereses (id_comunidad, id_interes)
    values (v_id, v_interes)
    on conflict do nothing;
  end loop;

  return v_id;
end;
$$;

-- RPC: admin aprueba PENDIENTE -> ACTIVA
create or replace function public.aprobar_comunidad(p_id_comunidad bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_owner bigint;
begin
  if not public.es_admin() then
    raise exception 'No autorizado';
  end if;

  update public.comunidades
  set estado = 'ACTIVA'
  where id_comunidad = p_id_comunidad
    and estado = 'PENDIENTE'
  returning usuario_id_usuario into v_owner;

  if v_owner is null then
    raise exception 'Comunidad no encontrada o ya procesada';
  end if;

  insert into public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  values (p_id_comunidad, v_owner, 'LIDER')
  on conflict (id_comunidad, usuario_id_usuario) do update set rol = 'LIDER';
end;
$$;

-- RPC: asignar rol de miembro (MODERADOR, MIEMBRO, LIDER)
create or replace function public.asignar_rol_miembro_comunidad(
  p_id_comunidad bigint,
  p_usuario_id bigint,
  p_rol text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_rol not in ('MIEMBRO', 'MODERADOR', 'LIDER') then
    raise exception 'Rol invalido';
  end if;
  if not (public.es_admin() or public.es_lider_comunidad(p_id_comunidad)) then
    raise exception 'No autorizado';
  end if;

  update public.miembro_comunidad
  set rol = p_rol
  where id_comunidad = p_id_comunidad
    and usuario_id_usuario = p_usuario_id;

  if not found then
    raise exception 'Miembro no encontrado en la comunidad';
  end if;
end;
$$;

grant execute on function public.solicitar_comunidad(text, text, text, bigint[]) to authenticated;
grant execute on function public.aprobar_comunidad(bigint) to authenticated;
grant execute on function public.asignar_rol_miembro_comunidad(bigint, bigint, text) to authenticated;


-- ---------------------------------------------------------------------------
-- Reportes de eventos
-- ---------------------------------------------------------------------------
-- LOOP / Supabase â€” reporte de eventos
-- Requiere: evento.sql, usuario.sql, roles_sistema.sql

create table if not exists public.reporte_evento (
  id_reporte bigint generated always as identity primary key,
  motivo text not null,
  descripcion text,
  estado text not null default 'PENDIENTE',
  fecha_reporte timestamptz not null default now(),
  fecha_resolucion timestamptz,
  usuario_id_usuario bigint not null references public.usuario(id_usuario) on delete cascade,
  evento_id_evento bigint not null references public.evento(id_evento) on delete cascade,
  moderador_id_usuario bigint references public.usuario(id_usuario) on delete set null
);

create index if not exists idx_reporte_evento_evento
  on public.reporte_evento(evento_id_evento);

create index if not exists idx_reporte_evento_estado
  on public.reporte_evento(estado);

alter table public.reporte_evento enable row level security;

drop policy if exists reporte_evento_select_own_or_admin on public.reporte_evento;
create policy reporte_evento_select_own_or_admin
on public.reporte_evento
for select
to authenticated
using (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
  or public.es_admin_o_moderador()
);

drop policy if exists reporte_evento_insert_own on public.reporte_evento;
create policy reporte_evento_insert_own
on public.reporte_evento
for insert
to authenticated
with check (
  usuario_id_usuario in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists reporte_evento_update_admin on public.reporte_evento;
create policy reporte_evento_update_admin
on public.reporte_evento
for update
to authenticated
using (public.es_admin_o_moderador());


-- ---------------------------------------------------------------------------
-- Lectura anonima region/comuna (formulario de registro)
-- ---------------------------------------------------------------------------
-- Permite leer region y comuna durante el registro (usuario aun no autenticado).
-- Ejecutar en Supabase SQL Editor si el formulario de registro no carga ubicaciones.

drop policy if exists region_select_anon on public.region;
create policy region_select_anon
on public.region
for select
to anon
using (true);

drop policy if exists comuna_select_anon on public.comuna;
create policy comuna_select_anon
on public.comuna
for select
to anon
using (true);

-- ---------------------------------------------------------------------------
-- Preferencias de perfil y contacto extendido
-- ---------------------------------------------------------------------------
alter table public.usuario add column if not exists telefono text;
alter table public.usuario add column if not exists nacionalidad text default 'Chileno';
alter table public.usuario add column if not exists edad_min_eventos int not null default 18;
alter table public.usuario add column if not exists edad_max_eventos int not null default 35;
alter table public.usuario add column if not exists notificar_eventos_recomendados boolean not null default true;
alter table public.usuario add column if not exists mostrar_stats_perfil boolean not null default true;

-- ---------------------------------------------------------------------------
-- Notificaciones (inbox persistente)
-- ---------------------------------------------------------------------------
create table if not exists public.notificacion (
  id_notificacion bigint generated always as identity primary key,
  usuario_destino_id bigint not null references public.usuario(id_usuario) on delete cascade,
  usuario_origen_id bigint references public.usuario(id_usuario) on delete set null,
  tipo text not null,
  titulo text not null,
  cuerpo text not null,
  leida boolean not null default false,
  id_post bigint references public.publicaciones(id_post) on delete set null,
  id_evento bigint references public.evento(id_evento) on delete set null,
  id_comunidad bigint references public.comunidades(id_comunidad) on delete set null,
  id_participacion bigint references public.participantes_evento(id_participacion) on delete set null,
  fecha_creacion timestamptz not null default now()
);

create index if not exists idx_notificacion_destino
  on public.notificacion(usuario_destino_id, fecha_creacion desc);

create index if not exists idx_notificacion_destino_leida
  on public.notificacion(usuario_destino_id, leida);

alter table public.notificacion enable row level security;

drop policy if exists notificacion_select_own on public.notificacion;
create policy notificacion_select_own
on public.notificacion
for select
to authenticated
using (
  usuario_destino_id in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

drop policy if exists notificacion_update_own on public.notificacion;
create policy notificacion_update_own
on public.notificacion
for update
to authenticated
using (
  usuario_destino_id in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
)
with check (
  usuario_destino_id in (
    select id_usuario from public.usuario where auth_user_id = auth.uid()
  )
);

-- Helper: insertar notificacion (triggers + RPC). Evita auto-notificacion.
create or replace function public.crear_notificacion(
  p_destino_id bigint,
  p_origen_id bigint,
  p_tipo text,
  p_titulo text,
  p_cuerpo text,
  p_id_post bigint default null,
  p_id_evento bigint default null,
  p_id_comunidad bigint default null,
  p_id_participacion bigint default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_destino_id is null then
    return;
  end if;
  if p_origen_id is not null and p_destino_id = p_origen_id then
    return;
  end if;
  insert into public.notificacion (
    usuario_destino_id,
    usuario_origen_id,
    tipo,
    titulo,
    cuerpo,
    id_post,
    id_evento,
    id_comunidad,
    id_participacion
  ) values (
    p_destino_id,
    p_origen_id,
    p_tipo,
    p_titulo,
    left(p_cuerpo, 500),
    p_id_post,
    p_id_evento,
    p_id_comunidad,
    p_id_participacion
  );
end;
$$;

-- Trigger: comentario en publicacion -> notifica al autor del post
create or replace function public.trg_notificacion_comentario()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_post_owner bigint;
begin
  select p.usuario_id_usuario
  into v_post_owner
  from public.publicaciones p
  where p.id_post = new.publicaciones_id_post;

  perform public.crear_notificacion(
    v_post_owner,
    new.usuario_id_usuario,
    'COMENTARIO',
    'Nuevo comentario en tu publicacion',
    new.texto_comentario,
    p_id_post => new.publicaciones_id_post
  );
  return new;
end;
$$;

drop trigger if exists notificacion_on_comentario on public.comentario;
create trigger notificacion_on_comentario
after insert on public.comentario
for each row execute function public.trg_notificacion_comentario();

-- Trigger: like en publicacion -> notifica al autor del post
create or replace function public.trg_notificacion_like()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_post_owner bigint;
begin
  select p.usuario_id_usuario
  into v_post_owner
  from public.publicaciones p
  where p.id_post = new.publicaciones_id_post;

  perform public.crear_notificacion(
    v_post_owner,
    new.usuario_id_usuario,
    'LIKE',
    'Nueva reaccion en tu publicacion',
    'Alguien reacciono a tu contenido',
    p_id_post => new.publicaciones_id_post
  );
  return new;
end;
$$;

drop trigger if exists notificacion_on_like on public.reacciones_post;
create trigger notificacion_on_like
after insert on public.reacciones_post
for each row execute function public.trg_notificacion_like();

-- Trigger: solicitud/inscripcion a evento
create or replace function public.trg_notificacion_participante_insert()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_organizador bigint;
  v_titulo_evento text;
begin
  select e.usuario_id_usuario, coalesce(e.titulo, e.nombre, 'Evento')
  into v_organizador, v_titulo_evento
  from public.evento e
  where e.id_evento = new.evento_id_evento;

  if new.estado_solicitud = 'PENDIENTE' then
    perform public.crear_notificacion(
      v_organizador,
      new.usuario_id_usuario,
      'SOLICITUD_EVENTO',
      'Nueva solicitud de participacion',
      v_titulo_evento,
      p_id_evento => new.evento_id_evento,
      p_id_participacion => new.id_participacion
    );
  end if;
  return new;
end;
$$;

drop trigger if exists notificacion_on_participante_insert on public.participantes_evento;
create trigger notificacion_on_participante_insert
after insert on public.participantes_evento
for each row execute function public.trg_notificacion_participante_insert();

create or replace function public.trg_notificacion_participante_update()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_titulo_evento text;
begin
  if old.estado_solicitud is not distinct from new.estado_solicitud then
    return new;
  end if;

  select coalesce(e.titulo, e.nombre, 'Evento')
  into v_titulo_evento
  from public.evento e
  where e.id_evento = new.evento_id_evento;

  if new.estado_solicitud = 'APROBADO' then
    perform public.crear_notificacion(
      new.usuario_id_usuario,
      null,
      'INSCRIPCION_APROBADA',
      'Solicitud aprobada',
      'Ya puedes participar en: ' || v_titulo_evento,
      p_id_evento => new.evento_id_evento,
      p_id_participacion => new.id_participacion
    );
  elsif new.estado_solicitud = 'RECHAZADO' then
    perform public.crear_notificacion(
      new.usuario_id_usuario,
      null,
      'INSCRIPCION_RECHAZADA',
      'Solicitud rechazada',
      'No fue posible inscribirte en: ' || v_titulo_evento,
      p_id_evento => new.evento_id_evento,
      p_id_participacion => new.id_participacion
    );
  end if;
  return new;
end;
$$;

drop trigger if exists notificacion_on_participante_update on public.participantes_evento;
create trigger notificacion_on_participante_update
after update of estado_solicitud on public.participantes_evento
for each row execute function public.trg_notificacion_participante_update();

-- RPC: marcar una o todas como leidas
create or replace function public.marcar_notificacion_leida(p_id_notificacion bigint)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user bigint;
begin
  select id_usuario into v_user
  from public.usuario
  where auth_user_id = auth.uid();

  update public.notificacion
  set leida = true
  where id_notificacion = p_id_notificacion
    and usuario_destino_id = v_user;
end;
$$;

create or replace function public.marcar_todas_notificaciones_leidas()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user bigint;
begin
  select id_usuario into v_user
  from public.usuario
  where auth_user_id = auth.uid();

  update public.notificacion
  set leida = true
  where usuario_destino_id = v_user
    and leida = false;
end;
$$;

grant execute on function public.marcar_notificacion_leida(bigint) to authenticated;
grant execute on function public.marcar_todas_notificaciones_leidas() to authenticated;

-- Eliminacion de cuenta (soft delete del perfil en public.usuario)
create or replace function public.eliminar_mi_cuenta()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_usuario_id bigint;
begin
  select id_usuario into v_usuario_id
  from public.usuario
  where auth_user_id = auth.uid();

  if v_usuario_id is null then
    raise exception 'Usuario no encontrado';
  end if;

  update public.usuario
  set
    estado_cuenta = 'ELIMINADO',
    nombres = 'Usuario',
    apellidos = 'Eliminado',
    username = 'deleted_' || v_usuario_id::text,
    email = 'deleted_' || v_usuario_id::text || '@loop.local',
    telefono = null,
    avatar_url = null,
    nacionalidad = null,
    genero = null
  where id_usuario = v_usuario_id;
end;
$$;

grant execute on function public.eliminar_mi_cuenta() to authenticated;

