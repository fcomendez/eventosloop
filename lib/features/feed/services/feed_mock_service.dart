import 'package:eventosloop/features/feed/models/feed_item_model.dart';
import 'package:eventosloop/features/feed/models/feed_page_result.dart';

class FeedMockService {  static const int _pageSize = 6;

  List<FeedItemModel> get allItems => _items;

  static final List<FeedItemModel> _items = <FeedItemModel>[
    const FeedItemModel(
      id: 120,
      type: FeedItemType.evento,
      author: FeedAuthorModel(
        name: 'Marcos Castillo',
        username: '@marcos.eventos',
        avatarInitials: 'MC',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      ),
      publishedLabel: 'hace 12 min',
      title: 'Workshop de UX Editorial',
      body:
          'Excelente conversacion sobre diseno de comunidades creativas. El ambiente estuvo lleno de ideas y conexiones reales.',
      contextLabel: 'Evento: Workshop UX Editorial',
      mediaLabel: 'UX Editorial',
      mediaColorHex: '#B8DFF6',
      likesCount: 128,
      commentsCount: 24,
      sharesCount: 8,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 119,
      type: FeedItemType.comunidad,
      author: FeedAuthorModel(
        name: 'Creative Collective',
        username: '@creativeclub',
        avatarInitials: 'CC',
      ),
      publishedLabel: 'hace 31 min',
      body:
          'Abrimos cupos para una salida fotografica este fin de semana. Ideal para quienes estan empezando.',
      contextLabel: 'Comunidad: Fotografia',
      mediaLabel: 'Photo walk',
      mediaColorHex: '#D9EAF5',
      likesCount: 82,
      commentsCount: 13,
      sharesCount: 5,
      likedByMe: true,
    ),
    const FeedItemModel(
      id: 118,
      type: FeedItemType.personal,
      author: FeedAuthorModel(
        name: 'Ana Soto',
        username: '@anasoto',
        avatarInitials: 'AS',
      ),
      publishedLabel: 'hace 48 min',
      body:
          'Hoy descubri una cafeteria perfecta para conversar despues de eventos. Buen cafe, buena musica y espacio para grupos.',
      mediaLabel: 'Cafe LOOP',
      mediaColorHex: '#F3D9BD',
      likesCount: 64,
      commentsCount: 9,
      sharesCount: 2,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 117,
      type: FeedItemType.evento,
      author: FeedAuthorModel(
        name: 'Tomas Rojas',
        username: '@tomas.run',
        avatarInitials: 'TR',
      ),
      publishedLabel: 'hace 1 h',
      title: 'Running nocturno por el parque',
      body:
          'Gran ritmo y grupo muy buena onda. Quedamos en repetirlo el proximo jueves con ruta nueva.',
      contextLabel: 'Evento: Running nocturno',
      mediaLabel: 'Running',
      mediaColorHex: '#BFE8D4',
      likesCount: 201,
      commentsCount: 37,
      sharesCount: 15,
      likedByMe: true,
    ),
    const FeedItemModel(
      id: 116,
      type: FeedItemType.comunidad,
      author: FeedAuthorModel(
        name: 'Urban Gardeners',
        username: '@urbangardeners',
        avatarInitials: 'UG',
      ),
      publishedLabel: 'hace 2 h',
      body:
          'Compartimos una guia rapida para iniciar un huerto urbano en balcones pequenos.',
      contextLabel: 'Comunidad: Jardineria',
      mediaLabel: 'Huerto urbano',
      mediaColorHex: '#CFE7C1',
      likesCount: 97,
      commentsCount: 18,
      sharesCount: 11,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 115,
      type: FeedItemType.personal,
      author: FeedAuthorModel(
        name: 'Valentina Mora',
        username: '@vale.mora',
        avatarInitials: 'VM',
      ),
      publishedLabel: 'hace 3 h',
      body:
          'Me encanto conocer gente nueva en el grupo de idiomas. Recomendado para practicar sin presion.',
      contextLabel: 'Interes: Idiomas',
      likesCount: 43,
      commentsCount: 6,
      sharesCount: 1,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 114,
      type: FeedItemType.evento,
      author: FeedAuthorModel(
        name: 'Loop Cultura',
        username: '@loopcultura',
        avatarInitials: 'LC',
      ),
      publishedLabel: 'ayer',
      title: 'Noche de museos',
      body:
          'Resumen de una noche llena de arte, musica y conversaciones espontaneas entre asistentes.',
      contextLabel: 'Evento: Noche de museos',
      mediaLabel: 'Museos',
      mediaColorHex: '#D6CDF0',
      likesCount: 314,
      commentsCount: 41,
      sharesCount: 22,
      likedByMe: true,
    ),
    const FeedItemModel(
      id: 113,
      type: FeedItemType.comunidad,
      author: FeedAuthorModel(
        name: 'Tech Founders Circle',
        username: '@techfounders',
        avatarInitials: 'TF',
      ),
      publishedLabel: 'ayer',
      body:
          'Tema de la semana: como validar una idea antes de construir el MVP.',
      contextLabel: 'Comunidad: Emprendimiento',
      mediaLabel: 'MVP',
      mediaColorHex: '#C9E6F2',
      likesCount: 151,
      commentsCount: 29,
      sharesCount: 18,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 112,
      type: FeedItemType.personal,
      author: FeedAuthorModel(
        name: 'Daniela Perez',
        username: '@danip',
        avatarInitials: 'DP',
      ),
      publishedLabel: 'ayer',
      body:
          'Primer taller de ceramica terminado. No quedo perfecto, pero fue mucho mas entretenido de lo que esperaba.',
      contextLabel: 'Interes: Ceramica',
      likesCount: 76,
      commentsCount: 12,
      sharesCount: 3,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 111,
      type: FeedItemType.evento,
      author: FeedAuthorModel(
        name: 'Santiago Salsa Club',
        username: '@salsaclub',
        avatarInitials: 'SS',
      ),
      publishedLabel: '2 dias',
      title: 'Clase abierta de salsa',
      body:
          'Gran convocatoria. Subiremos pronto nuevas fechas para nivel inicial e intermedio.',
      contextLabel: 'Evento: Salsa inicial',
      mediaLabel: 'Salsa',
      mediaColorHex: '#F0C7C7',
      likesCount: 222,
      commentsCount: 33,
      sharesCount: 12,
      likedByMe: false,
    ),
    const FeedItemModel(
      id: 110,
      type: FeedItemType.comunidad,
      author: FeedAuthorModel(
        name: 'Open Source Explorers',
        username: '@opensource',
        avatarInitials: 'OS',
      ),
      publishedLabel: '2 dias',
      body:
          'Buscamos personas para armar una sesion corta sobre contribuciones a proyectos abiertos.',
      contextLabel: 'Comunidad: Tecnologia',
      likesCount: 139,
      commentsCount: 21,
      sharesCount: 9,
      likedByMe: true,
    ),
  ];

  Future<FeedPageResult> fetchPage({int? cursor}) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    final List<FeedItemModel> source = cursor == null
        ? _items
        : _items.where((FeedItemModel item) => item.id < cursor).toList();
    final List<FeedItemModel> page = source.take(_pageSize).toList();

    return FeedPageResult(
      items: page,
      nextCursor: page.isEmpty ? cursor : page.last.id,
      hasMore: source.length > _pageSize,
    );
  }
}
