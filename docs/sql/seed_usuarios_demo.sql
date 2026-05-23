-- Usuarios demo LOOP (Auth + public.usuario + rol admin)
-- Ejecutar DESPUES de apply-schema.ps1
-- Passwords: ver tabla al final del archivo

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- UUIDs fijos para que el seed sea reproducible en cualquier clone
DO $$
DECLARE
  v_admin_id uuid := '11111111-1111-1111-1111-111111111111';
  v_user_id  uuid := '22222222-2222-2222-2222-222222222222';
  v_comuna   bigint;
  v_admin_usuario_id bigint;
  v_user_usuario_id bigint;
BEGIN
  SELECT id_comuna INTO v_comuna FROM public.comuna ORDER BY id_comuna LIMIT 1;

  IF v_comuna IS NULL THEN
    RAISE EXCEPTION 'No hay comunas. Ejecuta apply-schema.ps1 primero.';
  END IF;

  -- Limpiar seed anterior (re-ejecutable)
  DELETE FROM public.roles_sistema WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario WHERE email IN ('admin@loop.cl', 'user@loop.cl')
  );
  DELETE FROM public.usuario WHERE email IN ('admin@loop.cl', 'user@loop.cl');
  DELETE FROM auth.identities WHERE user_id IN (v_admin_id, v_user_id);
  DELETE FROM auth.users WHERE id IN (v_admin_id, v_user_id);

  -- Auth: admin
  INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at, confirmation_token,
    recovery_token, email_change_token_new, email_change,
    created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
    is_super_admin, phone, phone_confirmed_at
  ) VALUES (
    v_admin_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'admin@loop.cl',
    crypt('LoopAdmin1', gen_salt('bf')),
    now(), now(), '', '', '', '',
    now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"nombre":"Admin LOOP"}'::jsonb,
    false, null, null
  );

  INSERT INTO auth.identities (
    id, user_id, provider_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) VALUES (
    v_admin_id, v_admin_id, v_admin_id::text,
    jsonb_build_object('sub', v_admin_id::text, 'email', 'admin@loop.cl'),
    'email', now(), now(), now()
  );

  -- Auth: usuario normal
  INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at, confirmation_token,
    recovery_token, email_change_token_new, email_change,
    created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
    is_super_admin, phone, phone_confirmed_at
  ) VALUES (
    v_user_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'user@loop.cl',
    crypt('LoopUser1', gen_salt('bf')),
    now(), now(), '', '', '', '',
    now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    '{"nombre":"Usuario LOOP"}'::jsonb,
    false, null, null
  );

  INSERT INTO auth.identities (
    id, user_id, provider_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  ) VALUES (
    v_user_id, v_user_id, v_user_id::text,
    jsonb_build_object('sub', v_user_id::text, 'email', 'user@loop.cl'),
    'email', now(), now(), now()
  );

  -- Perfil negocio: admin
  INSERT INTO public.usuario (
    auth_user_id, email, username, nombres, apellidos,
    fecha_nacimiento, genero, comuna_id_comuna, rol_user, estado_cuenta
  ) VALUES (
    v_admin_id, 'admin@loop.cl', 'admin_loop', 'Admin', 'LOOP',
    '1990-01-15', 'Otro', v_comuna, 'ADMIN', 'ACTIVO'
  )
  RETURNING id_usuario INTO v_admin_usuario_id;

  -- Perfil negocio: usuario
  INSERT INTO public.usuario (
    auth_user_id, email, username, nombres, apellidos,
    fecha_nacimiento, genero, comuna_id_comuna, rol_user, estado_cuenta
  ) VALUES (
    v_user_id, 'user@loop.cl', 'user_loop', 'Usuario', 'Prueba',
    '1995-06-20', 'Otro', v_comuna, 'USER', 'ACTIVO'
  )
  RETURNING id_usuario INTO v_user_usuario_id;

  INSERT INTO public.roles_sistema (nombre_rol, usuario_id_usuario)
  VALUES ('ADMIN', v_admin_usuario_id)
  ON CONFLICT (usuario_id_usuario, nombre_rol) DO NOTHING;

END $$;

-- Credenciales demo (solo desarrollo local)
-- Admin:  admin@loop.cl  / LoopAdmin1
-- User:   user@loop.cl   / LoopUser1
