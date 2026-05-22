-- LOOP / Supabase — MER: reacciones_post
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
