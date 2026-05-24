-- LOOP / Supabase — MER: miembro_comunidad
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
