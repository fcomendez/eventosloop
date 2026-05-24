-- Usuarios demo LOOP (Auth + public.usuario + rol admin)
-- Ejecutar DESPUES de apply-schema.ps1
-- Passwords: ver tabla al final del archivo

CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  v_admin_id    uuid := '11111111-1111-1111-1111-111111111111';
  v_user_id     uuid := '22222222-2222-2222-2222-222222222222';
  v_vale_id     uuid := '33333333-3333-3333-3333-333333333333';
  v_diego_id    uuid := '44444444-4444-4444-4444-444444444444';
  v_camila_id   uuid := '55555555-5555-5555-5555-555555555555';
  v_matias_id   uuid := '66666666-6666-6666-6666-666666666666';
  v_sofia_id    uuid := '77777777-7777-7777-7777-777777777777';
  v_comuna      bigint;
  v_admin_usuario_id bigint;
  v_demo_emails text[] := ARRAY[
    'admin@loop.cl',
    'user@loop.cl',
    'valentina.morales@loop.cl',
    'diego.henriquez@loop.cl',
    'camila.rosas@loop.cl',
    'matias.vega@loop.cl',
    'sofia.torres@loop.cl'
  ];
  v_demo_uuids uuid[] := ARRAY[
    v_admin_id, v_user_id, v_vale_id, v_diego_id,
    v_camila_id, v_matias_id, v_sofia_id
  ];
BEGIN
  SELECT id_comuna INTO v_comuna FROM public.comuna ORDER BY id_comuna LIMIT 1;

  IF v_comuna IS NULL THEN
    RAISE EXCEPTION 'No hay comunas. Ejecuta apply-schema.ps1 primero.';
  END IF;

  -- Limpiar seed anterior (re-ejecutable)
  DELETE FROM public.publicaciones
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario WHERE email = ANY(v_demo_emails)
  );
  DELETE FROM public.evento
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario WHERE email = ANY(v_demo_emails)
  );
  DELETE FROM public.miembro_comunidad
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario WHERE email = ANY(v_demo_emails)
  );
  DELETE FROM public.roles_sistema
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario WHERE email = ANY(v_demo_emails)
  );
  DELETE FROM public.usuario WHERE email = ANY(v_demo_emails);
  DELETE FROM auth.identities WHERE user_id = ANY(v_demo_uuids);
  DELETE FROM auth.users WHERE id = ANY(v_demo_uuids);

  -- Helper: insertar usuario auth + perfil
  CREATE TEMP TABLE IF NOT EXISTS _seed_auth (
    auth_id uuid,
    email text,
    password text,
    meta_nombre text
  ) ON COMMIT DROP;
  TRUNCATE _seed_auth;

  INSERT INTO _seed_auth (auth_id, email, password, meta_nombre) VALUES
    (v_admin_id,  'admin@loop.cl',              'LoopAdmin1', 'Admin LOOP'),
    (v_user_id,   'user@loop.cl',               'LoopUser1',  'Usuario Prueba'),
    (v_vale_id,   'valentina.morales@loop.cl',  'LoopDemo1',  'Valentina Morales'),
    (v_diego_id,  'diego.henriquez@loop.cl',    'LoopDemo1',  'Diego Henriquez'),
    (v_camila_id, 'camila.rosas@loop.cl',       'LoopDemo1',  'Camila Rosas'),
    (v_matias_id, 'matias.vega@loop.cl',        'LoopDemo1',  'Matias Vega'),
    (v_sofia_id,  'sofia.torres@loop.cl',       'LoopDemo1',  'Sofia Torres');

  INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at, confirmation_token,
    recovery_token, email_change_token_new, email_change,
    created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
    is_super_admin, phone, phone_confirmed_at
  )
  SELECT
    auth_id,
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    email,
    crypt(password, gen_salt('bf')),
    now(), now(), '', '', '', '',
    now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('nombre', meta_nombre),
    false, null, null
  FROM _seed_auth;

  INSERT INTO auth.identities (
    id, user_id, provider_id, identity_data, provider,
    last_sign_in_at, created_at, updated_at
  )
  SELECT
    auth_id, auth_id, auth_id::text,
    jsonb_build_object('sub', auth_id::text, 'email', email),
    'email', now(), now(), now()
  FROM _seed_auth;

  INSERT INTO public.usuario (
    auth_user_id, email, username, nombres, apellidos,
    fecha_nacimiento, genero, comuna_id_comuna, rol_user, estado_cuenta
  ) VALUES
    (v_admin_id,  'admin@loop.cl',             'admin_loop',   'Admin',     'LOOP',      '1990-01-15', 'Otro',      v_comuna, 'ADMIN', 'ACTIVO'),
    (v_user_id,   'user@loop.cl',              'user_loop',    'Usuario',   'Prueba',    '1995-06-20', 'Otro',      v_comuna, 'USER',  'ACTIVO'),
    (v_vale_id,   'valentina.morales@loop.cl', 'vale_morales', 'Valentina', 'Morales',   '1998-03-12', 'Femenino',  v_comuna, 'USER',  'ACTIVO'),
    (v_diego_id,  'diego.henriquez@loop.cl',   'diego_h',      'Diego',     'Henriquez', '1992-11-08', 'Masculino', v_comuna, 'USER',  'ACTIVO'),
    (v_camila_id, 'camila.rosas@loop.cl',      'cami_rosas',   'Camila',    'Rosas',     '1999-07-25', 'Femenino',  v_comuna, 'USER',  'ACTIVO'),
    (v_matias_id, 'matias.vega@loop.cl',       'mati_vega',    'Matias',    'Vega',      '1994-02-18', 'Masculino', v_comuna, 'USER',  'ACTIVO'),
    (v_sofia_id,  'sofia.torres@loop.cl',      'sofi_torres',  'Sofia',     'Torres',    '1996-09-30', 'Femenino',  v_comuna, 'USER',  'ACTIVO');

  SELECT id_usuario INTO v_admin_usuario_id
  FROM public.usuario WHERE email = 'admin@loop.cl';

  INSERT INTO public.roles_sistema (nombre_rol, usuario_id_usuario)
  VALUES ('ADMIN', v_admin_usuario_id)
  ON CONFLICT (usuario_id_usuario, nombre_rol) DO NOTHING;

END $$;

-- Credenciales demo (solo desarrollo local)
-- Admin:     admin@loop.cl              / LoopAdmin1
-- User:      user@loop.cl               / LoopUser1
-- Valentina: valentina.morales@loop.cl  / LoopDemo1
-- Diego:     diego.henriquez@loop.cl    / LoopDemo1
-- Camila:    camila.rosas@loop.cl       / LoopDemo1
-- Matias:    matias.vega@loop.cl        / LoopDemo1
-- Sofia:     sofia.torres@loop.cl       / LoopDemo1
