-- LOOP â€” Datos demo (usuarios Auth, comunidades, eventos, publicaciones)
-- Ejecutar DESPUES de loop_seed_catalogo.sql via scripts/seed-demo.ps1
-- Re-ejecutable.

-- === Usuarios ===
-- Usuarios demo LOOP (Auth + public.usuario + rol admin)
-- Ejecutar DESPUES de seed-catalogo.ps1
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
    RAISE EXCEPTION 'No hay comunas. Ejecuta scripts/seed-catalogo.ps1 primero.';
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


-- === Comunidades ===
-- Seed demo: comunidades ACTIVAS con intereses (tags en UI) + 1 privada oculta en exploracion
-- Ejecutar DESPUES de loop_seed_demo.sql (bloque usuarios)

DO $$
DECLARE
  v_admin_id bigint;
  v_user_id bigint;
  v_c1 bigint;
  v_c2 bigint;
  v_c3 bigint;
  v_c_priv bigint;
  v_interes_tech bigint;
  v_interes_yoga bigint;
  v_interes_foto bigint;
  v_interes_net bigint;
BEGIN
  SELECT id_usuario INTO v_admin_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1;
  SELECT id_usuario INTO v_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1;

  IF v_admin_id IS NULL OR v_user_id IS NULL THEN
    RAISE EXCEPTION 'Ejecuta loop_seed_demo.sql (usuarios) primero.';
  END IF;

  SELECT id_interes INTO v_interes_tech FROM public.intereses WHERE slug = 'videojuegos' LIMIT 1;
  SELECT id_interes INTO v_interes_yoga FROM public.intereses WHERE slug = 'yoga' LIMIT 1;
  SELECT id_interes INTO v_interes_foto FROM public.intereses WHERE slug = 'fotografia' LIMIT 1;
  SELECT id_interes INTO v_interes_net FROM public.intereses WHERE slug = 'networking' LIMIT 1;

  -- Limpiar seed anterior (re-ejecutable)
  DELETE FROM public.comunidad_intereses
  WHERE id_comunidad IN (
    SELECT id_comunidad FROM public.comunidades
    WHERE nombre IN (
      'Tech Founders Circle',
      'Mindful Mornings',
      'Creative Collective',
      'Club Privado LOOP'
    )
  );
  DELETE FROM public.miembro_comunidad
  WHERE id_comunidad IN (
    SELECT id_comunidad FROM public.comunidades
    WHERE nombre IN (
      'Tech Founders Circle',
      'Mindful Mornings',
      'Creative Collective',
      'Club Privado LOOP'
    )
  );
  DELETE FROM public.comunidades
  WHERE nombre IN (
    'Tech Founders Circle',
    'Mindful Mornings',
    'Creative Collective',
    'Club Privado LOOP'
  );

  -- Comunidad 1: Tech (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Tech Founders Circle',
    'Comunidad para emprendedores tech que comparten experiencias y networking.',
    'PUBLICA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c1;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c1, v_admin_id, 'LIDER');

  IF v_interes_tech IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c1, v_interes_tech);
  END IF;
  IF v_interes_net IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c1, v_interes_net);
  END IF;

  -- Comunidad 2: Bienestar (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Mindful Mornings',
    'Rutinas matinales de yoga, meditacion y bienestar.',
    'PUBLICA', 'ACTIVA', v_user_id
  ) RETURNING id_comunidad INTO v_c2;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c2, v_user_id, 'LIDER'), (v_c2, v_admin_id, 'MIEMBRO');

  IF v_interes_yoga IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c2, v_interes_yoga);
  END IF;

  -- Comunidad 3: Arte (publica, activa)
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Creative Collective',
    'Espacio para fotografos, pintores y creadores visuales.',
    'PUBLICA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c3;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c3, v_admin_id, 'LIDER');

  IF v_interes_foto IS NOT NULL THEN
    INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
    VALUES (v_c3, v_interes_foto);
  END IF;

  -- Comunidad privada: NO debe aparecer en exploracion para no-miembros
  INSERT INTO public.comunidades (
    nombre, descripcion, privacidad, estado, usuario_id_usuario
  ) VALUES (
    'Club Privado LOOP',
    'Comunidad privada solo visible para miembros invitados.',
    'PRIVADA', 'ACTIVA', v_admin_id
  ) RETURNING id_comunidad INTO v_c_priv;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  VALUES (v_c_priv, v_admin_id, 'LIDER');

END $$;


-- === Eventos y publicaciones ===
-- Seed demo: 4 eventos + 4 publicaciones por cada usuario demo
-- Ejecutar DESPUES de loop_seed_demo.sql (bloque comunidades)

DO $$
DECLARE
  v_comuna bigint;
  v_c_tech bigint;
  v_c_yoga bigint;
  v_c_arte bigint;
  v_c_priv bigint;

  usr record;
BEGIN
  SELECT id_comuna INTO v_comuna FROM public.comuna ORDER BY id_comuna LIMIT 1;

  SELECT id_comunidad INTO v_c_tech FROM public.comunidades
  WHERE nombre = 'Tech Founders Circle' LIMIT 1;
  SELECT id_comunidad INTO v_c_yoga FROM public.comunidades
  WHERE nombre = 'Mindful Mornings' LIMIT 1;
  SELECT id_comunidad INTO v_c_arte FROM public.comunidades
  WHERE nombre = 'Creative Collective' LIMIT 1;
  SELECT id_comunidad INTO v_c_priv FROM public.comunidades
  WHERE nombre = 'Club Privado LOOP' LIMIT 1;

  IF v_comuna IS NULL THEN
    RAISE EXCEPTION 'No hay comunas. Ejecuta scripts/seed-catalogo.ps1 primero.';
  END IF;

  -- Limpiar contenido demo previo
  DELETE FROM public.publicaciones
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario
    WHERE email LIKE '%@loop.cl'
  );
  DELETE FROM public.evento
  WHERE usuario_id_usuario IN (
    SELECT id_usuario FROM public.usuario
    WHERE email LIKE '%@loop.cl'
  );

  FOR usr IN
    SELECT id_usuario, email, nombres, apellidos
    FROM public.usuario
    WHERE email IN (
      'admin@loop.cl',
      'user@loop.cl',
      'valentina.morales@loop.cl',
      'diego.henriquez@loop.cl',
      'camila.rosas@loop.cl',
      'matias.vega@loop.cl',
      'sofia.torres@loop.cl'
    )
    ORDER BY id_usuario
  LOOP
    -- 4 eventos por usuario
    INSERT INTO public.evento (
      nombre, titulo, descripcion, ubicacion_direccion, direccion,
      cupos_max, fecha_realizacion, estado, es_privado,
      usuario_id_usuario, comuna_id_comuna, comunidad_id_comunidad
    ) VALUES
      (
        'Meetup ' || usr.nombres,
        'Encuentro de comunidad con ' || usr.nombres,
        'Sesion abierta para compartir experiencias y conocer gente nueva.',
        'Parque Bustamante, Providencia',
        'Av. Providencia 1500',
        40,
        now() + interval '5 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_tech
      ),
      (
        'Taller ' || usr.apellidos,
        'Workshop practico de ' || usr.nombres,
        'Actividad presencial con cupos limitados y dinamicas grupales.',
        'Centro Cultural Gabriela Mistral',
        'Av. Libertador Bernardo O Higgins 227',
        25,
        now() + interval '12 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_yoga
      ),
      (
        'Networking ' || usr.nombres,
        'After office de networking',
        'Espacio para conectar profesionales del ecosistema local.',
        'WeWork Apoquindo',
        'Av. Apoquindo 5950',
        30,
        now() + interval '20 days',
        'ACTIVO', false,
        usr.id_usuario, v_comuna, v_c_arte
      ),
      (
        'Evento privado ' || usr.apellidos,
        'Sesion exclusiva para miembros',
        'Encuentro cerrado con acceso solo para invitados confirmados.',
        'Club LOOP, Las Condes',
        'Av. Las Condes 12345',
        15,
        now() + interval '28 days',
        'ACTIVO', true,
        usr.id_usuario, v_comuna, v_c_priv
      );

    -- 4 publicaciones por usuario
    INSERT INTO public.publicaciones (
      titulo, contenido, fecha_publicacion,
      usuario_id_usuario, comunidades_id_comunidad
    ) VALUES
      (
        'Hola desde ' || usr.nombres,
        'Mi primera publicacion en LOOP. Feliz de sumarme a la comunidad '
        || coalesce(
          (SELECT nombre FROM public.comunidades WHERE id_comunidad = v_c_tech),
          'Tech Founders Circle'
        ) || '.',
        now() - interval '6 days',
        usr.id_usuario, v_c_tech
      ),
      (
        'Reflexion de la semana',
        usr.nombres || ' ' || usr.apellidos || ' comparte: esta semana aprendi '
        'mucho escuchando a otros miembros. Gracias por el apoyo.',
        now() - interval '4 days',
        usr.id_usuario, v_c_yoga
      ),
      (
        'Fotos del ultimo encuentro',
        'Subiendo algunas imagenes del evento de ayer. Fue genial ver tanta '
        'energia en el espacio creativo.',
        now() - interval '2 days',
        usr.id_usuario, v_c_arte
      ),
      (
        'Proximo evento confirmado',
        'Ya tenemos fecha para el proximo meetup. Reserven cupo pronto, '
        'los lugares vuelan.',
        now() - interval '8 hours',
        usr.id_usuario, v_c_tech
      );
  END LOOP;

  -- Miembros extra en comunidades (mas alla del seed de comunidades)
  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_tech, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'valentina.morales@loop.cl',
    'diego.henriquez@loop.cl',
    'matias.vega@loop.cl'
  )
  ON CONFLICT DO NOTHING;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_yoga, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'camila.rosas@loop.cl',
    'sofia.torres@loop.cl',
    'user@loop.cl'
  )
  ON CONFLICT DO NOTHING;

  INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
  SELECT v_c_arte, u.id_usuario, 'MIEMBRO'
  FROM public.usuario u
  WHERE u.email IN (
    'camila.rosas@loop.cl',
    'valentina.morales@loop.cl',
    'sofia.torres@loop.cl'
  )
  ON CONFLICT DO NOTHING;

END $$;

