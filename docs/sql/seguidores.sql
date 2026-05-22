-- LOOP / Supabase — MER: seguidores
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
