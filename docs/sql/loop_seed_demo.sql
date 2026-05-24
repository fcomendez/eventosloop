-- LOOP — Datos demo extendidos (50 usuarios, 50 comunidades, 50 eventos, 100 publicaciones)
-- Ejecutar DESPUES de loop_seed_catalogo.sql via scripts/seed-demo.ps1
-- Re-ejecutable. Fotos: cargar luego a Storage (avatar_url, banner_url, cover_url, url_media NULL).

CREATE EXTENSION IF NOT EXISTS pgcrypto;

TRUNCATE TABLE
  public.notificacion,
  public.reacciones_post,
  public.comentario,
  public.publicaciones,
  public.participantes_evento,
  public.evento,
  public.comunidad_intereses,
  public.miembro_comunidad,
  public.comunidades,
  public.seguidores,
  public.usuario_intereses,
  public.roles_sistema,
  public.reporte_publicacion,
  public.reporte_evento,
  public.usuario
RESTART IDENTITY CASCADE;

DO $$
DECLARE
  v_emails text[] := ARRAY[
    'admin@loop.cl',
    'user@loop.cl',
    'valentina.morales@loop.cl',
    'diego.henriquez@loop.cl',
    'camila.rosas@loop.cl',
    'matias.vega@loop.cl',
    'sofia.torres@loop.cl',
    'francisco.silva@loop.cl',
    'javier.urrutia@loop.cl',
    'paula.henriquez@loop.cl',
    'sebastian.lopez@loop.cl',
    'carolina.munoz@loop.cl',
    'andres.pizarro@loop.cl',
    'fernanda.castro@loop.cl',
    'nicolas.rivas@loop.cl',
    'isidora.gonzalez@loop.cl',
    'rodrigo.saez@loop.cl',
    'antonia.figueroa@loop.cl',
    'tomas.araya@loop.cl',
    'catalina.vergara@loop.cl',
    'benjamin.ojeda@loop.cl',
    'martina.salinas@loop.cl',
    'felipe.contreras@loop.cl',
    'javiera.tapia@loop.cl',
    'gonzalo.miranda@loop.cl',
    'barbara.hidalgo@loop.cl',
    'cristobal.nunez@loop.cl',
    'daniela.paredes@loop.cl',
    'maximiliano.rojas@loop.cl',
    'florencia.medina@loop.cl',
    'ignacio.fuentes@loop.cl',
    'constanza.reyes@loop.cl',
    'patricio.soto@loop.cl',
    'macarena.garrido@loop.cl',
    'alejandro.carrasco@loop.cl',
    'renata.espinoza@loop.cl',
    'vicente.poblete@loop.cl',
    'amanda.jara@loop.cl',
    'emilio.valdes@loop.cl',
    'trinidad.osorio@loop.cl',
    'marcelo.aguilera@loop.cl',
    'paz.montecinos@loop.cl',
    'hernan.bravo@loop.cl',
    'gabriela.quintana@loop.cl',
    'lucas.sandoval@loop.cl',
    'dominique.alarcon@loop.cl',
    'esteban.cifuentes@loop.cl',
    'carla.venegas@loop.cl',
    'ricardo.palma@loop.cl',
    'elisa.zamora@loop.cl'
  ];
  v_uuids uuid[] := ARRAY[
    '11111111-1111-1111-1111-111111111111'::uuid,
    '22222222-2222-2222-2222-222222222222'::uuid,
    '33333333-3333-3333-3333-000000000003'::uuid,
    '33333333-3333-3333-3333-000000000004'::uuid,
    '33333333-3333-3333-3333-000000000005'::uuid,
    '33333333-3333-3333-3333-000000000006'::uuid,
    '33333333-3333-3333-3333-000000000007'::uuid,
    '33333333-3333-3333-3333-000000000008'::uuid,
    '33333333-3333-3333-3333-000000000009'::uuid,
    '33333333-3333-3333-3333-000000000010'::uuid,
    '33333333-3333-3333-3333-000000000011'::uuid,
    '33333333-3333-3333-3333-000000000012'::uuid,
    '33333333-3333-3333-3333-000000000013'::uuid,
    '33333333-3333-3333-3333-000000000014'::uuid,
    '33333333-3333-3333-3333-000000000015'::uuid,
    '33333333-3333-3333-3333-000000000016'::uuid,
    '33333333-3333-3333-3333-000000000017'::uuid,
    '33333333-3333-3333-3333-000000000018'::uuid,
    '33333333-3333-3333-3333-000000000019'::uuid,
    '33333333-3333-3333-3333-000000000020'::uuid,
    '33333333-3333-3333-3333-000000000021'::uuid,
    '33333333-3333-3333-3333-000000000022'::uuid,
    '33333333-3333-3333-3333-000000000023'::uuid,
    '33333333-3333-3333-3333-000000000024'::uuid,
    '33333333-3333-3333-3333-000000000025'::uuid,
    '33333333-3333-3333-3333-000000000026'::uuid,
    '33333333-3333-3333-3333-000000000027'::uuid,
    '33333333-3333-3333-3333-000000000028'::uuid,
    '33333333-3333-3333-3333-000000000029'::uuid,
    '33333333-3333-3333-3333-000000000030'::uuid,
    '33333333-3333-3333-3333-000000000031'::uuid,
    '33333333-3333-3333-3333-000000000032'::uuid,
    '33333333-3333-3333-3333-000000000033'::uuid,
    '33333333-3333-3333-3333-000000000034'::uuid,
    '33333333-3333-3333-3333-000000000035'::uuid,
    '33333333-3333-3333-3333-000000000036'::uuid,
    '33333333-3333-3333-3333-000000000037'::uuid,
    '33333333-3333-3333-3333-000000000038'::uuid,
    '33333333-3333-3333-3333-000000000039'::uuid,
    '33333333-3333-3333-3333-000000000040'::uuid,
    '33333333-3333-3333-3333-000000000041'::uuid,
    '33333333-3333-3333-3333-000000000042'::uuid,
    '33333333-3333-3333-3333-000000000043'::uuid,
    '33333333-3333-3333-3333-000000000044'::uuid,
    '33333333-3333-3333-3333-000000000045'::uuid,
    '33333333-3333-3333-3333-000000000046'::uuid,
    '33333333-3333-3333-3333-000000000047'::uuid,
    '33333333-3333-3333-3333-000000000048'::uuid,
    '33333333-3333-3333-3333-000000000049'::uuid,
    '33333333-3333-3333-3333-000000000050'::uuid
  ];
BEGIN
  DELETE FROM auth.identities WHERE user_id IN (
    SELECT id FROM auth.users WHERE email = ANY(v_emails));
  DELETE FROM auth.users WHERE email = ANY(v_emails);
  DELETE FROM auth.identities WHERE user_id = ANY(v_uuids);
  DELETE FROM auth.users WHERE id = ANY(v_uuids);
END $$;

DO $$
BEGIN
  CREATE TEMP TABLE _seed_auth (
    auth_id uuid, email text, password text, meta_nombre text
  ) ON COMMIT DROP;
  INSERT INTO _seed_auth (auth_id, email, password, meta_nombre) VALUES
    ('11111111-1111-1111-1111-111111111111'::uuid, 'admin@loop.cl', 'LoopAdmin1', 'Admin LOOP'),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'user@loop.cl', 'LoopUser1', 'Usuario Prueba'),
    ('33333333-3333-3333-3333-000000000003'::uuid, 'valentina.morales@loop.cl', 'LoopDemo1', 'Valentina Morales'),
    ('33333333-3333-3333-3333-000000000004'::uuid, 'diego.henriquez@loop.cl', 'LoopDemo1', 'Diego Henriquez'),
    ('33333333-3333-3333-3333-000000000005'::uuid, 'camila.rosas@loop.cl', 'LoopDemo1', 'Camila Rosas'),
    ('33333333-3333-3333-3333-000000000006'::uuid, 'matias.vega@loop.cl', 'LoopDemo1', 'Matias Vega'),
    ('33333333-3333-3333-3333-000000000007'::uuid, 'sofia.torres@loop.cl', 'LoopDemo1', 'Sofia Torres'),
    ('33333333-3333-3333-3333-000000000008'::uuid, 'francisco.silva@loop.cl', 'LoopDemo1', 'Francisco Silva'),
    ('33333333-3333-3333-3333-000000000009'::uuid, 'javier.urrutia@loop.cl', 'LoopDemo1', 'Javier Urrutia'),
    ('33333333-3333-3333-3333-000000000010'::uuid, 'paula.henriquez@loop.cl', 'LoopDemo1', 'Paula Henriquez'),
    ('33333333-3333-3333-3333-000000000011'::uuid, 'sebastian.lopez@loop.cl', 'LoopDemo1', 'Sebastian Lopez'),
    ('33333333-3333-3333-3333-000000000012'::uuid, 'carolina.munoz@loop.cl', 'LoopDemo1', 'Carolina Munoz'),
    ('33333333-3333-3333-3333-000000000013'::uuid, 'andres.pizarro@loop.cl', 'LoopDemo1', 'Andres Pizarro'),
    ('33333333-3333-3333-3333-000000000014'::uuid, 'fernanda.castro@loop.cl', 'LoopDemo1', 'Fernanda Castro'),
    ('33333333-3333-3333-3333-000000000015'::uuid, 'nicolas.rivas@loop.cl', 'LoopDemo1', 'Nicolas Rivas'),
    ('33333333-3333-3333-3333-000000000016'::uuid, 'isidora.gonzalez@loop.cl', 'LoopDemo1', 'Isidora Gonzalez'),
    ('33333333-3333-3333-3333-000000000017'::uuid, 'rodrigo.saez@loop.cl', 'LoopDemo1', 'Rodrigo Saez'),
    ('33333333-3333-3333-3333-000000000018'::uuid, 'antonia.figueroa@loop.cl', 'LoopDemo1', 'Antonia Figueroa'),
    ('33333333-3333-3333-3333-000000000019'::uuid, 'tomas.araya@loop.cl', 'LoopDemo1', 'Tomas Araya'),
    ('33333333-3333-3333-3333-000000000020'::uuid, 'catalina.vergara@loop.cl', 'LoopDemo1', 'Catalina Vergara'),
    ('33333333-3333-3333-3333-000000000021'::uuid, 'benjamin.ojeda@loop.cl', 'LoopDemo1', 'Benjamin Ojeda'),
    ('33333333-3333-3333-3333-000000000022'::uuid, 'martina.salinas@loop.cl', 'LoopDemo1', 'Martina Salinas'),
    ('33333333-3333-3333-3333-000000000023'::uuid, 'felipe.contreras@loop.cl', 'LoopDemo1', 'Felipe Contreras'),
    ('33333333-3333-3333-3333-000000000024'::uuid, 'javiera.tapia@loop.cl', 'LoopDemo1', 'Javiera Tapia'),
    ('33333333-3333-3333-3333-000000000025'::uuid, 'gonzalo.miranda@loop.cl', 'LoopDemo1', 'Gonzalo Miranda'),
    ('33333333-3333-3333-3333-000000000026'::uuid, 'barbara.hidalgo@loop.cl', 'LoopDemo1', 'Barbara Hidalgo'),
    ('33333333-3333-3333-3333-000000000027'::uuid, 'cristobal.nunez@loop.cl', 'LoopDemo1', 'Cristobal Nunez'),
    ('33333333-3333-3333-3333-000000000028'::uuid, 'daniela.paredes@loop.cl', 'LoopDemo1', 'Daniela Paredes'),
    ('33333333-3333-3333-3333-000000000029'::uuid, 'maximiliano.rojas@loop.cl', 'LoopDemo1', 'Maximiliano Rojas'),
    ('33333333-3333-3333-3333-000000000030'::uuid, 'florencia.medina@loop.cl', 'LoopDemo1', 'Florencia Medina'),
    ('33333333-3333-3333-3333-000000000031'::uuid, 'ignacio.fuentes@loop.cl', 'LoopDemo1', 'Ignacio Fuentes'),
    ('33333333-3333-3333-3333-000000000032'::uuid, 'constanza.reyes@loop.cl', 'LoopDemo1', 'Constanza Reyes'),
    ('33333333-3333-3333-3333-000000000033'::uuid, 'patricio.soto@loop.cl', 'LoopDemo1', 'Patricio Soto'),
    ('33333333-3333-3333-3333-000000000034'::uuid, 'macarena.garrido@loop.cl', 'LoopDemo1', 'Macarena Garrido'),
    ('33333333-3333-3333-3333-000000000035'::uuid, 'alejandro.carrasco@loop.cl', 'LoopDemo1', 'Alejandro Carrasco'),
    ('33333333-3333-3333-3333-000000000036'::uuid, 'renata.espinoza@loop.cl', 'LoopDemo1', 'Renata Espinoza'),
    ('33333333-3333-3333-3333-000000000037'::uuid, 'vicente.poblete@loop.cl', 'LoopDemo1', 'Vicente Poblete'),
    ('33333333-3333-3333-3333-000000000038'::uuid, 'amanda.jara@loop.cl', 'LoopDemo1', 'Amanda Jara'),
    ('33333333-3333-3333-3333-000000000039'::uuid, 'emilio.valdes@loop.cl', 'LoopDemo1', 'Emilio Valdes'),
    ('33333333-3333-3333-3333-000000000040'::uuid, 'trinidad.osorio@loop.cl', 'LoopDemo1', 'Trinidad Osorio'),
    ('33333333-3333-3333-3333-000000000041'::uuid, 'marcelo.aguilera@loop.cl', 'LoopDemo1', 'Marcelo Aguilera'),
    ('33333333-3333-3333-3333-000000000042'::uuid, 'paz.montecinos@loop.cl', 'LoopDemo1', 'Paz Montecinos'),
    ('33333333-3333-3333-3333-000000000043'::uuid, 'hernan.bravo@loop.cl', 'LoopDemo1', 'Hernan Bravo'),
    ('33333333-3333-3333-3333-000000000044'::uuid, 'gabriela.quintana@loop.cl', 'LoopDemo1', 'Gabriela Quintana'),
    ('33333333-3333-3333-3333-000000000045'::uuid, 'lucas.sandoval@loop.cl', 'LoopDemo1', 'Lucas Sandoval'),
    ('33333333-3333-3333-3333-000000000046'::uuid, 'dominique.alarcon@loop.cl', 'LoopDemo1', 'Dominique Alarcon'),
    ('33333333-3333-3333-3333-000000000047'::uuid, 'esteban.cifuentes@loop.cl', 'LoopDemo1', 'Esteban Cifuentes'),
    ('33333333-3333-3333-3333-000000000048'::uuid, 'carla.venegas@loop.cl', 'LoopDemo1', 'Carla Venegas'),
    ('33333333-3333-3333-3333-000000000049'::uuid, 'ricardo.palma@loop.cl', 'LoopDemo1', 'Ricardo Palma'),
    ('33333333-3333-3333-3333-000000000050'::uuid, 'elisa.zamora@loop.cl', 'LoopDemo1', 'Elisa Zamora');

  INSERT INTO auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, invited_at, confirmation_token,
    recovery_token, email_change_token_new, email_change,
    created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
    is_super_admin, phone, phone_confirmed_at
  )
  SELECT auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
    email, crypt(password, gen_salt('bf')), now(), now(), '', '', '', '',
    now(), now(), '{"provider":"email","providers":["email"]}'::jsonb,
    jsonb_build_object('nombre', meta_nombre), false, null, null
  FROM _seed_auth;

  INSERT INTO auth.identities (
    id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at
  )
  SELECT auth_id, auth_id, auth_id::text,
    jsonb_build_object('sub', auth_id::text, 'email', email),
    'email', now(), now(), now()
  FROM _seed_auth;
END $$;

INSERT INTO public.usuario (
  auth_user_id, email, username, nombres, apellidos, fecha_nacimiento, genero,
  comuna_id_comuna, rol_user, estado_cuenta, telefono, nacionalidad
) VALUES
  ('11111111-1111-1111-1111-111111111111'::uuid, 'admin@loop.cl', 'admin_loop', 'Admin', 'LOOP', '1990-01-15', 'Otro', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'ADMIN', 'ACTIVO', '+912000001', 'Chileno'),
  ('22222222-2222-2222-2222-222222222222'::uuid, 'user@loop.cl', 'user_loop', 'Usuario', 'Prueba', '1995-06-20', 'Otro', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Nunoa' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000002', 'Chileno'),
  ('33333333-3333-3333-3333-000000000003'::uuid, 'valentina.morales@loop.cl', 'vale_morales', 'Valentina', 'Morales', '1998-03-12', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000003', 'Chileno'),
  ('33333333-3333-3333-3333-000000000004'::uuid, 'diego.henriquez@loop.cl', 'diego_h', 'Diego', 'Henriquez', '1992-11-08', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000004', 'Chileno'),
  ('33333333-3333-3333-3333-000000000005'::uuid, 'camila.rosas@loop.cl', 'cami_rosas', 'Camila', 'Rosas', '1999-07-25', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Maipu' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000005', 'Chileno'),
  ('33333333-3333-3333-3333-000000000006'::uuid, 'matias.vega@loop.cl', 'mati_vega', 'Matias', 'Vega', '1994-02-18', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Florida' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000006', 'Chileno'),
  ('33333333-3333-3333-3333-000000000007'::uuid, 'sofia.torres@loop.cl', 'sofi_torres', 'Sofia', 'Torres', '1996-09-30', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puente Alto' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000007', 'Chileno'),
  ('33333333-3333-3333-3333-000000000008'::uuid, 'francisco.silva@loop.cl', 'pancho_silva', 'Francisco', 'Silva', '1991-04-22', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000008', 'Chileno'),
  ('33333333-3333-3333-3333-000000000009'::uuid, 'javier.urrutia@loop.cl', 'javi_u', 'Javier', 'Urrutia', '1988-12-03', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'MODERADOR', 'ACTIVO', '+912000009', 'Chileno'),
  ('33333333-3333-3333-3333-000000000010'::uuid, 'paula.henriquez@loop.cl', 'paula_h', 'Paula', 'Henriquez', '1993-08-14', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Nunoa' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000010', 'Chileno'),
  ('33333333-3333-3333-3333-000000000011'::uuid, 'sebastian.lopez@loop.cl', 'seba_lopez', 'Sebastian', 'Lopez', '1990-05-30', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000011', 'Chileno'),
  ('33333333-3333-3333-3333-000000000012'::uuid, 'carolina.munoz@loop.cl', 'caro_munoz', 'Carolina', 'Munoz', '1997-01-19', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Maipu' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000012', 'Chileno'),
  ('33333333-3333-3333-3333-000000000013'::uuid, 'andres.pizarro@loop.cl', 'andres_p', 'Andres', 'Pizarro', '1989-10-07', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Florida' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'SUSPENDIDO', '+912000013', 'Chileno'),
  ('33333333-3333-3333-3333-000000000014'::uuid, 'fernanda.castro@loop.cl', 'fer_castro', 'Fernanda', 'Castro', '1995-06-11', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puente Alto' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000014', 'Chileno'),
  ('33333333-3333-3333-3333-000000000015'::uuid, 'nicolas.rivas@loop.cl', 'nico_rivas', 'Nicolas', 'Rivas', '1992-03-28', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000015', 'Chileno'),
  ('33333333-3333-3333-3333-000000000016'::uuid, 'isidora.gonzalez@loop.cl', 'isa_gonzalez', 'Isidora', 'Gonzalez', '1998-11-02', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000016', 'Chileno'),
  ('33333333-3333-3333-3333-000000000017'::uuid, 'rodrigo.saez@loop.cl', 'rodrigo_s', 'Rodrigo', 'Saez', '1987-07-16', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Nunoa' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000017', 'Chileno'),
  ('33333333-3333-3333-3333-000000000018'::uuid, 'antonia.figueroa@loop.cl', 'anto_f', 'Antonia', 'Figueroa', '1994-09-09', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000018', 'Chileno'),
  ('33333333-3333-3333-3333-000000000019'::uuid, 'tomas.araya@loop.cl', 'tomas_a', 'Tomas', 'Araya', '1996-02-25', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valparaiso' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000019', 'Chileno'),
  ('33333333-3333-3333-3333-000000000020'::uuid, 'catalina.vergara@loop.cl', 'cata_v', 'Catalina', 'Vergara', '1999-04-08', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Vina del Mar' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000020', 'Chileno'),
  ('33333333-3333-3333-3333-000000000021'::uuid, 'benjamin.ojeda@loop.cl', 'benja_o', 'Benjamin', 'Ojeda', '1991-08-21', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Quilpue' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000021', 'Chileno'),
  ('33333333-3333-3333-3333-000000000022'::uuid, 'martina.salinas@loop.cl', 'marti_s', 'Martina', 'Salinas', '1993-12-14', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'San Antonio' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000022', 'Chileno'),
  ('33333333-3333-3333-3333-000000000023'::uuid, 'felipe.contreras@loop.cl', 'pipe_c', 'Felipe', 'Contreras', '1990-01-27', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valparaiso' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000023', 'Chileno'),
  ('33333333-3333-3333-3333-000000000024'::uuid, 'javiera.tapia@loop.cl', 'javi_t', 'Javiera', 'Tapia', '1997-05-05', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Vina del Mar' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000024', 'Chileno'),
  ('33333333-3333-3333-3333-000000000025'::uuid, 'gonzalo.miranda@loop.cl', 'gonza_m', 'Gonzalo', 'Miranda', '1988-06-18', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000025', 'Chileno'),
  ('33333333-3333-3333-3333-000000000026'::uuid, 'barbara.hidalgo@loop.cl', 'barbi_h', 'Barbara', 'Hidalgo', '1995-10-31', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talcahuano' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000026', 'Chileno'),
  ('33333333-3333-3333-3333-000000000027'::uuid, 'cristobal.nunez@loop.cl', 'cris_n', 'Cristobal', 'Nunez', '1992-07-07', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Chiguayante' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000027', 'Chileno'),
  ('33333333-3333-3333-3333-000000000028'::uuid, 'daniela.paredes@loop.cl', 'dani_p', 'Daniela', 'Paredes', '1998-03-23', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000028', 'Chileno'),
  ('33333333-3333-3333-3333-000000000029'::uuid, 'maximiliano.rojas@loop.cl', 'maxi_r', 'Maximiliano', 'Rojas', '1989-09-12', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talcahuano' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000029', 'Chileno'),
  ('33333333-3333-3333-3333-000000000030'::uuid, 'florencia.medina@loop.cl', 'flor_m', 'Florencia', 'Medina', '1994-11-29', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000030', 'Chileno'),
  ('33333333-3333-3333-3333-000000000031'::uuid, 'ignacio.fuentes@loop.cl', 'nacho_f', 'Ignacio', 'Fuentes', '1991-02-16', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Temuco' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000031', 'Chileno'),
  ('33333333-3333-3333-3333-000000000032'::uuid, 'constanza.reyes@loop.cl', 'coni_r', 'Constanza', 'Reyes', '1996-08-04', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Villarrica' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000032', 'Chileno'),
  ('33333333-3333-3333-3333-000000000033'::uuid, 'patricio.soto@loop.cl', 'pato_s', 'Patricio', 'Soto', '1987-04-11', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Padre Las Casas' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000033', 'Chileno'),
  ('33333333-3333-3333-3333-000000000034'::uuid, 'macarena.garrido@loop.cl', 'maca_g', 'Macarena', 'Garrido', '1999-01-08', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Temuco' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000034', 'Chileno'),
  ('33333333-3333-3333-3333-000000000035'::uuid, 'alejandro.carrasco@loop.cl', 'alex_c', 'Alejandro', 'Carrasco', '1993-06-26', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Angol' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), 'USER', 'SUSPENDIDO', '+912000035', 'Chileno'),
  ('33333333-3333-3333-3333-000000000036'::uuid, 'renata.espinoza@loop.cl', 'renata_e', 'Renata', 'Espinoza', '1997-12-19', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talca' AND r.nombre = 'Maule'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000036', 'Chileno'),
  ('33333333-3333-3333-3333-000000000037'::uuid, 'vicente.poblete@loop.cl', 'vicente_p', 'Vicente', 'Poblete', '1990-05-03', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Curico' AND r.nombre = 'Maule'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000037', 'Chileno'),
  ('33333333-3333-3333-3333-000000000038'::uuid, 'amanda.jara@loop.cl', 'amanda_j', 'Amanda', 'Jara', '1995-09-17', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Linares' AND r.nombre = 'Maule'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000038', 'Chileno'),
  ('33333333-3333-3333-3333-000000000039'::uuid, 'emilio.valdes@loop.cl', 'emilio_v', 'Emilio', 'Valdes', '1992-11-30', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talca' AND r.nombre = 'Maule'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000039', 'Chileno'),
  ('33333333-3333-3333-3333-000000000040'::uuid, 'trinidad.osorio@loop.cl', 'tri_osorio', 'Trinidad', 'Osorio', '1998-07-22', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Serena' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000040', 'Chileno'),
  ('33333333-3333-3333-3333-000000000041'::uuid, 'marcelo.aguilera@loop.cl', 'marcelo_a', 'Marcelo', 'Aguilera', '1988-03-09', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Coquimbo' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000041', 'Chileno'),
  ('33333333-3333-3333-3333-000000000042'::uuid, 'paz.montecinos@loop.cl', 'paz_m', 'Paz', 'Montecinos', '1994-10-15', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Ovalle' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000042', 'Chileno'),
  ('33333333-3333-3333-3333-000000000043'::uuid, 'hernan.bravo@loop.cl', 'hernan_b', 'Hernan', 'Bravo', '1991-01-28', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Serena' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000043', 'Chileno'),
  ('33333333-3333-3333-3333-000000000044'::uuid, 'gabriela.quintana@loop.cl', 'gabi_q', 'Gabriela', 'Quintana', '1996-04-02', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Rancagua' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000044', 'Chileno'),
  ('33333333-3333-3333-3333-000000000045'::uuid, 'lucas.sandoval@loop.cl', 'lucas_s', 'Lucas', 'Sandoval', '1989-08-19', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'San Fernando' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000045', 'Chileno'),
  ('33333333-3333-3333-3333-000000000046'::uuid, 'dominique.alarcon@loop.cl', 'domi_a', 'Dominique', 'Alarcon', '1997-06-06', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Rancagua' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000046', 'Chileno'),
  ('33333333-3333-3333-3333-000000000047'::uuid, 'esteban.cifuentes@loop.cl', 'esteban_c', 'Esteban', 'Cifuentes', '1993-02-13', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puerto Montt' AND r.nombre = 'Los Lagos'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000047', 'Chileno'),
  ('33333333-3333-3333-3333-000000000048'::uuid, 'carla.venegas@loop.cl', 'carla_v', 'Carla', 'Venegas', '1999-05-27', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puerto Varas' AND r.nombre = 'Los Lagos'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000048', 'Chileno'),
  ('33333333-3333-3333-3333-000000000049'::uuid, 'ricardo.palma@loop.cl', 'richi_p', 'Ricardo', 'Palma', '1990-12-01', 'Masculino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Chillan' AND r.nombre = 'Nuble'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000049', 'Chileno'),
  ('33333333-3333-3333-3333-000000000050'::uuid, 'elisa.zamora@loop.cl', 'elisa_z', 'Elisa', 'Zamora', '1995-03-18', 'Femenino', (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valdivia' AND r.nombre = 'Los Rios'
    LIMIT 1
  ), 'USER', 'ACTIVO', '+912000050', 'Chileno');

INSERT INTO public.roles_sistema (nombre_rol, usuario_id_usuario)
VALUES ('ADMIN', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1))
ON CONFLICT (usuario_id_usuario, nombre_rol) DO NOTHING;

INSERT INTO public.usuario_intereses (auth_user_id, id_interes)
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'videojuegos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cafeteria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'teatro'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'idiomas'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'reposteria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'videojuegos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trivia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'mascotas'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'jardineria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'andres.pizarro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'boxeo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'andres.pizarro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'karate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'andres.pizarro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'andres.pizarro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'andres.pizarro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'conciertos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'festivales'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'astronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ceramica'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'bisuteria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'enologia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocteleria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'museos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'picnic'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cafeteria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'teatro'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'conciertos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'videojuegos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'basquetbol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voleibol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ceramica'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'idiomas'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'alejandro.carrasco@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'alejandro.carrasco@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'alejandro.carrasco@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'alejandro.carrasco@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'alejandro.carrasco@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cafeteria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'enologia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'mascotas'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'jardineria'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'astronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'picnic'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'teatro'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'conciertos'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trivia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'karaoke'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT auth_user_id FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
ON CONFLICT DO NOTHING;

INSERT INTO public.comunidades (nombre, descripcion, privacidad, estado, usuario_id_usuario) VALUES
  ('Santiago Run Club', 'Comunidad de corredores urbanos en la capital. Salidas semanales por parques y costaneras.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1)),
  ('Emprendedores Providencia', 'Red de founders y profesionales tech en el sector oriente.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1)),
  ('Yoga Costanera', 'Practicas de yoga y mindfulness al aire libre en Santiago.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1)),
  ('Fotografia Urbana RM', 'Salidas fotograficas por barrios patrimoniales y arte callejero.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1)),
  ('Gamers Metropolitana', 'Torneos amistosos, LAN parties y gaming social.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1)),
  ('Cocina de Barrio', 'Intercambio de recetas, cenas compartidas y talleres caseros.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1)),
  ('Ciclistas Cordillera', 'Rutas en bici por Santiago y cerros urbanos.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1)),
  ('Lectores de Nunoa', 'Club de lectura con encuentros mensuales en cafes locales.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1)),
  ('Voluntariado Capital', 'Proyectos sociales y actividades de impacto comunitario.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1)),
  ('After Office Las Condes', 'Networking profesional post jornada laboral.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1)),
  ('Senderismo RM Sur', 'Trekking de fin de semana en reservas cercanas a Santiago.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1)),
  ('Arte y Ceramica', 'Talleres creativos de pintura, ceramica y manualidades.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1)),
  ('Futbol Cinco La Florida', 'Partidos recreativos de futbol sala los jueves.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1)),
  ('Conciertos y Festivales', 'Organizacion de salidas grupales a shows en vivo.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1)),
  ('Astronomos Urbanos', 'Observacion nocturna y charlas de divulgacion cientifica.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1)),
  ('Club Privado Creativos', 'Comunidad privada de diseno y fotografia avanzada.', 'PRIVADA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1)),
  ('Viña Fotografia Costera', 'Fotografia de paisaje y street photo en el litoral central.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1)),
  ('Runners Viña-Reñaca', 'Entrenamientos matutinos frente al mar.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1)),
  ('Emprendedores Valpo', 'Ecosistema emprendedor porteño con pitch nights.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1)),
  ('Gastronomia San Antonio', 'Rutas de mariscos y cocina costera.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1)),
  ('Teatro y Cultura Valpo', 'Grupo de teatro comunitario y visitas culturales.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1)),
  ('Bio Bio Tech', 'Comunidad tech del Gran Concepcion.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1)),
  ('Yoga Talcahuano', 'Clases grupales de yoga y respiracion consciente.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1)),
  ('Deportes Bio Bio', 'Encuentros de futbol, basquetbol y voleibol recreativo.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1)),
  ('Arte Conce', 'Colectivo de artistas visuales penquistas.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1)),
  ('Trekking Arauco', 'Caminatas por senderos del sur de Biobio.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1)),
  ('Idiomas Conce', 'Intercambio de idiomas en cafes y bibliotecas.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1)),
  ('Temuco Trail Runners', 'Running de trail en la Araucania.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1)),
  ('Cocina Mapuche Sur', 'Gastronomia tradicional y cocina regional.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1)),
  ('Emprendedores Temuco', 'Red de negocios locales en la novena region.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1)),
  ('Bienestar Villarrica', 'Yoga, meditacion y vida sana junto al lago.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1)),
  ('Club Privado Araucania', 'Grupo cerrado de excursiones de montaña.', 'PRIVADA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1)),
  ('Cafe y Libros Talca', 'Encuentros literarios en el Maule.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1)),
  ('Vinos del Maule', 'Catas y enoturismo en valles cercanos.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1)),
  ('Mascotas Linares', 'Paseos caninos y adopciones responsables.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1)),
  ('Ciclistas Talca', 'Rodadas urbanas y rurales en el Maule.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1)),
  ('Astro La Serena', 'Observacion astronomica en el norte chico.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1)),
  ('Trekking Coquimbo', 'Senderismo costero y rutas del Elqui.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)),
  ('Yoga Ovalle', 'Practicas al aire libre en valles verdes.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1)),
  ('Running La Serena', 'Grupo de atletismo en la Avenida del Mar.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1)),
  ('Emprendedores Rancagua', 'Networking y mentorias para pymes locales.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1)),
  ('Futbol O Higgins', 'Campeonato relampago los fines de semana.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1)),
  ('Cultura Rancagua', 'Cine club y teatro comunitario.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)),
  ('Patagonia Outdoor', 'Excursiones y campismo en Los Lagos.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1)),
  ('Fotografia Lago Llanquihue', 'Salidas fotograficas en Puerto Varas y alrededores.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1)),
  ('Gaming Chillan', 'Comunidad gamer del valle itata.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1)),
  ('Valdivia Fluvial', 'Kayak, gastronomia y cultura fluvial.', 'PUBLICA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1)),
  ('Comunidad Pendiente Demo', 'Solicitud en revision para activacion.', 'PUBLICA', 'PENDIENTE', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1)),
  ('Colectivo Bloqueado', 'Comunidad suspendida por revision administrativa.', 'PUBLICA', 'BLOQUEADA', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1)),
  ('Enologia Las Condes', 'Catas privadas y maridajes para aficionados.', 'PRIVADA', 'ACTIVA', (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1));

INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'videojuegos'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trivia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'reposteria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'mascotas'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ceramica'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'bisuteria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'basquetbol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'conciertos'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'festivales'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'astronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'picnic'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cafeteria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'teatro'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'museos'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'basquetbol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voleibol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'pintura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ceramica'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'idiomas'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cafeteria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'enologia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'mascotas'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'voluntariado'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'jardineria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'astronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'meditacion'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'picnic'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'atletismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'ciclismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocina'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'futbol'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'teatro'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cine'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'conciertos'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'senderismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'campismo'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trekking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'fotografia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gaming'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'trivia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'karaoke'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'lectura'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'viajes'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'emprendimiento'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'debate'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'yoga'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'enologia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'cocteleria'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'gastronomia'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'running'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), id_interes FROM public.intereses WHERE slug = 'networking'
ON CONFLICT DO NOTHING;

INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Comunidad Pendiente Demo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Colectivo Bloqueado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'LIDER'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'MIEMBRO'
UNION ALL
SELECT (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'MIEMBRO'
ON CONFLICT DO NOTHING;

INSERT INTO public.evento (
  nombre, titulo, descripcion, ubicacion_direccion, direccion, cupos_max,
  latitud, longitud, fecha_realizacion, estado, es_privado, whatsapp_link,
  usuario_id_usuario, comuna_id_comuna, comunidad_id_comunidad
) VALUES
  ('Meetup founders', 'Pitch night de emprendedores', 'Encuentro presencial en WeWork Providencia, Providencia. Cupos limitados.', 'WeWork Providencia, Providencia', 'Av. Providencia 2653', 40, -33.4178, -70.6062, now() + interval '5 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP001', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Providencia' LIMIT 1)),
  ('Yoga al amanecer', 'Clase abierta de yoga', 'Encuentro presencial en Parque Bustamante, Providencia. Cupos limitados.', 'Parque Bustamante, Providencia', 'Av. Providencia 1500', 25, -33.441, -70.632, now() + interval '3 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP002', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Costanera' LIMIT 1)),
  ('Salida fotografica', 'Street photo en barrio Italia', 'Encuentro presencial en Barrio Italia, Providencia. Cupos limitados.', 'Barrio Italia, Providencia', 'Av. Italia 1200', 20, -33.4505, -70.612, now() + interval '8 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP003', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Urbana RM' LIMIT 1)),
  ('Torneo FIFA', 'Gaming night relampago', 'Encuentro presencial en Local esports Las Condes, Las Condes. Cupos limitados.', 'Local esports Las Condes, Las Condes', 'Av. Apoquindo 5950', 16, -33.401, -70.578, now() + interval '6 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP004', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gamers Metropolitana' LIMIT 1)),
  ('Cena compartida', 'Intercambio de recetas', 'Encuentro presencial en Centro civico Nunoa, Nunoa. Cupos limitados.', 'Centro civico Nunoa, Nunoa', 'Av. Irarrazaval 2400', 18, -33.456, -70.598, now() + interval '10 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Nunoa' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina de Barrio' LIMIT 1)),
  ('Rodada urbana', 'Ciclismo recreativo 25 km', 'Encuentro presencial en Plaza de Armas de Santiago, Santiago. Cupos limitados.', 'Plaza de Armas de Santiago, Santiago', 'Plaza de Armas', 30, -33.4372, -70.6506, now() + interval '4 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP006', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Cordillera' LIMIT 1)),
  ('Club de lectura', 'Debate libro del mes', 'Encuentro presencial en Cafe literario Nunoa, Nunoa. Cupos limitados.', 'Cafe literario Nunoa, Nunoa', 'Av. Grecia 2001', 15, -33.468, -70.61, now() + interval '12 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP007', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Nunoa' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Lectores de Nunoa' LIMIT 1)),
  ('Voluntariado parque', 'Limpieza comunitaria', 'Encuentro presencial en Parque O Higgins Maipu, Maipu. Cupos limitados.', 'Parque O Higgins Maipu, Maipu', 'Av. Pajaritos 4455', 35, -33.51, -70.758, now() + interval '7 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Maipu' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Voluntariado Capital' LIMIT 1)),
  ('After office', 'Networking ejecutivos', 'Encuentro presencial en Barrio financiero, Las Condes. Cupos limitados.', 'Barrio financiero, Las Condes', 'Av. Isidora Goyenechea 3000', 50, -33.405, -70.572, now() + interval '9 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP009', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'After Office Las Condes' LIMIT 1)),
  ('Trekking Arrayan', 'Senderismo moderado', 'Encuentro presencial en Entrada sendero La Florida, La Florida. Cupos limitados.', 'Entrada sendero La Florida, La Florida', 'Camino al Volcan 14000', 22, -33.545, -70.58, now() + interval '14 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP010', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Florida' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Senderismo RM Sur' LIMIT 1)),
  ('Taller ceramica', 'Manos a la arcilla', 'Encuentro presencial en Taller artesanal Bilbao, Providencia. Cupos limitados.', 'Taller artesanal Bilbao, Providencia', 'Av. Bilbao 1200', 12, -33.428, -70.618, now() + interval '11 days', 'ACTIVO', true, 'https://chat.whatsapp.com/DemoLOOP011', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte y Ceramica' LIMIT 1)),
  ('Futbol jueves', 'Partido recreativo', 'Encuentro presencial en Cancha La Florida, La Florida. Cupos limitados.', 'Cancha La Florida, La Florida', 'Av. Vicuña Mackenna 7110', 22, -33.52, -70.595, now() + interval '2 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP012', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Florida' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol Cinco La Florida' LIMIT 1)),
  ('Concierto indie', 'Salida grupal al venue', 'Encuentro presencial en Barrio Bellavista, Santiago. Cupos limitados.', 'Barrio Bellavista, Santiago', 'Ernesto Pinto Lagarrigue 364', 40, -33.433, -70.635, now() + interval '15 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP013', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Conciertos y Festivales' LIMIT 1)),
  ('Observacion lunar', 'Noche astronomica', 'Encuentro presencial en Mirador Puente Alto, Puente Alto. Cupos limitados.', 'Mirador Puente Alto, Puente Alto', 'Camino El Observatorio 1500', 30, -33.61, -70.575, now() + interval '18 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puente Alto' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astronomos Urbanos' LIMIT 1)),
  ('Sesion privada foto', 'Workshop avanzado', 'Encuentro presencial en Estudio privado, Las Condes. Cupos limitados.', 'Estudio privado, Las Condes', 'Av. Las Condes 11223', 8, -33.398, -70.565, now() + interval '20 days', 'ACTIVO', true, 'https://chat.whatsapp.com/DemoLOOP015', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Creativos' LIMIT 1)),
  ('Foto costera', 'Amanecer en Reñaca', 'Encuentro presencial en Playa Reñaca, Vina del Mar. Cupos limitados.', 'Playa Reñaca, Vina del Mar', 'Av. Borgono 14400', 25, -33.024, -71.551, now() + interval '5 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Vina del Mar' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Viña Fotografia Costera' LIMIT 1)),
  ('Running costanera', 'Entrenamiento 10K', 'Encuentro presencial en Costanera Viña, Vina del Mar. Cupos limitados.', 'Costanera Viña, Vina del Mar', 'Av. San Martin 100', 35, -33.015, -71.545, now() + interval '4 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Vina del Mar' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Runners Viña-Reñaca' LIMIT 1)),
  ('Pitch Valpo', 'Demo day emprendedores', 'Encuentro presencial en Centro Valparaiso, Valparaiso. Cupos limitados.', 'Centro Valparaiso, Valparaiso', 'Av. Pedro Montt 1600', 45, -33.045, -71.62, now() + interval '13 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP018', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valparaiso' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Valpo' LIMIT 1)),
  ('Ruta mariscos', 'Tour gastronomico', 'Encuentro presencial en Caleta San Antonio, San Antonio. Cupos limitados.', 'Caleta San Antonio, San Antonio', 'Av. Barros Luco 1050', 20, -33.595, -71.607, now() + interval '16 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'San Antonio' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gastronomia San Antonio' LIMIT 1)),
  ('Obra de teatro', 'Funcion comunitaria', 'Encuentro presencial en Plaza Sotomayor Valparaiso, Valparaiso. Cupos limitados.', 'Plaza Sotomayor Valparaiso, Valparaiso', 'Plaza Sotomayor', 60, -33.038, -71.629, now() + interval '21 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valparaiso' AND r.nombre = 'Valparaiso'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Teatro y Cultura Valpo' LIMIT 1)),
  ('Hackathon Bio Bio', 'Maraton de desarrollo', 'Encuentro presencial en Campus UdeC, Concepcion. Cupos limitados.', 'Campus UdeC, Concepcion', 'Edmundo Larenas 64', 80, -36.828, -73.032, now() + interval '6 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP021', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bio Bio Tech' LIMIT 1)),
  ('Yoga penquino', 'Clase al aire libre', 'Encuentro presencial en Playa Talcahuano, Talcahuano. Cupos limitados.', 'Playa Talcahuano, Talcahuano', 'Av. Colon 8010', 20, -36.724, -73.116, now() + interval '3 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talcahuano' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Talcahuano' LIMIT 1)),
  ('Torneo voleibol', 'Copa recreativa', 'Encuentro presencial en Gimnasio Chiguayante, Chiguayante. Cupos limitados.', 'Gimnasio Chiguayante, Chiguayante', 'Av. Pdte. Ibanez 560', 24, -36.925, -73.03, now() + interval '8 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Chiguayante' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Deportes Bio Bio' LIMIT 1)),
  ('Expo arte local', 'Muestra colectiva', 'Encuentro presencial en Galeria centro Conce, Concepcion. Cupos limitados.', 'Galeria centro Conce, Concepcion', 'O''Higgins 715', 100, -36.8267, -73.05, now() + interval '11 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP024', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Arte Conce' LIMIT 1)),
  ('Trek Laguna', 'Caminata de dia completo', 'Encuentro presencial en Inicio sendero, Concepcion. Cupos limitados.', 'Inicio sendero, Concepcion', 'Camino a Laguna 1200', 18, -36.85, -73.08, now() + interval '19 days', 'ACTIVO', true, 'https://chat.whatsapp.com/DemoLOOP025', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Arauco' LIMIT 1)),
  ('Intercambio ingles', 'Practica conversacional', 'Encuentro presencial en Cafe centro Conce, Concepcion. Cupos limitados.', 'Cafe centro Conce, Concepcion', 'Barros Arana 1234', 12, -36.827, -73.051, now() + interval '7 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP026', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Concepcion' AND r.nombre = 'Biobio'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Idiomas Conce' LIMIT 1)),
  ('Trail Temuco', 'Carrera de trail 12K', 'Encuentro presencial en Parque Alemania, Temuco. Cupos limitados.', 'Parque Alemania, Temuco', 'Av. Alemania 731', 40, -38.735, -72.587, now() + interval '9 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Temuco' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Temuco Trail Runners' LIMIT 1)),
  ('Comida tradicional', 'Taller cocina mapuche', 'Encuentro presencial en Centro cultural Temuco, Temuco. Cupos limitados.', 'Centro cultural Temuco, Temuco', 'Av. Caupolican 450', 16, -38.739, -72.592, now() + interval '14 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Temuco' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cocina Mapuche Sur' LIMIT 1)),
  ('Mentorias pymes', 'Sesion emprendedores', 'Encuentro presencial en Cowork Temuco, Temuco. Cupos limitados.', 'Cowork Temuco, Temuco', 'Calle Portales 450', 25, -38.737, -72.589, now() + interval '10 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP029', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Temuco' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Temuco' LIMIT 1)),
  ('Yoga lago', 'Practica junto al lago', 'Encuentro presencial en Orilla Lago Villarrica, Villarrica. Cupos limitados.', 'Orilla Lago Villarrica, Villarrica', 'Av. Pedro de Valdivia 500', 20, -39.279, -72.227, now() + interval '5 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Villarrica' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Bienestar Villarrica' LIMIT 1)),
  ('Expedicion privada', 'Ascenso reservado', 'Encuentro presencial en Base sendero, Padre Las Casas. Cupos limitados.', 'Base sendero, Padre Las Casas', 'Camino Volcan 800', 10, -38.78, -72.61, now() + interval '22 days', 'ACTIVO', true, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Padre Las Casas' AND r.nombre = 'La Araucania'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Club Privado Araucania' LIMIT 1)),
  ('Debate literario', 'Charla libro del mes', 'Encuentro presencial en Biblioteca regional Talca, Talca. Cupos limitados.', 'Biblioteca regional Talca, Talca', '1 Norte 800', 18, -35.426, -71.655, now() + interval '6 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP032', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talca' AND r.nombre = 'Maule'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cafe y Libros Talca' LIMIT 1)),
  ('Cata vinos', 'Degustacion Valle Curico', 'Encuentro presencial en Vina demo Curico, Curico. Cupos limitados.', 'Vina demo Curico, Curico', 'Camino San Jorge 100', 15, -34.98, -71.23, now() + interval '12 days', 'ACTIVO', true, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Curico' AND r.nombre = 'Maule'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Vinos del Maule' LIMIT 1)),
  ('Adopcion canina', 'Jornada mascotas', 'Encuentro presencial en Plaza Linares, Linares. Cupos limitados.', 'Plaza Linares, Linares', 'Av. Independencia 500', 30, -35.846, -71.593, now() + interval '8 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP034', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Linares' AND r.nombre = 'Maule'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Mascotas Linares' LIMIT 1)),
  ('Rodada Talca', 'Ciclismo 30 km', 'Encuentro presencial en Parque Talca, Talca. Cupos limitados.', 'Parque Talca, Talca', 'Av. San Miguel 3600', 28, -35.43, -71.64, now() + interval '4 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Talca' AND r.nombre = 'Maule'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Ciclistas Talca' LIMIT 1)),
  ('Observacion estrellas', 'Noche en el faro', 'Encuentro presencial en Faro Monumental, La Serena. Cupos limitados.', 'Faro Monumental, La Serena', 'Av. del Mar 1000', 35, -29.902, -71.252, now() + interval '17 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Serena' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Astro La Serena' LIMIT 1)),
  ('Trek costero', 'Caminata Guanaqueros', 'Encuentro presencial en Playa Coquimbo, Coquimbo. Cupos limitados.', 'Playa Coquimbo, Coquimbo', 'Av. Costanera 500', 22, -29.953, -71.339, now() + interval '13 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP037', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Coquimbo' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Trekking Coquimbo' LIMIT 1)),
  ('Picnic yoga', 'Practica al aire libre', 'Encuentro presencial en Parque Ovalle, Ovalle. Cupos limitados.', 'Parque Ovalle, Ovalle', 'Av. Benavente 800', 18, -30.601, -71.199, now() + interval '7 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Ovalle' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Yoga Ovalle' LIMIT 1)),
  ('Media maraton prep', 'Entrenamiento grupal', 'Encuentro presencial en Costanera La Serena, La Serena. Cupos limitados.', 'Costanera La Serena, La Serena', 'Av. del Mar 2500', 40, -29.91, -71.26, now() + interval '3 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'La Serena' AND r.nombre = 'Coquimbo'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Running La Serena' LIMIT 1)),
  ('Feria emprendedores', 'Expo negocios locales', 'Encuentro presencial en Plaza Rancagua, Rancagua. Cupos limitados.', 'Plaza Rancagua, Rancagua', 'Av. O''Higgins 600', 55, -34.17, -70.74, now() + interval '9 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP040', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Rancagua' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Emprendedores Rancagua' LIMIT 1)),
  ('Copa futbol', 'Torneo relampago', 'Encuentro presencial en Estadio San Fernando, San Fernando. Cupos limitados.', 'Estadio San Fernando, San Fernando', 'Av. Bernardo O''Higgins 700', 22, -34.585, -70.988, now() + interval '2 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'San Fernando' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Futbol O Higgins' LIMIT 1)),
  ('Cine foro', 'Proyeccion y debate', 'Encuentro presencial en Centro cultural Rancagua, Rancagua. Cupos limitados.', 'Centro cultural Rancagua, Rancagua', 'Av. Estado 450', 45, -34.175, -70.735, now() + interval '15 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Rancagua' AND r.nombre = 'O Higgins'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Cultura Rancagua' LIMIT 1)),
  ('Camping Llanquihue', 'Salida de campismo', 'Encuentro presencial en Costanera Puerto Montt, Puerto Montt. Cupos limitados.', 'Costanera Puerto Montt, Puerto Montt', 'Av. Angelm 2500', 16, -41.472, -72.936, now() + interval '20 days', 'ACTIVO', true, 'https://chat.whatsapp.com/DemoLOOP043', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puerto Montt' AND r.nombre = 'Los Lagos'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Patagonia Outdoor' LIMIT 1)),
  ('Foto volcan', 'Salida amanecer', 'Encuentro presencial en Mirador Puerto Varas, Puerto Varas. Cupos limitados.', 'Mirador Puerto Varas, Puerto Varas', 'Del Salvador 450', 14, -41.32, -72.985, now() + interval '11 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP044', (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Puerto Varas' AND r.nombre = 'Los Lagos'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Fotografia Lago Llanquihue' LIMIT 1)),
  ('LAN party', 'Torneo multijugador', 'Encuentro presencial en Centro Chillan, Chillan. Cupos limitados.', 'Centro Chillan, Chillan', 'Av. O''Higgins 450', 32, -36.606, -72.103, now() + interval '6 days', 'ACTIVO', false, 'https://chat.whatsapp.com/DemoLOOP045', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Chillan' AND r.nombre = 'Nuble'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Gaming Chillan' LIMIT 1)),
  ('Tour fluvial', 'Paseo en el rio', 'Encuentro presencial en Feria Fluvial Valdivia, Valdivia. Cupos limitados.', 'Feria Fluvial Valdivia, Valdivia', 'Av. Arturo Prat 550', 25, -39.814, -73.245, now() + interval '8 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Valdivia' AND r.nombre = 'Los Rios'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Valdivia Fluvial' LIMIT 1)),
  ('Karaoke night', 'Noche de canto grupal', 'Encuentro presencial en Barrio Lastarria, Santiago. Cupos limitados.', 'Barrio Lastarria, Santiago', 'Monjitas 550', 30, -33.439, -70.642, now() + interval '5 days', 'ACTIVO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1)),
  ('Cata privada', 'Maridaje exclusivo', 'Encuentro presencial en Lounge Las Condes, Las Condes. Cupos limitados.', 'Lounge Las Condes, Las Condes', 'Av. Apoquindo 3000', 10, -33.41, -70.585, now() + interval '16 days', 'ACTIVO', true, 'https://chat.whatsapp.com/DemoLOOP048', (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Las Condes' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Enologia Las Condes' LIMIT 1)),
  ('Evento cancelado demo', 'Ejemplo estado cancelado', 'Encuentro presencial en Plaza demo, Santiago. Cupos limitados.', 'Plaza demo, Santiago', 'Alameda 100', 20, -33.44, -70.65, now() + interval '-5 days', 'CANCELADO', false, 'https://chat.whatsapp.com/DemoLOOP049', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Santiago' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1)),
  ('Maraton historica', 'Evento ya realizado', 'Encuentro presencial en Parque demo, Providencia. Cupos limitados.', 'Parque demo, Providencia', 'Av. Providencia 1000', 100, -33.435, -70.625, now() + interval '-20 days', 'FINALIZADO', false, NULL, (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = 'Providencia' AND r.nombre = 'Metropolitana de Santiago'
    LIMIT 1
  ), (SELECT id_comunidad FROM public.comunidades WHERE nombre = 'Santiago Run Club' LIMIT 1));

INSERT INTO public.participantes_evento (evento_id_evento, usuario_id_usuario, estado_solicitud)
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Pitch night de emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase abierta de yoga' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase abierta de yoga' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase abierta de yoga' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase abierta de yoga' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Street photo en barrio Italia' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Gaming night relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Intercambio de recetas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo recreativo 25 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Debate libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Debate libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Debate libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Debate libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Debate libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Limpieza comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Networking ejecutivos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Networking ejecutivos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Networking ejecutivos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Networking ejecutivos' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Senderismo moderado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Manos a la arcilla' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Partido recreativo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida grupal al venue' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche astronomica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche astronomica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche astronomica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche astronomica' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Workshop avanzado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Amanecer en Reñaca' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento 10K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Demo day emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Tour gastronomico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Funcion comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Funcion comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Funcion comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Funcion comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Funcion comunitaria' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maraton de desarrollo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maraton de desarrollo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maraton de desarrollo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maraton de desarrollo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maraton de desarrollo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Clase al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Copa recreativa' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Muestra colectiva' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata de dia completo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica conversacional' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica conversacional' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica conversacional' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica conversacional' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Carrera de trail 12K' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Taller cocina mapuche' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Taller cocina mapuche' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Taller cocina mapuche' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Taller cocina mapuche' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Sesion emprendedores' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica junto al lago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ascenso reservado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Charla libro del mes' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Degustacion Valle Curico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Degustacion Valle Curico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Degustacion Valle Curico' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Jornada mascotas' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo 30 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo 30 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo 30 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ciclismo 30 km' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche en el faro' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata Guanaqueros' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata Guanaqueros' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata Guanaqueros' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Caminata Guanaqueros' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Practica al aire libre' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Entrenamiento grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Expo negocios locales' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo relampago' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Proyeccion y debate' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida de campismo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Salida amanecer' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo multijugador' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo multijugador' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo multijugador' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Torneo multijugador' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Paseo en el rio' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Noche de canto grupal' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'PENDIENTE'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), 'RECHAZADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Maridaje exclusivo' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Ejemplo estado cancelado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), 'ACEPTADO'
UNION ALL
SELECT (SELECT id_evento FROM public.evento WHERE titulo = 'Evento ya realizado' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), 'ACEPTADO'
ON CONFLICT DO NOTHING;

INSERT INTO public.publicaciones (titulo, contenido, fecha_publicacion, usuario_id_usuario, comunidades_id_comunidad, url_media) VALUES
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por admin.', now() - interval '1048 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'admin@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por admin.', now() - interval '591 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'admin@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por admin.', now() - interval '98 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'admin@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por admin.', now() - interval '783 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'admin@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por user.', now() - interval '795 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'user@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por user.', now() - interval '855 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'user@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por user.', now() - interval '642 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'user@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por user.', now() - interval '112 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'user@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por valentina.morales.', now() - interval '28 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'valentina.morales@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por valentina.morales.', now() - interval '516 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'valentina.morales@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por valentina.morales.', now() - interval '417 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'valentina.morales@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por valentina.morales.', now() - interval '909 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'valentina.morales@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por diego.henriquez.', now() - interval '463 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'diego.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por diego.henriquez.', now() - interval '755 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'diego.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por diego.henriquez.', now() - interval '404 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'diego.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por diego.henriquez.', now() - interval '398 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'diego.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por camila.rosas.', now() - interval '604 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'camila.rosas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por camila.rosas.', now() - interval '921 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'camila.rosas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por camila.rosas.', now() - interval '365 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'camila.rosas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por camila.rosas.', now() - interval '154 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'camila.rosas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por matias.vega.', now() - interval '384 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'matias.vega@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por matias.vega.', now() - interval '357 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'matias.vega@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por matias.vega.', now() - interval '1054 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'matias.vega@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por matias.vega.', now() - interval '246 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'matias.vega@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por sofia.torres.', now() - interval '774 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sofia.torres@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por sofia.torres.', now() - interval '85 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sofia.torres@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por sofia.torres.', now() - interval '879 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sofia.torres@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por sofia.torres.', now() - interval '573 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sofia.torres@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por francisco.silva.', now() - interval '543 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'francisco.silva@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por francisco.silva.', now() - interval '268 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'francisco.silva@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por francisco.silva.', now() - interval '331 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'francisco.silva@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por francisco.silva.', now() - interval '524 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'francisco.silva@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por javier.urrutia.', now() - interval '13 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javier.urrutia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por javier.urrutia.', now() - interval '678 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javier.urrutia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por javier.urrutia.', now() - interval '957 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javier.urrutia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por javier.urrutia.', now() - interval '319 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javier.urrutia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por paula.henriquez.', now() - interval '83 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'paula.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por paula.henriquez.', now() - interval '316 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'paula.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por paula.henriquez.', now() - interval '662 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'paula.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por paula.henriquez.', now() - interval '106 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'paula.henriquez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por sebastian.lopez.', now() - interval '618 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sebastian.lopez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por sebastian.lopez.', now() - interval '1006 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'sebastian.lopez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por carolina.munoz.', now() - interval '735 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'carolina.munoz@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por carolina.munoz.', now() - interval '151 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'carolina.munoz@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por fernanda.castro.', now() - interval '652 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'fernanda.castro@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por fernanda.castro.', now() - interval '1078 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'fernanda.castro@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por nicolas.rivas.', now() - interval '452 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'nicolas.rivas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por nicolas.rivas.', now() - interval '378 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'nicolas.rivas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por isidora.gonzalez.', now() - interval '1068 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'isidora.gonzalez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por isidora.gonzalez.', now() - interval '141 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'isidora.gonzalez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por rodrigo.saez.', now() - interval '1036 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'rodrigo.saez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por rodrigo.saez.', now() - interval '328 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'rodrigo.saez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por antonia.figueroa.', now() - interval '853 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'antonia.figueroa@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por antonia.figueroa.', now() - interval '828 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'antonia.figueroa@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por tomas.araya.', now() - interval '190 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'tomas.araya@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por tomas.araya.', now() - interval '717 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'tomas.araya@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por catalina.vergara.', now() - interval '455 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'catalina.vergara@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por catalina.vergara.', now() - interval '438 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'catalina.vergara@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por benjamin.ojeda.', now() - interval '681 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'benjamin.ojeda@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por benjamin.ojeda.', now() - interval '680 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'benjamin.ojeda@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por martina.salinas.', now() - interval '740 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'martina.salinas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por martina.salinas.', now() - interval '603 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'martina.salinas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por felipe.contreras.', now() - interval '449 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'felipe.contreras@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por felipe.contreras.', now() - interval '974 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'felipe.contreras@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por javiera.tapia.', now() - interval '20 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javiera.tapia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por javiera.tapia.', now() - interval '236 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'javiera.tapia@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por gonzalo.miranda.', now() - interval '710 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'gonzalo.miranda@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por gonzalo.miranda.', now() - interval '914 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'gonzalo.miranda@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por barbara.hidalgo.', now() - interval '494 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'barbara.hidalgo@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por barbara.hidalgo.', now() - interval '501 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'barbara.hidalgo@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por cristobal.nunez.', now() - interval '83 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'cristobal.nunez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por cristobal.nunez.', now() - interval '659 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'cristobal.nunez@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por daniela.paredes.', now() - interval '783 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'daniela.paredes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por daniela.paredes.', now() - interval '234 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'daniela.paredes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por maximiliano.rojas.', now() - interval '792 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'maximiliano.rojas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por maximiliano.rojas.', now() - interval '527 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'maximiliano.rojas@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por florencia.medina.', now() - interval '581 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'florencia.medina@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por florencia.medina.', now() - interval '52 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'florencia.medina@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por ignacio.fuentes.', now() - interval '1060 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'ignacio.fuentes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por ignacio.fuentes.', now() - interval '769 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'ignacio.fuentes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por constanza.reyes.', now() - interval '1055 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'constanza.reyes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por constanza.reyes.', now() - interval '1043 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'constanza.reyes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por patricio.soto.', now() - interval '914 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'patricio.soto@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por patricio.soto.', now() - interval '998 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'patricio.soto@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por macarena.garrido.', now() - interval '91 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'macarena.garrido@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Nuevo en la app', 'Recien llego a LOOP. Que comunidades recomiendan para empezar? — publicado por macarena.garrido.', now() - interval '609 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'macarena.garrido@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Despues del evento', 'Volviendo del evento con ganas de repetir. Gran organizacion. — publicado por renata.espinoza.', now() - interval '396 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'renata.espinoza@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Tips para principiantes', 'Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor. — publicado por renata.espinoza.', now() - interval '658 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'renata.espinoza@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Invitacion abierta', 'Invitacion abierta al proximo encuentro. Traigan agua y buena onda. — publicado por vicente.poblete.', now() - interval '1054 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'vicente.poblete@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Logro personal', 'Cumpli mi meta del mes gracias a este grupo. Arriba! — publicado por vicente.poblete.', now() - interval '170 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'vicente.poblete@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Hola LOOP', 'Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca. — publicado por amanda.jara.', now() - interval '198 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'amanda.jara@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Reflexion de la semana', 'Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron. — publicado por emilio.valdes.', now() - interval '344 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'emilio.valdes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Fotos del encuentro', 'Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo. — publicado por trinidad.osorio.', now() - interval '17 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'trinidad.osorio@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Proximo evento', 'Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo. — publicado por marcelo.aguilera.', now() - interval '136 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'marcelo.aguilera@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Busco companeros', 'Alguien se anima a acompanarme este fin de semana? Cupos limitados. — publicado por paz.montecinos.', now() - interval '433 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'paz.montecinos@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Gracias comunidad', 'Queria agradecer a la comunidad por el apoyo en mi primer evento. — publicado por hernan.bravo.', now() - interval '438 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'hernan.bravo@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Resumen del taller', 'Comparto un resumen de lo que vimos en el taller de ayer. — publicado por gabriela.quintana.', now() - interval '870 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'gabriela.quintana@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL),
  ('Recomendacion local', 'Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento. — publicado por lucas.sandoval.', now() - interval '214 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'lucas.sandoval@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 1
        ), NULL),
  ('Anuncio importante', 'Ojo: cambiamos la hora de salida por clima. Aviso por aca. — publicado por dominique.alarcon.', now() - interval '423 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'dominique.alarcon@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 2
        ), NULL),
  ('Pregunta rapida', 'Duda: hay estacionamiento cerca del punto de encuentro? — publicado por esteban.cifuentes.', now() - interval '893 hours', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = 'esteban.cifuentes@loop.cl'
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET 0
        ), NULL);

INSERT INTO public.comentario (texto_comentario, usuario_id_usuario, publicaciones_id_post)
VALUES
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 0)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 1)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 2)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 3)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 4)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 6)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 7)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 10)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 11)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 12)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 13)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 14)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 15)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 16)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 17)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 19)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 22)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 23)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 24)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 25)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 26)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 27)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 28)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 29)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 30)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 31)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 32)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 33)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 34)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 35)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 36)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 37)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 38)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 39)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 40)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 41)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 42)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 43)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 44)),
  ('Buenisimo, nos vemos en el proximo!', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 45)),
  ('Me anote, gracias por compartir.', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 46)),
  ('Que buena iniciativa, apoyo total.', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 47)),
  ('Tengo una duda, a que hora es?', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 48)),
  ('Estuve en el evento anterior y estuvo 10/10.', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 49));

INSERT INTO public.reacciones_post (tipo_reaccion, usuario_id_usuario, publicaciones_id_post)
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 30)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 50)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 31)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 49)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 58)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'user@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 64)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 11)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 16)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 33)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 41)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 6)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 27)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 50)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 2)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 36)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 37)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 66)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 30)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 42)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 50)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 59)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 65)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 0)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 6)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 10)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 28)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 32)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 14)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 40)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 62)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 19)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 52)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 37)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 48)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 52)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 55)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 62)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 12)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 23)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 47)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 52)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 17)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 46)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 56)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 26)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 47)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 62)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 31)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 54)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 39)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 45)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 44)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 64)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 15)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 50)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 64)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 16)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 28)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 48)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 50)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 57)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 60)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 42)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 40)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 45)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 60)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 19)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 26)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 59)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 61)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 57)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 61)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 17)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 35)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 65)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 32)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 46)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 51)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 0)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 10)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 25)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 28)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 37)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 69)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 13)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 59)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 22)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 29)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 46)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 20)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 23)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 27)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 51)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 69)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 0)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 2)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 11)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 21)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 32)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 65)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 3)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 18)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 35)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 51)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 8)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 52)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 65)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 3)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 26)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 29)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 15)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 38)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 19)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 42)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 9)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 14)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 36)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 43)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 5)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 19)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 33)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 44)
UNION ALL
SELECT 'LIKE', (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET 61)
ON CONFLICT DO NOTHING;

INSERT INTO public.seguidores (id_usuario_seguidor, id_usuario_seguido)
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'felipe.contreras@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'diego.henriquez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'florencia.medina@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'benjamin.ojeda@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'rodrigo.saez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ignacio.fuentes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'fernanda.castro@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'vicente.poblete@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'elisa.zamora@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'renata.espinoza@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carolina.munoz@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'daniela.paredes@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'maximiliano.rojas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'esteban.cifuentes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'martina.salinas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'macarena.garrido@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'francisco.silva@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'emilio.valdes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'gabriela.quintana@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'nicolas.rivas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'catalina.vergara@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javiera.tapia@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'ricardo.palma@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'trinidad.osorio@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paula.henriquez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'cristobal.nunez@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'amanda.jara@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'paz.montecinos@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'matias.vega@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'marcelo.aguilera@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'valentina.morales@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'tomas.araya@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'dominique.alarcon@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'isidora.gonzalez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'gonzalo.miranda@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'carla.venegas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'admin@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'hernan.bravo@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'patricio.soto@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'lucas.sandoval@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'javier.urrutia@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'camila.rosas@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'antonia.figueroa@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'constanza.reyes@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'barbara.hidalgo@loop.cl' LIMIT 1)
UNION ALL
SELECT (SELECT id_usuario FROM public.usuario WHERE email = 'sebastian.lopez@loop.cl' LIMIT 1), (SELECT id_usuario FROM public.usuario WHERE email = 'sofia.torres@loop.cl' LIMIT 1)
ON CONFLICT DO NOTHING;

-- Credenciales: todos @loop.cl | admin LoopAdmin1 | resto LoopDemo1
-- Total: 50 usuarios, 50 comunidades, 50 eventos, 100 publicaciones
