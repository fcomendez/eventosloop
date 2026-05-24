-- LOOP / Supabase — MER: comentario
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
