-- LOOP / Supabase — MER: comunidad_intereses
-- Requiere: comunidades.sql, intereses_usuario_intereses.sql

create table if not exists public.comunidad_intereses (
  id_comunidad bigint not null references public.comunidades(id_comunidad) on delete cascade,
  id_interes bigint not null references public.intereses(id_interes) on delete cascade,
  primary key (id_comunidad, id_interes)
);

create index if not exists idx_comunidad_intereses_interes
  on public.comunidad_intereses(id_interes);

alter table public.comunidad_intereses enable row level security;

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
