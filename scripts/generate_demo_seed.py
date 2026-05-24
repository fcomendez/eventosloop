#!/usr/bin/env python3
"""Genera docs/sql/loop_seed_demo.sql con datos demo embebidos."""
from __future__ import annotations

import random
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "docs" / "sql" / "loop_seed_demo.sql"

random.seed(42)

USERS = [
    # seq, email, pass, nombres, apellidos, username, genero, birth, comuna, region, tel, rol, estado, intereses
    (1, "admin@loop.cl", "LoopAdmin1", "Admin", "LOOP", "admin_loop", "Otro", "1990-01-15", "Providencia", "Metropolitana de Santiago", "912000001", "ADMIN", "ACTIVO", "networking,emprendimiento,videojuegos"),
    (2, "user@loop.cl", "LoopUser1", "Usuario", "Prueba", "user_loop", "Otro", "1995-06-20", "Nunoa", "Metropolitana de Santiago", "912000002", "USER", "ACTIVO", "yoga,running,cafeteria"),
    (3, "valentina.morales@loop.cl", "LoopDemo1", "Valentina", "Morales", "vale_morales", "Femenino", "1998-03-12", "Providencia", "Metropolitana de Santiago", "912000003", "USER", "ACTIVO", "fotografia,pintura,teatro"),
    (4, "diego.henriquez@loop.cl", "LoopDemo1", "Diego", "Henriquez", "diego_h", "Masculino", "1992-11-08", "Las Condes", "Metropolitana de Santiago", "912000004", "USER", "ACTIVO", "emprendimiento,networking,gaming"),
    (5, "camila.rosas@loop.cl", "LoopDemo1", "Camila", "Rosas", "cami_rosas", "Femenino", "1999-07-25", "Maipu", "Metropolitana de Santiago", "912000005", "USER", "ACTIVO", "yoga,meditacion,senderismo"),
    (6, "matias.vega@loop.cl", "LoopDemo1", "Matias", "Vega", "mati_vega", "Masculino", "1994-02-18", "La Florida", "Metropolitana de Santiago", "912000006", "USER", "ACTIVO", "futbol,running,ciclismo"),
    (7, "sofia.torres@loop.cl", "LoopDemo1", "Sofia", "Torres", "sofi_torres", "Femenino", "1996-09-30", "Puente Alto", "Metropolitana de Santiago", "912000007", "USER", "ACTIVO", "lectura,idiomas,debate"),
    (8, "francisco.silva@loop.cl", "LoopDemo1", "Francisco", "Silva", "pancho_silva", "Masculino", "1991-04-22", "Santiago", "Metropolitana de Santiago", "912000008", "USER", "ACTIVO", "ciclismo,senderismo,trekking"),
    (9, "javier.urrutia@loop.cl", "LoopDemo1", "Javier", "Urrutia", "javi_u", "Masculino", "1988-12-03", "Providencia", "Metropolitana de Santiago", "912000009", "MODERADOR", "ACTIVO", "networking,debate,emprendimiento"),
    (10, "paula.henriquez@loop.cl", "LoopDemo1", "Paula", "Henriquez", "paula_h", "Femenino", "1993-08-14", "Nunoa", "Metropolitana de Santiago", "912000010", "USER", "ACTIVO", "gastronomia,cocina,reposteria"),
    (11, "sebastian.lopez@loop.cl", "LoopDemo1", "Sebastian", "Lopez", "seba_lopez", "Masculino", "1990-05-30", "Las Condes", "Metropolitana de Santiago", "912000011", "USER", "ACTIVO", "videojuegos,gaming,trivia"),
    (12, "carolina.munoz@loop.cl", "LoopDemo1", "Carolina", "Munoz", "caro_munoz", "Femenino", "1997-01-19", "Maipu", "Metropolitana de Santiago", "912000012", "USER", "ACTIVO", "voluntariado,mascotas,jardineria"),
    (13, "andres.pizarro@loop.cl", "LoopDemo1", "Andres", "Pizarro", "andres_p", "Masculino", "1989-10-07", "La Florida", "Metropolitana de Santiago", "912000013", "USER", "SUSPENDIDO", "boxeo,karate,running"),
    (14, "fernanda.castro@loop.cl", "LoopDemo1", "Fernanda", "Castro", "fer_castro", "Femenino", "1995-06-11", "Puente Alto", "Metropolitana de Santiago", "912000014", "USER", "ACTIVO", "conciertos,festivales,cine"),
    (15, "nicolas.rivas@loop.cl", "LoopDemo1", "Nicolas", "Rivas", "nico_rivas", "Masculino", "1992-03-28", "Santiago", "Metropolitana de Santiago", "912000015", "USER", "ACTIVO", "astronomia,campismo,viajes"),
    (16, "isidora.gonzalez@loop.cl", "LoopDemo1", "Isidora", "Gonzalez", "isa_gonzalez", "Femenino", "1998-11-02", "Providencia", "Metropolitana de Santiago", "912000016", "USER", "ACTIVO", "ceramica,pintura,bisuteria"),
    (17, "rodrigo.saez@loop.cl", "LoopDemo1", "Rodrigo", "Saez", "rodrigo_s", "Masculino", "1987-07-16", "Nunoa", "Metropolitana de Santiago", "912000017", "USER", "ACTIVO", "enologia,cocteleria,gastronomia"),
    (18, "antonia.figueroa@loop.cl", "LoopDemo1", "Antonia", "Figueroa", "anto_f", "Femenino", "1994-09-09", "Las Condes", "Metropolitana de Santiago", "912000018", "USER", "ACTIVO", "yoga,pilates,meditacion"),
    (19, "tomas.araya@loop.cl", "LoopDemo1", "Tomas", "Araya", "tomas_a", "Masculino", "1996-02-25", "Valparaiso", "Valparaiso", "912000019", "USER", "ACTIVO", "fotografia,cine,museos"),
    (20, "catalina.vergara@loop.cl", "LoopDemo1", "Catalina", "Vergara", "cata_v", "Femenino", "1999-04-08", "Vina del Mar", "Valparaiso", "912000020", "USER", "ACTIVO", "running,atletismo,yoga"),
    (21, "benjamin.ojeda@loop.cl", "LoopDemo1", "Benjamin", "Ojeda", "benja_o", "Masculino", "1991-08-21", "Quilpue", "Valparaiso", "912000021", "USER", "ACTIVO", "surf,deporte,ciclismo"),
    (22, "martina.salinas@loop.cl", "LoopDemo1", "Martina", "Salinas", "marti_s", "Femenino", "1993-12-14", "San Antonio", "Valparaiso", "912000022", "USER", "ACTIVO", "gastronomia,picnic,cafeteria"),
    (23, "felipe.contreras@loop.cl", "LoopDemo1", "Felipe", "Contreras", "pipe_c", "Masculino", "1990-01-27", "Valparaiso", "Valparaiso", "912000023", "USER", "ACTIVO", "emprendimiento,networking,debate"),
    (24, "javiera.tapia@loop.cl", "LoopDemo1", "Javiera", "Tapia", "javi_t", "Femenino", "1997-05-05", "Vina del Mar", "Valparaiso", "912000024", "USER", "ACTIVO", "teatro,lectura,conciertos"),
    (25, "gonzalo.miranda@loop.cl", "LoopDemo1", "Gonzalo", "Miranda", "gonza_m", "Masculino", "1988-06-18", "Concepcion", "Biobio", "912000025", "USER", "ACTIVO", "videojuegos,gaming,networking"),
    (26, "barbara.hidalgo@loop.cl", "LoopDemo1", "Barbara", "Hidalgo", "barbi_h", "Femenino", "1995-10-31", "Talcahuano", "Biobio", "912000026", "USER", "ACTIVO", "yoga,meditacion,bienestar"),
    (27, "cristobal.nunez@loop.cl", "LoopDemo1", "Cristobal", "Nunez", "cris_n", "Masculino", "1992-07-07", "Chiguayante", "Biobio", "912000027", "USER", "ACTIVO", "futbol,basquetbol,voleibol"),
    (28, "daniela.paredes@loop.cl", "LoopDemo1", "Daniela", "Paredes", "dani_p", "Femenino", "1998-03-23", "Concepcion", "Biobio", "912000028", "USER", "ACTIVO", "fotografia,pintura,ceramica"),
    (29, "maximiliano.rojas@loop.cl", "LoopDemo1", "Maximiliano", "Rojas", "maxi_r", "Masculino", "1989-09-12", "Talcahuano", "Biobio", "912000029", "USER", "ACTIVO", "senderismo,trekking,campismo"),
    (30, "florencia.medina@loop.cl", "LoopDemo1", "Florencia", "Medina", "flor_m", "Femenino", "1994-11-29", "Concepcion", "Biobio", "912000030", "USER", "ACTIVO", "idiomas,lectura,debate"),
    (31, "ignacio.fuentes@loop.cl", "LoopDemo1", "Ignacio", "Fuentes", "nacho_f", "Masculino", "1991-02-16", "Temuco", "La Araucania", "912000031", "USER", "ACTIVO", "ciclismo,running,senderismo"),
    (32, "constanza.reyes@loop.cl", "LoopDemo1", "Constanza", "Reyes", "coni_r", "Femenino", "1996-08-04", "Villarrica", "La Araucania", "912000032", "USER", "ACTIVO", "voluntariado,gastronomia,cocina"),
    (33, "patricio.soto@loop.cl", "LoopDemo1", "Patricio", "Soto", "pato_s", "Masculino", "1987-04-11", "Padre Las Casas", "La Araucania", "912000033", "USER", "ACTIVO", "emprendimiento,networking,debate"),
    (34, "macarena.garrido@loop.cl", "LoopDemo1", "Macarena", "Garrido", "maca_g", "Femenino", "1999-01-08", "Temuco", "La Araucania", "912000034", "USER", "ACTIVO", "yoga,meditacion,running"),
    (35, "alejandro.carrasco@loop.cl", "LoopDemo1", "Alejandro", "Carrasco", "alex_c", "Masculino", "1993-06-26", "Angol", "La Araucania", "912000035", "USER", "SUSPENDIDO", "futbol,running,atletismo"),
    (36, "renata.espinoza@loop.cl", "LoopDemo1", "Renata", "Espinoza", "renata_e", "Femenino", "1997-12-19", "Talca", "Maule", "912000036", "USER", "ACTIVO", "lectura,cafeteria,gastronomia"),
    (37, "vicente.poblete@loop.cl", "LoopDemo1", "Vicente", "Poblete", "vicente_p", "Masculino", "1990-05-03", "Curico", "Maule", "912000037", "USER", "ACTIVO", "enologia,gastronomia,networking"),
    (38, "amanda.jara@loop.cl", "LoopDemo1", "Amanda", "Jara", "amanda_j", "Femenino", "1995-09-17", "Linares", "Maule", "912000038", "USER", "ACTIVO", "mascotas,voluntariado,jardineria"),
    (39, "emilio.valdes@loop.cl", "LoopDemo1", "Emilio", "Valdes", "emilio_v", "Masculino", "1992-11-30", "Talca", "Maule", "912000039", "USER", "ACTIVO", "ciclismo,running,atletismo"),
    (40, "trinidad.osorio@loop.cl", "LoopDemo1", "Trinidad", "Osorio", "tri_osorio", "Femenino", "1998-07-22", "La Serena", "Coquimbo", "912000040", "USER", "ACTIVO", "astronomia,fotografia,viajes"),
    (41, "marcelo.aguilera@loop.cl", "LoopDemo1", "Marcelo", "Aguilera", "marcelo_a", "Masculino", "1988-03-09", "Coquimbo", "Coquimbo", "912000041", "USER", "ACTIVO", "senderismo,trekking,campismo"),
    (42, "paz.montecinos@loop.cl", "LoopDemo1", "Paz", "Montecinos", "paz_m", "Femenino", "1994-10-15", "Ovalle", "Coquimbo", "912000042", "USER", "ACTIVO", "yoga,meditacion,picnic"),
    (43, "hernan.bravo@loop.cl", "LoopDemo1", "Hernan", "Bravo", "hernan_b", "Masculino", "1991-01-28", "La Serena", "Coquimbo", "912000043", "USER", "ACTIVO", "surf,running,ciclismo"),
    (44, "gabriela.quintana@loop.cl", "LoopDemo1", "Gabriela", "Quintana", "gabi_q", "Femenino", "1996-04-02", "Rancagua", "O Higgins", "912000044", "USER", "ACTIVO", "emprendimiento,networking,cocina"),
    (45, "lucas.sandoval@loop.cl", "LoopDemo1", "Lucas", "Sandoval", "lucas_s", "Masculino", "1989-08-19", "San Fernando", "O Higgins", "912000045", "USER", "ACTIVO", "futbol,running,atletismo"),
    (46, "dominique.alarcon@loop.cl", "LoopDemo1", "Dominique", "Alarcon", "domi_a", "Femenino", "1997-06-06", "Rancagua", "O Higgins", "912000046", "USER", "ACTIVO", "teatro,cine,conciertos"),
    (47, "esteban.cifuentes@loop.cl", "LoopDemo1", "Esteban", "Cifuentes", "esteban_c", "Masculino", "1993-02-13", "Puerto Montt", "Los Lagos", "912000047", "USER", "ACTIVO", "kayak,senderismo,campismo"),
    (48, "carla.venegas@loop.cl", "LoopDemo1", "Carla", "Venegas", "carla_v", "Femenino", "1999-05-27", "Puerto Varas", "Los Lagos", "912000048", "USER", "ACTIVO", "fotografia,viajes,gastronomia"),
    (49, "ricardo.palma@loop.cl", "LoopDemo1", "Ricardo", "Palma", "richi_p", "Masculino", "1990-12-01", "Chillan", "Nuble", "912000049", "USER", "ACTIVO", "gaming,trivia,karaoke"),
    (50, "elisa.zamora@loop.cl", "LoopDemo1", "Elisa", "Zamora", "elisa_z", "Femenino", "1995-03-18", "Valdivia", "Los Rios", "912000050", "USER", "ACTIVO", "kayak,lectura,gastronomia"),
]

# Fix invalid interest slugs - use only catalog slugs
INTEREST_FIX = {"pilates": "yoga", "surf": "running", "deporte": "atletismo", "kayak": "senderismo", "bienestar": "meditacion"}

INTEREST_PAD_SLUGS = [
    "running", "networking", "gastronomia", "yoga", "fotografia",
    "ciclismo", "lectura", "emprendimiento", "conciertos", "senderismo",
]

COMMUNITIES = [
    ("Santiago Run Club", "Comunidad de corredores urbanos en la capital. Salidas semanales por parques y costaneras.", "PUBLICA", "ACTIVA", "francisco.silva@loop.cl", "running,atletismo"),
    ("Emprendedores Providencia", "Red de founders y profesionales tech en el sector oriente.", "PUBLICA", "ACTIVA", "diego.henriquez@loop.cl", "emprendimiento,networking"),
    ("Yoga Costanera", "Practicas de yoga y mindfulness al aire libre en Santiago.", "PUBLICA", "ACTIVA", "camila.rosas@loop.cl", "yoga,meditacion"),
    ("Fotografia Urbana RM", "Salidas fotograficas por barrios patrimoniales y arte callejero.", "PUBLICA", "ACTIVA", "valentina.morales@loop.cl", "fotografia,cine"),
    ("Gamers Metropolitana", "Torneos amistosos, LAN parties y gaming social.", "PUBLICA", "ACTIVA", "sebastian.lopez@loop.cl", "gaming,videojuegos,trivia"),
    ("Cocina de Barrio", "Intercambio de recetas, cenas compartidas y talleres caseros.", "PUBLICA", "ACTIVA", "paula.henriquez@loop.cl", "cocina,gastronomia,reposteria"),
    ("Ciclistas Cordillera", "Rutas en bici por Santiago y cerros urbanos.", "PUBLICA", "ACTIVA", "francisco.silva@loop.cl", "ciclismo,senderismo"),
    ("Lectores de Nunoa", "Club de lectura con encuentros mensuales en cafes locales.", "PUBLICA", "ACTIVA", "sofia.torres@loop.cl", "lectura,debate"),
    ("Voluntariado Capital", "Proyectos sociales y actividades de impacto comunitario.", "PUBLICA", "ACTIVA", "carolina.munoz@loop.cl", "voluntariado,mascotas"),
    ("After Office Las Condes", "Networking profesional post jornada laboral.", "PUBLICA", "ACTIVA", "javier.urrutia@loop.cl", "networking,emprendimiento"),
    ("Senderismo RM Sur", "Trekking de fin de semana en reservas cercanas a Santiago.", "PUBLICA", "ACTIVA", "matias.vega@loop.cl", "senderismo,trekking,campismo"),
    ("Arte y Ceramica", "Talleres creativos de pintura, ceramica y manualidades.", "PUBLICA", "ACTIVA", "isidora.gonzalez@loop.cl", "ceramica,pintura,bisuteria"),
    ("Futbol Cinco La Florida", "Partidos recreativos de futbol sala los jueves.", "PUBLICA", "ACTIVA", "matias.vega@loop.cl", "futbol,basquetbol"),
    ("Conciertos y Festivales", "Organizacion de salidas grupales a shows en vivo.", "PUBLICA", "ACTIVA", "fernanda.castro@loop.cl", "conciertos,festivales,cine"),
    ("Astronomos Urbanos", "Observacion nocturna y charlas de divulgacion cientifica.", "PUBLICA", "ACTIVA", "nicolas.rivas@loop.cl", "astronomia,campismo"),
    ("Club Privado Creativos", "Comunidad privada de diseno y fotografia avanzada.", "PRIVADA", "ACTIVA", "valentina.morales@loop.cl", "fotografia,pintura"),
    ("Viña Fotografia Costera", "Fotografia de paisaje y street photo en el litoral central.", "PUBLICA", "ACTIVA", "tomas.araya@loop.cl", "fotografia,cine"),
    ("Runners Viña-Reñaca", "Entrenamientos matutinos frente al mar.", "PUBLICA", "ACTIVA", "catalina.vergara@loop.cl", "running,atletismo,yoga"),
    ("Emprendedores Valpo", "Ecosistema emprendedor porteño con pitch nights.", "PUBLICA", "ACTIVA", "felipe.contreras@loop.cl", "emprendimiento,networking,debate"),
    ("Gastronomia San Antonio", "Rutas de mariscos y cocina costera.", "PUBLICA", "ACTIVA", "martina.salinas@loop.cl", "gastronomia,picnic,cafeteria"),
    ("Teatro y Cultura Valpo", "Grupo de teatro comunitario y visitas culturales.", "PUBLICA", "ACTIVA", "javiera.tapia@loop.cl", "teatro,lectura,museos"),
    ("Bio Bio Tech", "Comunidad tech del Gran Concepcion.", "PUBLICA", "ACTIVA", "gonzalo.miranda@loop.cl", "emprendimiento,gaming,networking"),
    ("Yoga Talcahuano", "Clases grupales de yoga y respiracion consciente.", "PUBLICA", "ACTIVA", "barbara.hidalgo@loop.cl", "yoga,meditacion"),
    ("Deportes Bio Bio", "Encuentros de futbol, basquetbol y voleibol recreativo.", "PUBLICA", "ACTIVA", "cristobal.nunez@loop.cl", "futbol,basquetbol,voleibol"),
    ("Arte Conce", "Colectivo de artistas visuales penquistas.", "PUBLICA", "ACTIVA", "daniela.paredes@loop.cl", "fotografia,pintura,ceramica"),
    ("Trekking Arauco", "Caminatas por senderos del sur de Biobio.", "PUBLICA", "ACTIVA", "maximiliano.rojas@loop.cl", "senderismo,trekking,campismo"),
    ("Idiomas Conce", "Intercambio de idiomas en cafes y bibliotecas.", "PUBLICA", "ACTIVA", "florencia.medina@loop.cl", "idiomas,lectura,debate"),
    ("Temuco Trail Runners", "Running de trail en la Araucania.", "PUBLICA", "ACTIVA", "ignacio.fuentes@loop.cl", "running,senderismo,ciclismo"),
    ("Cocina Mapuche Sur", "Gastronomia tradicional y cocina regional.", "PUBLICA", "ACTIVA", "constanza.reyes@loop.cl", "gastronomia,cocina,voluntariado"),
    ("Emprendedores Temuco", "Red de negocios locales en la novena region.", "PUBLICA", "ACTIVA", "patricio.soto@loop.cl", "emprendimiento,networking"),
    ("Bienestar Villarrica", "Yoga, meditacion y vida sana junto al lago.", "PUBLICA", "ACTIVA", "macarena.garrido@loop.cl", "yoga,meditacion,running"),
    ("Club Privado Araucania", "Grupo cerrado de excursiones de montaña.", "PRIVADA", "ACTIVA", "ignacio.fuentes@loop.cl", "senderismo,campismo,trekking"),
    ("Cafe y Libros Talca", "Encuentros literarios en el Maule.", "PUBLICA", "ACTIVA", "renata.espinoza@loop.cl", "lectura,cafeteria,gastronomia"),
    ("Vinos del Maule", "Catas y enoturismo en valles cercanos.", "PUBLICA", "ACTIVA", "vicente.poblete@loop.cl", "enologia,gastronomia,networking"),
    ("Mascotas Linares", "Paseos caninos y adopciones responsables.", "PUBLICA", "ACTIVA", "amanda.jara@loop.cl", "mascotas,voluntariado,jardineria"),
    ("Ciclistas Talca", "Rodadas urbanas y rurales en el Maule.", "PUBLICA", "ACTIVA", "emilio.valdes@loop.cl", "ciclismo,running,atletismo"),
    ("Astro La Serena", "Observacion astronomica en el norte chico.", "PUBLICA", "ACTIVA", "trinidad.osorio@loop.cl", "astronomia,fotografia,viajes"),
    ("Trekking Coquimbo", "Senderismo costero y rutas del Elqui.", "PUBLICA", "ACTIVA", "marcelo.aguilera@loop.cl", "senderismo,trekking,campismo"),
    ("Yoga Ovalle", "Practicas al aire libre en valles verdes.", "PUBLICA", "ACTIVA", "paz.montecinos@loop.cl", "yoga,meditacion,picnic"),
    ("Running La Serena", "Grupo de atletismo en la Avenida del Mar.", "PUBLICA", "ACTIVA", "hernan.bravo@loop.cl", "running,atletismo,ciclismo"),
    ("Emprendedores Rancagua", "Networking y mentorias para pymes locales.", "PUBLICA", "ACTIVA", "gabriela.quintana@loop.cl", "emprendimiento,networking,cocina"),
    ("Futbol O Higgins", "Campeonato relampago los fines de semana.", "PUBLICA", "ACTIVA", "lucas.sandoval@loop.cl", "futbol,running"),
    ("Cultura Rancagua", "Cine club y teatro comunitario.", "PUBLICA", "ACTIVA", "dominique.alarcon@loop.cl", "teatro,cine,conciertos"),
    ("Patagonia Outdoor", "Excursiones y campismo en Los Lagos.", "PUBLICA", "ACTIVA", "esteban.cifuentes@loop.cl", "senderismo,campismo,trekking"),
    ("Fotografia Lago Llanquihue", "Salidas fotograficas en Puerto Varas y alrededores.", "PUBLICA", "ACTIVA", "carla.venegas@loop.cl", "fotografia,viajes,gastronomia"),
    ("Gaming Chillan", "Comunidad gamer del valle itata.", "PUBLICA", "ACTIVA", "ricardo.palma@loop.cl", "gaming,trivia,karaoke"),
    ("Valdivia Fluvial", "Kayak, gastronomia y cultura fluvial.", "PUBLICA", "ACTIVA", "elisa.zamora@loop.cl", "gastronomia,lectura,viajes"),
    ("Comunidad Pendiente Demo", "Solicitud en revision para activacion.", "PUBLICA", "PENDIENTE", "user@loop.cl", "networking,emprendimiento"),
    ("Colectivo Bloqueado", "Comunidad suspendida por revision administrativa.", "PUBLICA", "BLOQUEADA", "admin@loop.cl", "debate,networking"),
    ("Enologia Las Condes", "Catas privadas y maridajes para aficionados.", "PRIVADA", "ACTIVA", "rodrigo.saez@loop.cl", "enologia,cocteleria,gastronomia"),
]

EVENTS = [
    ("Meetup founders", "Pitch night de emprendedores", "Providencia", "Metropolitana de Santiago", "Av. Providencia 2653", "WeWork Providencia", -33.4178, -70.6062, 5, 40, False, "Emprendedores Providencia", "diego.henriquez@loop.cl"),
    ("Yoga al amanecer", "Clase abierta de yoga", "Providencia", "Metropolitana de Santiago", "Av. Providencia 1500", "Parque Bustamante", -33.4410, -70.6320, 3, 25, False, "Yoga Costanera", "camila.rosas@loop.cl"),
    ("Salida fotografica", "Street photo en barrio Italia", "Providencia", "Metropolitana de Santiago", "Av. Italia 1200", "Barrio Italia", -33.4505, -70.6120, 8, 20, False, "Fotografia Urbana RM", "valentina.morales@loop.cl"),
    ("Torneo FIFA", "Gaming night relampago", "Las Condes", "Metropolitana de Santiago", "Av. Apoquindo 5950", "Local esports Las Condes", -33.4010, -70.5780, 6, 16, False, "Gamers Metropolitana", "sebastian.lopez@loop.cl"),
    ("Cena compartida", "Intercambio de recetas", "Nunoa", "Metropolitana de Santiago", "Av. Irarrazaval 2400", "Centro civico Nunoa", -33.4560, -70.5980, 10, 18, False, "Cocina de Barrio", "paula.henriquez@loop.cl"),
    ("Rodada urbana", "Ciclismo recreativo 25 km", "Santiago", "Metropolitana de Santiago", "Plaza de Armas", "Plaza de Armas de Santiago", -33.4372, -70.6506, 4, 30, False, "Ciclistas Cordillera", "francisco.silva@loop.cl"),
    ("Club de lectura", "Debate libro del mes", "Nunoa", "Metropolitana de Santiago", "Av. Grecia 2001", "Cafe literario Nunoa", -33.4680, -70.6100, 12, 15, False, "Lectores de Nunoa", "sofia.torres@loop.cl"),
    ("Voluntariado parque", "Limpieza comunitaria", "Maipu", "Metropolitana de Santiago", "Av. Pajaritos 4455", "Parque O Higgins Maipu", -33.5100, -70.7580, 7, 35, False, "Voluntariado Capital", "carolina.munoz@loop.cl"),
    ("After office", "Networking ejecutivos", "Las Condes", "Metropolitana de Santiago", "Av. Isidora Goyenechea 3000", "Barrio financiero", -33.4050, -70.5720, 9, 50, False, "After Office Las Condes", "javier.urrutia@loop.cl"),
    ("Trekking Arrayan", "Senderismo moderado", "La Florida", "Metropolitana de Santiago", "Camino al Volcan 14000", "Entrada sendero La Florida", -33.5450, -70.5800, 14, 22, False, "Senderismo RM Sur", "matias.vega@loop.cl"),
    ("Taller ceramica", "Manos a la arcilla", "Providencia", "Metropolitana de Santiago", "Av. Bilbao 1200", "Taller artesanal Bilbao", -33.4280, -70.6180, 11, 12, True, "Arte y Ceramica", "isidora.gonzalez@loop.cl"),
    ("Futbol jueves", "Partido recreativo", "La Florida", "Metropolitana de Santiago", "Av. Vicuña Mackenna 7110", "Cancha La Florida", -33.5200, -70.5950, 2, 22, False, "Futbol Cinco La Florida", "matias.vega@loop.cl"),
    ("Concierto indie", "Salida grupal al venue", "Santiago", "Metropolitana de Santiago", "Ernesto Pinto Lagarrigue 364", "Barrio Bellavista", -33.4330, -70.6350, 15, 40, False, "Conciertos y Festivales", "fernanda.castro@loop.cl"),
    ("Observacion lunar", "Noche astronomica", "Puente Alto", "Metropolitana de Santiago", "Camino El Observatorio 1500", "Mirador Puente Alto", -33.6100, -70.5750, 18, 30, False, "Astronomos Urbanos", "nicolas.rivas@loop.cl"),
    ("Sesion privada foto", "Workshop avanzado", "Las Condes", "Metropolitana de Santiago", "Av. Las Condes 11223", "Estudio privado", -33.3980, -70.5650, 20, 8, True, "Club Privado Creativos", "valentina.morales@loop.cl"),
    ("Foto costera", "Amanecer en Reñaca", "Vina del Mar", "Valparaiso", "Av. Borgono 14400", "Playa Reñaca", -33.0240, -71.5510, 5, 25, False, "Viña Fotografia Costera", "tomas.araya@loop.cl"),
    ("Running costanera", "Entrenamiento 10K", "Vina del Mar", "Valparaiso", "Av. San Martin 100", "Costanera Viña", -33.0150, -71.5450, 4, 35, False, "Runners Viña-Reñaca", "catalina.vergara@loop.cl"),
    ("Pitch Valpo", "Demo day emprendedores", "Valparaiso", "Valparaiso", "Av. Pedro Montt 1600", "Centro Valparaiso", -33.0450, -71.6200, 13, 45, False, "Emprendedores Valpo", "felipe.contreras@loop.cl"),
    ("Ruta mariscos", "Tour gastronomico", "San Antonio", "Valparaiso", "Av. Barros Luco 1050", "Caleta San Antonio", -33.5950, -71.6070, 16, 20, False, "Gastronomia San Antonio", "martina.salinas@loop.cl"),
    ("Obra de teatro", "Funcion comunitaria", "Valparaiso", "Valparaiso", "Plaza Sotomayor", "Plaza Sotomayor Valparaiso", -33.0380, -71.6290, 21, 60, False, "Teatro y Cultura Valpo", "javiera.tapia@loop.cl"),
    ("Hackathon Bio Bio", "Maraton de desarrollo", "Concepcion", "Biobio", "Edmundo Larenas 64", "Campus UdeC", -36.8280, -73.0320, 6, 80, False, "Bio Bio Tech", "gonzalo.miranda@loop.cl"),
    ("Yoga penquino", "Clase al aire libre", "Talcahuano", "Biobio", "Av. Colon 8010", "Playa Talcahuano", -36.7240, -73.1160, 3, 20, False, "Yoga Talcahuano", "barbara.hidalgo@loop.cl"),
    ("Torneo voleibol", "Copa recreativa", "Chiguayante", "Biobio", "Av. Pdte. Ibanez 560", "Gimnasio Chiguayante", -36.9250, -73.0300, 8, 24, False, "Deportes Bio Bio", "cristobal.nunez@loop.cl"),
    ("Expo arte local", "Muestra colectiva", "Concepcion", "Biobio", "O'Higgins 715", "Galeria centro Conce", -36.8267, -73.0500, 11, 100, False, "Arte Conce", "daniela.paredes@loop.cl"),
    ("Trek Laguna", "Caminata de dia completo", "Concepcion", "Biobio", "Camino a Laguna 1200", "Inicio sendero", -36.8500, -73.0800, 19, 18, True, "Trekking Arauco", "maximiliano.rojas@loop.cl"),
    ("Intercambio ingles", "Practica conversacional", "Concepcion", "Biobio", "Barros Arana 1234", "Cafe centro Conce", -36.8270, -73.0510, 7, 12, False, "Idiomas Conce", "florencia.medina@loop.cl"),
    ("Trail Temuco", "Carrera de trail 12K", "Temuco", "La Araucania", "Av. Alemania 731", "Parque Alemania", -38.7350, -72.5870, 9, 40, False, "Temuco Trail Runners", "ignacio.fuentes@loop.cl"),
    ("Comida tradicional", "Taller cocina mapuche", "Temuco", "La Araucania", "Av. Caupolican 450", "Centro cultural Temuco", -38.7390, -72.5920, 14, 16, False, "Cocina Mapuche Sur", "constanza.reyes@loop.cl"),
    ("Mentorias pymes", "Sesion emprendedores", "Temuco", "La Araucania", "Calle Portales 450", "Cowork Temuco", -38.7370, -72.5890, 10, 25, False, "Emprendedores Temuco", "patricio.soto@loop.cl"),
    ("Yoga lago", "Practica junto al lago", "Villarrica", "La Araucania", "Av. Pedro de Valdivia 500", "Orilla Lago Villarrica", -39.2790, -72.2270, 5, 20, False, "Bienestar Villarrica", "macarena.garrido@loop.cl"),
    ("Expedicion privada", "Ascenso reservado", "Padre Las Casas", "La Araucania", "Camino Volcan 800", "Base sendero", -38.7800, -72.6100, 22, 10, True, "Club Privado Araucania", "ignacio.fuentes@loop.cl"),
    ("Debate literario", "Charla libro del mes", "Talca", "Maule", "1 Norte 800", "Biblioteca regional Talca", -35.4260, -71.6550, 6, 18, False, "Cafe y Libros Talca", "renata.espinoza@loop.cl"),
    ("Cata vinos", "Degustacion Valle Curico", "Curico", "Maule", "Camino San Jorge 100", "Vina demo Curico", -34.9800, -71.2300, 12, 15, True, "Vinos del Maule", "vicente.poblete@loop.cl"),
    ("Adopcion canina", "Jornada mascotas", "Linares", "Maule", "Av. Independencia 500", "Plaza Linares", -35.8460, -71.5930, 8, 30, False, "Mascotas Linares", "amanda.jara@loop.cl"),
    ("Rodada Talca", "Ciclismo 30 km", "Talca", "Maule", "Av. San Miguel 3600", "Parque Talca", -35.4300, -71.6400, 4, 28, False, "Ciclistas Talca", "emilio.valdes@loop.cl"),
    ("Observacion estrellas", "Noche en el faro", "La Serena", "Coquimbo", "Av. del Mar 1000", "Faro Monumental", -29.9020, -71.2520, 17, 35, False, "Astro La Serena", "trinidad.osorio@loop.cl"),
    ("Trek costero", "Caminata Guanaqueros", "Coquimbo", "Coquimbo", "Av. Costanera 500", "Playa Coquimbo", -29.9530, -71.3390, 13, 22, False, "Trekking Coquimbo", "marcelo.aguilera@loop.cl"),
    ("Picnic yoga", "Practica al aire libre", "Ovalle", "Coquimbo", "Av. Benavente 800", "Parque Ovalle", -30.6010, -71.1990, 7, 18, False, "Yoga Ovalle", "paz.montecinos@loop.cl"),
    ("Media maraton prep", "Entrenamiento grupal", "La Serena", "Coquimbo", "Av. del Mar 2500", "Costanera La Serena", -29.9100, -71.2600, 3, 40, False, "Running La Serena", "hernan.bravo@loop.cl"),
    ("Feria emprendedores", "Expo negocios locales", "Rancagua", "O Higgins", "Av. O'Higgins 600", "Plaza Rancagua", -34.1700, -70.7400, 9, 55, False, "Emprendedores Rancagua", "gabriela.quintana@loop.cl"),
    ("Copa futbol", "Torneo relampago", "San Fernando", "O Higgins", "Av. Bernardo O'Higgins 700", "Estadio San Fernando", -34.5850, -70.9880, 2, 22, False, "Futbol O Higgins", "lucas.sandoval@loop.cl"),
    ("Cine foro", "Proyeccion y debate", "Rancagua", "O Higgins", "Av. Estado 450", "Centro cultural Rancagua", -34.1750, -70.7350, 15, 45, False, "Cultura Rancagua", "dominique.alarcon@loop.cl"),
    ("Camping Llanquihue", "Salida de campismo", "Puerto Montt", "Los Lagos", "Av. Angelm 2500", "Costanera Puerto Montt", -41.4720, -72.9360, 20, 16, True, "Patagonia Outdoor", "esteban.cifuentes@loop.cl"),
    ("Foto volcan", "Salida amanecer", "Puerto Varas", "Los Lagos", "Del Salvador 450", "Mirador Puerto Varas", -41.3200, -72.9850, 11, 14, False, "Fotografia Lago Llanquihue", "carla.venegas@loop.cl"),
    ("LAN party", "Torneo multijugador", "Chillan", "Nuble", "Av. O'Higgins 450", "Centro Chillan", -36.6060, -72.1030, 6, 32, False, "Gaming Chillan", "ricardo.palma@loop.cl"),
    ("Tour fluvial", "Paseo en el rio", "Valdivia", "Los Rios", "Av. Arturo Prat 550", "Feria Fluvial Valdivia", -39.8140, -73.2450, 8, 25, False, "Valdivia Fluvial", "elisa.zamora@loop.cl"),
    ("Karaoke night", "Noche de canto grupal", "Santiago", "Metropolitana de Santiago", "Monjitas 550", "Barrio Lastarria", -33.4390, -70.6420, 5, 30, False, "Santiago Run Club", "ricardo.palma@loop.cl"),
    ("Cata privada", "Maridaje exclusivo", "Las Condes", "Metropolitana de Santiago", "Av. Apoquindo 3000", "Lounge Las Condes", -33.4100, -70.5850, 16, 10, True, "Enologia Las Condes", "rodrigo.saez@loop.cl"),
    ("Evento cancelado demo", "Ejemplo estado cancelado", "Santiago", "Metropolitana de Santiago", "Alameda 100", "Plaza demo", -33.4400, -70.6500, -5, 20, False, "Santiago Run Club", "admin@loop.cl"),
    ("Maraton historica", "Evento ya realizado", "Providencia", "Metropolitana de Santiago", "Av. Providencia 1000", "Parque demo", -33.4350, -70.6250, -20, 100, False, "Santiago Run Club", "francisco.silva@loop.cl"),
]

POST_TITLES = [
    "Hola LOOP", "Reflexion de la semana", "Fotos del encuentro", "Proximo evento",
    "Busco companeros", "Gracias comunidad", "Resumen del taller", "Recomendacion local",
    "Anuncio importante", "Pregunta rapida", "Nuevo en la app", "Despues del evento",
    "Tips para principiantes", "Invitacion abierta", "Logro personal",
]

POST_BODIES = [
    "Feliz de sumarme a esta comunidad. Cualquier duda me escriben por aca.",
    "Esta semana aprendi mucho en el ultimo meetup. Gracias a quienes fueron.",
    "Subire fotos pronto del evento de ayer. Estuvo increible la energia del grupo.",
    "Ya tenemos fecha confirmada para el proximo encuentro. Reserven cupo.",
    "Alguien se anima a acompanarme este fin de semana? Cupos limitados.",
    "Queria agradecer a la comunidad por el apoyo en mi primer evento.",
    "Comparto un resumen de lo que vimos en el taller de ayer.",
    "Recomiendo este cafe/barrio para quienes buscan un lugar tranquilo post evento.",
    "Ojo: cambiamos la hora de salida por clima. Aviso por aca.",
    "Duda: hay estacionamiento cerca del punto de encuentro?",
    "Recien llego a LOOP. Que comunidades recomiendan para empezar?",
    "Volviendo del evento con ganas de repetir. Gran organizacion.",
    "Si recien empiezan, vayan sin miedo. El ambiente es muy acogedor.",
    "Invitacion abierta al proximo encuentro. Traigan agua y buena onda.",
    "Cumpli mi meta del mes gracias a este grupo. Arriba!",
]


def uuid_for(seq: int) -> str:
    if seq == 1:
        return "11111111-1111-1111-1111-111111111111"
    if seq == 2:
        return "22222222-2222-2222-2222-222222222222"
    return f"33333333-3333-3333-3333-{seq:012d}"


def sql_str(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def comuna_expr(comuna: str, region: str) -> str:
    return f"""(
    SELECT c.id_comuna FROM public.comuna c
    INNER JOIN public.region r ON r.id_region = c.region_id_region
    WHERE c.nombre = {sql_str(comuna)} AND r.nombre = {sql_str(region)}
    LIMIT 1
  )"""


def user_id_expr(email: str) -> str:
    return f"(SELECT id_usuario FROM public.usuario WHERE email = {sql_str(email)} LIMIT 1)"


def auth_id_expr(email: str) -> str:
    return f"(SELECT auth_user_id FROM public.usuario WHERE email = {sql_str(email)} LIMIT 1)"


def community_id_expr(name: str) -> str:
    return f"(SELECT id_comunidad FROM public.comunidades WHERE nombre = {sql_str(name)} LIMIT 1)"


def slug_list(raw: str, min_count: int = 5) -> list[str]:
    slugs = []
    for part in raw.split(","):
        slug = INTEREST_FIX.get(part.strip(), part.strip())
        if slug and slug not in slugs:
            slugs.append(slug)
    pad = 0
    while len(slugs) < min_count:
        candidate = INTEREST_PAD_SLUGS[pad % len(INTEREST_PAD_SLUGS)]
        if candidate not in slugs:
            slugs.append(candidate)
        pad += 1
    return slugs


def build() -> str:
    emails = [u[1] for u in USERS]
    uuids = [uuid_for(u[0]) for u in USERS]

    lines: list[str] = []
    append = lines.append

    append("-- LOOP — Datos demo extendidos (50 usuarios, 50 comunidades, 50 eventos, 100 publicaciones)")
    append("-- Ejecutar DESPUES de loop_seed_catalogo.sql via scripts/seed-demo.ps1")
    append("-- Re-ejecutable. Fotos: cargar luego a Storage (avatar_url, banner_url, cover_url, url_media NULL).")
    append("")
    append("CREATE EXTENSION IF NOT EXISTS pgcrypto;")
    append("")

    # Vaciar datos de app y reiniciar secuencias (id_usuario, id_comunidad, etc. desde 1)
    append("TRUNCATE TABLE")
    append("  public.notificacion,")
    append("  public.reacciones_post,")
    append("  public.comentario,")
    append("  public.publicaciones,")
    append("  public.participantes_evento,")
    append("  public.evento,")
    append("  public.comunidad_intereses,")
    append("  public.miembro_comunidad,")
    append("  public.comunidades,")
    append("  public.seguidores,")
    append("  public.usuario_intereses,")
    append("  public.roles_sistema,")
    append("  public.reporte_publicacion,")
    append("  public.reporte_evento,")
    append("  public.usuario")
    append("RESTART IDENTITY CASCADE;")
    append("")

    # Auth demo: limpiar cuentas anteriores antes de reinsertar
    append("DO $$")
    append("DECLARE")
    append("  v_emails text[] := ARRAY[")
    for i, email in enumerate(emails):
        suffix = "," if i < len(emails) - 1 else ""
        append(f"    {sql_str(email)}{suffix}")
    append("  ];")
    append("  v_uuids uuid[] := ARRAY[")
    for i, uid in enumerate(uuids):
        suffix = "," if i < len(uuids) - 1 else ""
        append(f"    {sql_str(uid)}::uuid{suffix}")
    append("  ];")
    append("BEGIN")
    append("  DELETE FROM auth.identities WHERE user_id IN (")
    append("    SELECT id FROM auth.users WHERE email = ANY(v_emails));")
    append("  DELETE FROM auth.users WHERE email = ANY(v_emails);")
    append("  DELETE FROM auth.identities WHERE user_id = ANY(v_uuids);")
    append("  DELETE FROM auth.users WHERE id = ANY(v_uuids);")
    append("END $$;")
    append("")

    # Auth users
    append("DO $$")
    append("BEGIN")
    append("  CREATE TEMP TABLE _seed_auth (")
    append("    auth_id uuid, email text, password text, meta_nombre text")
    append("  ) ON COMMIT DROP;")
    append("  INSERT INTO _seed_auth (auth_id, email, password, meta_nombre) VALUES")
    auth_rows = []
    for u in USERS:
        seq, email, pwd, nom, ape, *_ = u
        auth_rows.append(
            f"    ({sql_str(uuid_for(seq))}::uuid, {sql_str(email)}, {sql_str(pwd)}, {sql_str(f'{nom} {ape}')})"
        )
    append(",\n".join(auth_rows) + ";")
    append("")
    append("  INSERT INTO auth.users (")
    append("    id, instance_id, aud, role, email, encrypted_password,")
    append("    email_confirmed_at, invited_at, confirmation_token,")
    append("    recovery_token, email_change_token_new, email_change,")
    append("    created_at, updated_at, raw_app_meta_data, raw_user_meta_data,")
    append("    is_super_admin, phone, phone_confirmed_at")
    append("  )")
    append("  SELECT auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',")
    append("    email, crypt(password, gen_salt('bf')), now(), now(), '', '', '', '',")
    append("    now(), now(), '{\"provider\":\"email\",\"providers\":[\"email\"]}'::jsonb,")
    append("    jsonb_build_object('nombre', meta_nombre), false, null, null")
    append("  FROM _seed_auth;")
    append("")
    append("  INSERT INTO auth.identities (")
    append("    id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at")
    append("  )")
    append("  SELECT auth_id, auth_id, auth_id::text,")
    append("    jsonb_build_object('sub', auth_id::text, 'email', email),")
    append("    'email', now(), now(), now()")
    append("  FROM _seed_auth;")
    append("END $$;")
    append("")

    # public.usuario
    append("INSERT INTO public.usuario (")
    append("  auth_user_id, email, username, nombres, apellidos, fecha_nacimiento, genero,")
    append("  comuna_id_comuna, rol_user, estado_cuenta, telefono, nacionalidad")
    append(") VALUES")
    user_rows = []
    for u in USERS:
        seq, email, _, nom, ape, username, genero, birth, comuna, region, tel, rol, estado, _ = u
        user_rows.append(
            f"  ({sql_str(uuid_for(seq))}::uuid, {sql_str(email)}, {sql_str(username)}, "
            f"{sql_str(nom)}, {sql_str(ape)}, {sql_str(birth)}, {sql_str(genero)}, "
            f"{comuna_expr(comuna, region)}, {sql_str(rol)}, {sql_str(estado)}, "
            f"{sql_str('+' + tel if not tel.startswith('+') else tel)}, 'Chileno')"
        )
    append(",\n".join(user_rows) + ";")
    append("")

    append("INSERT INTO public.roles_sistema (nombre_rol, usuario_id_usuario)")
    append(f"VALUES ('ADMIN', {user_id_expr('admin@loop.cl')})")
    append("ON CONFLICT (usuario_id_usuario, nombre_rol) DO NOTHING;")
    append("")

    # usuario_intereses
    append("INSERT INTO public.usuario_intereses (auth_user_id, id_interes)")
    interest_rows = []
    for u in USERS:
        email = u[1]
        for slug in slug_list(u[13]):
            interest_rows.append(
                f"SELECT {auth_id_expr(email)}, id_interes FROM public.intereses WHERE slug = {sql_str(slug)}"
            )
    append("\nUNION ALL\n".join(interest_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    # comunidades
    append("INSERT INTO public.comunidades (nombre, descripcion, privacidad, estado, usuario_id_usuario) VALUES")
    comm_rows = []
    for name, desc, priv, estado, creator, _ in COMMUNITIES:
        comm_rows.append(
            f"  ({sql_str(name)}, {sql_str(desc)}, {sql_str(priv)}, {sql_str(estado)}, {user_id_expr(creator)})"
        )
    append(",\n".join(comm_rows) + ";")
    append("")

    # comunidad_intereses
    append("INSERT INTO public.comunidad_intereses (id_comunidad, id_interes)")
    ci_rows = []
    for name, _, _, _, _, interests in COMMUNITIES:
        for slug in slug_list(interests):
            ci_rows.append(
                f"SELECT {community_id_expr(name)}, id_interes FROM public.intereses WHERE slug = {sql_str(slug)}"
            )
    append("\nUNION ALL\n".join(ci_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    # miembros - creator as LIDER + random members
    append("INSERT INTO public.miembro_comunidad (id_comunidad, usuario_id_usuario, rol)")
    member_rows = []
    active_users = [u[1] for u in USERS if u[12] == "ACTIVO"]
    for idx, (name, _, priv, estado, creator, _) in enumerate(COMMUNITIES):
        member_rows.append(
            f"SELECT {community_id_expr(name)}, {user_id_expr(creator)}, 'LIDER'"
        )
        pool = [e for e in active_users if e != creator]
        random.shuffle(pool)
        if estado == "PENDIENTE":
            count = 0
        elif priv == "PRIVADA":
            count = random.randint(5, 10)
        else:
            count = random.randint(8, 18)
        for email in pool[:count]:
            member_rows.append(
                f"SELECT {community_id_expr(name)}, {user_id_expr(email)}, 'MIEMBRO'"
            )
    append("\nUNION ALL\n".join(member_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    # eventos
    append("INSERT INTO public.evento (")
    append("  nombre, titulo, descripcion, ubicacion_direccion, direccion, cupos_max,")
    append("  latitud, longitud, fecha_realizacion, estado, es_privado, whatsapp_link,")
    append("  usuario_id_usuario, comuna_id_comuna, comunidad_id_comunidad")
    append(") VALUES")
    event_rows = []
    for i, ev in enumerate(EVENTS):
        nombre, titulo, comuna, region, direccion, venue, lat, lng, days, cupos, priv, comm, org = ev
        estado = "ACTIVO"
        if days < 0 and days >= -10:
            estado = "CANCELADO"
        elif days < -10:
            estado = "FINALIZADO"
        desc = f"Encuentro presencial en {venue}, {comuna}. Cupos limitados."
        wa = "https://chat.whatsapp.com/DemoLOOP" + str(i + 1).zfill(3) if random.random() < 0.6 else None
        wa_sql = sql_str(wa) if wa else "NULL"
        fecha = f"now() + interval '{days} days'" if days >= 0 else f"now() + interval '{days} days'"
        event_rows.append(
            f"  ({sql_str(nombre)}, {sql_str(titulo)}, {sql_str(desc)}, "
            f"{sql_str(venue + ', ' + comuna)}, {sql_str(direccion)}, {cupos}, "
            f"{lat}, {lng}, {fecha}, {sql_str(estado)}, {'true' if priv else 'false'}, {wa_sql}, "
            f"{user_id_expr(org)}, {comuna_expr(comuna, region)}, {community_id_expr(comm)})"
        )
    append(",\n".join(event_rows) + ";")
    append("")

    # participantes
    append("INSERT INTO public.participantes_evento (evento_id_evento, usuario_id_usuario, estado_solicitud)")
    part_rows = []
    for i, ev in enumerate(EVENTS):
        _, titulo, *_ , priv, comm, org = ev
        titulo_sql = sql_str(titulo)
        pool = [e for e in active_users if e != org]
        random.shuffle(pool)
        n = random.randint(3, 12)
        for j, email in enumerate(pool[:n]):
            if priv and j < 2:
                estado = "PENDIENTE"
            elif priv and j == 2:
                estado = "RECHAZADO"
            else:
                estado = "ACEPTADO"
            part_rows.append(
                f"SELECT (SELECT id_evento FROM public.evento WHERE titulo = {titulo_sql} LIMIT 1), "
                f"{user_id_expr(email)}, {sql_str(estado)}"
            )
    append("\nUNION ALL\n".join(part_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    # publicaciones - 100 posts
    append("INSERT INTO public.publicaciones (titulo, contenido, fecha_publicacion, usuario_id_usuario, comunidades_id_comunidad, url_media) VALUES")
    post_rows = []
    post_authors: list[str] = []
    for e in active_users[:10]:
        post_authors.extend([e] * 4)
    for e in active_users[10:35]:
        post_authors.extend([e] * 2)
    for e in active_users[35:45]:
        post_authors.append(e)
    assert len(post_authors) == 100
    for idx, email in enumerate(post_authors):
        title = POST_TITLES[idx % len(POST_TITLES)]
        body = POST_BODIES[idx % len(POST_BODIES)] + f" — publicado por {email.split('@')[0]}."
        hours_ago = random.randint(2, 45 * 24)
        user_comms_sql = f"""(
          SELECT mc.id_comunidad FROM public.miembro_comunidad mc
          INNER JOIN public.usuario u ON u.id_usuario = mc.usuario_id_usuario
          WHERE u.email = {sql_str(email)}
          ORDER BY mc.id_comunidad
          LIMIT 1 OFFSET {idx % 3}
        )"""
        post_rows.append(
            f"  ({sql_str(title)}, {sql_str(body)}, now() - interval '{hours_ago} hours', "
            f"{user_id_expr(email)}, {user_comms_sql}, NULL)"
        )
    append(",\n".join(post_rows) + ";")
    append("")

    # comentarios
    append("INSERT INTO public.comentario (texto_comentario, usuario_id_usuario, publicaciones_id_post)")
    comment_rows = []
    comments_text = [
        "Buenisimo, nos vemos en el proximo!",
        "Me anote, gracias por compartir.",
        "Que buena iniciativa, apoyo total.",
        "Tengo una duda, a que hora es?",
        "Estuve en el evento anterior y estuvo 10/10.",
    ]
    for i in range(50):
        comment_rows.append(
            f"  ({sql_str(comments_text[i % len(comments_text)])}, "
            f"{user_id_expr(active_users[(i + 3) % len(active_users)])}, "
            f"(SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET {i}))"
        )
    append("VALUES\n" + ",\n".join(comment_rows) + ";")
    append("")

    # likes
    append("INSERT INTO public.reacciones_post (tipo_reaccion, usuario_id_usuario, publicaciones_id_post)")
    like_rows = []
    like_pairs = set()
    while len(like_pairs) < 150:
        like_pairs.add((random.randint(0, len(active_users) - 1), random.randint(0, 69)))
    for user_i, post_i in sorted(like_pairs):
        like_rows.append(
            f"SELECT 'LIKE', {user_id_expr(active_users[user_i])}, "
            f"(SELECT id_post FROM public.publicaciones ORDER BY id_post LIMIT 1 OFFSET {post_i})"
        )
    append("\nUNION ALL\n".join(like_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    # seguidores
    append("INSERT INTO public.seguidores (id_usuario_seguidor, id_usuario_seguido)")
    follow_rows = []
    pairs = set()
    while len(pairs) < 100:
        a, b = random.sample(active_users, 2)
        if a != b:
            pairs.add((a, b))
    for a, b in pairs:
        follow_rows.append(
            f"SELECT {user_id_expr(a)}, {user_id_expr(b)}"
        )
    append("\nUNION ALL\n".join(follow_rows))
    append("ON CONFLICT DO NOTHING;")
    append("")

    append("-- Credenciales: todos @loop.cl | admin LoopAdmin1 | resto LoopDemo1")
    append("-- Total: 50 usuarios, 50 comunidades, 50 eventos, 100 publicaciones")

    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    OUT.write_text(build(), encoding="utf-8")
    print(f"Wrote {OUT} ({OUT.stat().st_size // 1024} KB)")
