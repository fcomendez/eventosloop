-- LOOP — Supabase Storage: buckets, políticas y columnas de media
-- Ejecutar después de loop_schema.sql y con el servicio storage-api activo.
-- Uso: scripts\apply-storage.ps1

-- Columna portada en eventos (comunidades ya tienen banner_url)
alter table public.evento add column if not exists cover_url text;

-- Buckets públicos de lectura
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('avatars', 'avatars', true, 5242880, array['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  ('events', 'events', true, 10485760, array['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  ('posts', 'posts', true, 10485760, array['image/jpeg', 'image/png', 'image/webp', 'image/gif']),
  ('communities', 'communities', true, 10485760, array['image/jpeg', 'image/png', 'image/webp', 'image/gif'])
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Políticas storage.objects (idempotentes)
do $$
declare
  b text;
begin
  foreach b in array array['avatars', 'events', 'posts', 'communities']
  loop
    execute format('drop policy if exists "loop_%s_public_read" on storage.objects', b);
    execute format(
      'create policy "loop_%s_public_read" on storage.objects for select to public using (bucket_id = %L)',
      b, b
    );

    execute format('drop policy if exists "loop_%s_auth_insert" on storage.objects', b);
    execute format(
      'create policy "loop_%s_auth_insert" on storage.objects for insert to authenticated with check (bucket_id = %L)',
      b, b
    );

    execute format('drop policy if exists "loop_%s_auth_update" on storage.objects', b);
    execute format(
      'create policy "loop_%s_auth_update" on storage.objects for update to authenticated using (bucket_id = %L)',
      b, b
    );

    execute format('drop policy if exists "loop_%s_auth_delete" on storage.objects', b);
    execute format(
      'create policy "loop_%s_auth_delete" on storage.objects for delete to authenticated using (bucket_id = %L)',
      b, b
    );
  end loop;
end $$;

-- RPC solicitar_comunidad con banner opcional
create or replace function public.solicitar_comunidad(
  p_nombre text,
  p_descripcion text,
  p_privacidad text default 'PUBLICA',
  p_interes_ids bigint[] default '{}',
  p_banner_url text default null
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
    nombre, descripcion, privacidad, estado, usuario_id_usuario, banner_url
  )
  values (
    trim(p_nombre),
    nullif(trim(coalesce(p_descripcion, '')), ''),
    p_privacidad,
    'PENDIENTE',
    v_uid,
    nullif(trim(coalesce(p_banner_url, '')), '')
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

grant execute on function public.solicitar_comunidad(text, text, text, bigint[], text) to authenticated;
