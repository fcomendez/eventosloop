import 'package:eventosloop/features/communities/models/community_model.dart';

class CommunityDetailMockService {
  static final List<CommunityModel> _communities = <CommunityModel>[
    const CommunityModel(
      id: 1,
      name: 'Creative Collective',
      category: 'Arte y diseno',
      description:
          'Red para compartir procesos creativos, colaborar y asistir a encuentros locales. Ideal para disenadores, fotografos y artistas que buscan comunidad activa.',
      tags: <String>['Diseno', 'Fotografia', 'Arte digital'],
      activityLabel: '3.2k miembros activos esta semana',
      coverColorHex: '#C9D9D1',
    ),
    const CommunityModel(
      id: 2,
      name: 'Tech Founders Circle',
      category: 'Emprendimiento',
      description:
          'Comunidad para fundadores, networking, sesiones tecnicas y revision de ideas. Conectamos talento tech en Santiago.',
      tags: <String>['TypeScript', 'Cloud Architecture', 'UI Design'],
      activityLabel: '980 miembros activos esta semana',
      coverColorHex: '#192B3A',
    ),
    const CommunityModel(
      id: 3,
      name: 'Open Source Explorers',
      category: 'Tecnologia',
      description:
          'Grupo para aprender, crear proyectos y compartir recursos de desarrollo open source.',
      tags: <String>['Open Source', 'Flutter', 'Backend'],
      activityLabel: '1.2k miembros activos esta semana',
      coverColorHex: '#0E3554',
    ),
    const CommunityModel(
      id: 4,
      name: 'Digital Canvas Lab',
      category: 'Fotografia y arte',
      description:
          'Explora herramientas visuales, exposiciones y actividades colaborativas para creadores visuales.',
      tags: <String>['Ilustracion', 'Branding', 'Motion'],
      activityLabel: '640 miembros activos esta semana',
      coverColorHex: '#D8B46A',
    ),
    const CommunityModel(
      id: 5,
      name: 'Laboratorio de Diseño Urbano',
      category: 'Arquitectura',
      description:
          'Exploramos el futuro de la vida urbana y la arquitectura sostenible. Talleres, visitas y proyectos colaborativos en la ciudad.',
      tags: <String>['Urbanismo', 'Sostenibilidad', 'Arquitectura'],
      activityLabel: '12.4k miembros activos esta semana',
      coverColorHex: '#065A92',
    ),
    const CommunityModel(
      id: 6,
      name: 'Vecindario FC',
      category: 'Deportes',
      description:
          'Comunidad local de futbol y actividad en el barrio. Partidos amistosos, entrenamientos y eventos deportivos.',
      tags: <String>['Futbol', 'Comunidad', 'Deporte'],
      activityLabel: '842 miembros activos esta semana',
      coverColorHex: '#2E7D32',
    ),
    const CommunityModel(
      id: 7,
      name: 'Grupo de Estudio',
      category: 'Educacion',
      description:
          'Espacio para organizar sesiones de estudio, compartir material y preparar evaluaciones en grupo.',
      tags: <String>['Estudio', 'Universidad', 'Apoyo'],
      activityLabel: '2k miembros activos esta semana',
      coverColorHex: '#5C6BC0',
    ),
    const CommunityModel(
      id: 8,
      name: 'Creadores Digitales',
      category: 'Tecnologia',
      description:
          'Red de creadores de contenido, diseno digital y herramientas creativas online.',
      tags: <String>['Contenido', 'Diseno', 'Redes'],
      activityLabel: '5.1k miembros activos esta semana',
      coverColorHex: '#00838F',
    ),
    const CommunityModel(
      id: 9,
      name: 'Jardineros Urbanos',
      category: 'Estilo de vida',
      description:
          'Huertos urbanos, permacultura y actividades al aire libre en espacios comunitarios.',
      tags: <String>['Huerto', 'Naturaleza', 'Comunidad'],
      activityLabel: '1.8k miembros activos esta semana',
      coverColorHex: '#558B2F',
    ),
    const CommunityModel(
      id: 10,
      name: 'Mañanas Zen',
      category: 'Bienestar',
      description:
          'Rutinas matinales, meditacion y habitos saludables para empezar el dia con calma.',
      tags: <String>['Mindfulness', 'Salud', 'Rutinas'],
      activityLabel: '3.4k miembros activos esta semana',
      coverColorHex: '#7E57C2',
    ),
  ];

  static final Map<int, List<CommunityPostModel>> _postsByCommunity =
      <int, List<CommunityPostModel>>{
    1: <CommunityPostModel>[
      const CommunityPostModel(
        id: 201,
        authorName: 'Alex Rivero',
        authorInitials: 'AR',
        publishedLabel: 'hace 2 h',
        title: 'Transicion hacia economia circular',
        body:
            'Compartimos avances del proyecto comunitario y como reducimos residuos en un 40% este trimestre.',
        linkedTo: 'Creative Collective',
        likesCount: 1200,
        commentsCount: 84,
        mediaLabel: 'Reciclaje',
        mediaColorHex: '#6B9080',
      ),
      const CommunityPostModel(
        id: 202,
        authorName: 'Camila Torres',
        authorInitials: 'CT',
        publishedLabel: 'hace 5 h',
        title: 'Proceso creativo en equipo',
        body:
            'Notas de nuestro ultimo taller: iteracion rapida, feedback honesto y mucha energia colectiva.',
        linkedTo: 'Taller UX',
        likesCount: 320,
        commentsCount: 41,
        isLinked: true,
      ),
    ],
    2: <CommunityPostModel>[
      const CommunityPostModel(
        id: 203,
        authorName: 'Diego Rojas',
        authorInitials: 'DR',
        publishedLabel: 'hace 1 d',
        title: 'Pitch deck en 10 slides',
        body:
            'Resumen de la charla de ayer sobre como contar tu historia de producto sin perder claridad.',
        linkedTo: 'Founders Circle',
        likesCount: 540,
        commentsCount: 62,
        isLinked: true,
      ),
    ],
    3: <CommunityPostModel>[
      const CommunityPostModel(
        id: 204,
        authorName: 'Tomas Rojas',
        authorInitials: 'TR',
        publishedLabel: 'hace 3 h',
        title: 'Contribuciones open source',
        body:
            'Lista de repos donde la comunidad esta colaborando este mes. Sumense con buenos first issues.',
        linkedTo: 'Open Source Explorers',
        likesCount: 210,
        commentsCount: 28,
      ),
    ],
    4: <CommunityPostModel>[
      const CommunityPostModel(
        id: 205,
        authorName: 'Elena Rodriguez',
        authorInitials: 'ER',
        publishedLabel: 'hace 6 h',
        title: 'Exposicion colectiva',
        body:
            'Abrimos convocatoria para piezas visuales del proximo showcase del lab.',
        linkedTo: 'Digital Canvas Lab',
        likesCount: 180,
        commentsCount: 19,
        mediaLabel: 'Showcase',
        mediaColorHex: '#D8B46A',
      ),
    ],
    5: <CommunityPostModel>[
      const CommunityPostModel(
        id: 206,
        authorName: 'Maria Soto',
        authorInitials: 'MS',
        publishedLabel: 'hace 4 h',
        title: 'Recorrido por barrio sustentable',
        body:
            'Este sabado visitamos un proyecto de vivienda colectiva con enfoque ecologico. Cupos limitados.',
        linkedTo: 'Laboratorio de Diseno Urbano',
        likesCount: 890,
        commentsCount: 54,
        mediaLabel: 'Urbanismo',
        mediaColorHex: '#065A92',
      ),
    ],
  };

  Future<CommunityModel?> fetchById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    try {
      return _communities.firstWhere((CommunityModel c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<CommunityPostModel>> fetchPosts(int communityId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _postsByCommunity[communityId] ?? <CommunityPostModel>[];
  }
}
