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
