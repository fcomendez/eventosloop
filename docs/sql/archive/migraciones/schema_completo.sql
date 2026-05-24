-- LOOP / Supabase â€” MER: region
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

-- Semilla inicial basada en listado inicial de intereses
-- Nota: "icono" usa nombres tecnicos de Material Icons (en ingles).
-- Eso no afecta el idioma visual de la app, solo el identificador interno.
insert into public.intereses (categoria, nombre, slug, icono, color_hex)
values
  ('DEPORTE', 'Running', 'running', 'directions_run', '#0682BC'),
  ('DEPORTE', 'Atletismo', 'atletismo', 'timer', '#0682BC'),
  ('DEPORTE', 'Futbol', 'futbol', 'sports_soccer', '#0682BC'),
  ('DEPORTE', 'Basquetbol', 'basquetbol', 'sports_basketball', '#0682BC'),
  ('DEPORTE', 'Voleibol', 'voleibol', 'sports_volleyball', '#0682BC'),
  ('DEPORTE', 'Senderismo', 'senderismo', 'hiking', '#0682BC'),
  ('DEPORTE', 'Trekking', 'trekking', 'terrain', '#0682BC'),
  ('DEPORTE', 'Ciclismo', 'ciclismo', 'directions_bike', '#0682BC'),
  ('DEPORTE', 'Patinaje', 'patinaje', 'roller_skating', '#0682BC'),
  ('BIENESTAR', 'Yoga', 'yoga', 'self_improvement', '#0682BC'),
  ('BIENESTAR', 'Meditacion', 'meditacion', 'spa', '#0682BC'),
  ('DEPORTE', 'Boxeo', 'boxeo', 'sports_mma', '#0682BC'),
  ('DEPORTE', 'Karate', 'karate', 'sports_kabaddi', '#0682BC'),
  ('GASTRONOMIA', 'Gastronomia', 'gastronomia', 'restaurant', '#0682BC'),
  ('GASTRONOMIA', 'Cafeteria', 'cafeteria', 'coffee', '#0682BC'),
  ('GASTRONOMIA', 'Enologia', 'enologia', 'wine_bar', '#0682BC'),
  ('GASTRONOMIA', 'Cocteleria', 'cocteleria', 'local_bar', '#0682BC'),
  ('GASTRONOMIA', 'Cocina', 'cocina', 'soup_kitchen', '#0682BC'),
  ('GASTRONOMIA', 'Reposteria', 'reposteria', 'cake', '#0682BC'),
  ('GASTRONOMIA', 'Picnic', 'picnic', 'lunch_dining', '#0682BC'),
  ('CULTURA', 'Cine', 'cine', 'movie', '#0682BC'),
  ('CULTURA', 'Teatro', 'teatro', 'theaters', '#0682BC'),
  ('CULTURA', 'Conciertos', 'conciertos', 'music_note', '#0682BC'),
  ('CULTURA', 'Festivales', 'festivales', 'celebration', '#0682BC'),
  ('CULTURA', 'Museos', 'museos', 'museum', '#0682BC'),
  ('ARTE', 'Fotografia', 'fotografia', 'photo_camera', '#0682BC'),
  ('CULTURA', 'Lectura', 'lectura', 'menu_book', '#0682BC'),
  ('JUEGOS', 'Ajedrez', 'ajedrez', 'extension', '#0682BC'),
  ('JUEGOS', 'Billar', 'billar', 'sports', '#0682BC'),
  ('JUEGOS', 'Videojuegos', 'videojuegos', 'sports_esports', '#0682BC'),
  ('JUEGOS', 'Gaming', 'gaming', 'stadia_controller', '#0682BC'),
  ('BAILE', 'Salsa', 'salsa', 'music_note', '#0682BC'),
  ('BAILE', 'Bachata', 'bachata', 'music_note', '#0682BC'),
  ('JUEGOS', 'Trivia', 'trivia', 'quiz', '#0682BC'),
  ('ENTRETENCION', 'Karaoke', 'karaoke', 'mic', '#0682BC'),
  ('EDUCACION', 'Idiomas', 'idiomas', 'translate', '#0682BC'),
  ('ARTE', 'Ceramica', 'ceramica', 'palette', '#0682BC'),
  ('ARTE', 'Pintura', 'pintura', 'format_paint', '#0682BC'),
  ('ARTE', 'Costura', 'costura', 'content_cut', '#0682BC'),
  ('PROFESIONAL', 'Networking', 'networking', 'groups', '#0682BC'),
  ('PROFESIONAL', 'Emprendimiento', 'emprendimiento', 'lightbulb', '#0682BC'),
  ('PROFESIONAL', 'Debate', 'debate', 'record_voice_over', '#0682BC'),
  ('SOCIAL', 'Voluntariado', 'voluntariado', 'volunteer_activism', '#0682BC'),
  ('ESTILO_DE_VIDA', 'Mascotas', 'mascotas', 'pets', '#0682BC'),
  ('ESTILO_DE_VIDA', 'Viajes', 'viajes', 'flight', '#0682BC'),
  ('ESTILO_DE_VIDA', 'Campismo', 'campismo', 'camping', '#0682BC'),
  ('ESTILO_DE_VIDA', 'Jardineria', 'jardineria', 'yard', '#0682BC'),
  ('ESTILO_DE_VIDA', 'Bricolaje', 'bricolaje', 'handyman', '#0682BC'),
  ('CIENCIA', 'Astronomia', 'astronomia', 'nightlight', '#0682BC'),
  ('ARTE', 'Bisuteria', 'bisuteria', 'diamond', '#0682BC')
on conflict (slug) do update
set
  categoria = excluded.categoria,
  nombre = excluded.nombre,
  icono = excluded.icono,
  color_hex = excluded.color_hex,
  activo = true;
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
