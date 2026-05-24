import 'package:eventosloop/features/admin/models/admin_models.dart';
import 'package:eventosloop/features/admin/models/admin_community_models.dart';
import 'package:eventosloop/features/admin/models/admin_directory_models.dart';
import 'package:eventosloop/features/admin/models/admin_ops_models.dart';
import 'package:flutter/material.dart';

class AdminMockService {
  List<AdminKpiMetric> fetchDashboardKpis() {
    return const <AdminKpiMetric>[
      AdminKpiMetric(
        label: 'Usuarios nuevos',
        value: '2.842',
        badgeLabel: '+12.4%',
        badgeColor: 0xFF2E9E6A,
      ),
      AdminKpiMetric(
        label: 'Publicaciones hoy',
        value: '14.120',
        badgeLabel: '+8.2%',
        badgeColor: 0xFF2E9E6A,
      ),
      AdminKpiMetric(
        label: 'Comunidades activas',
        value: '854',
        badgeLabel: 'Estable',
        badgeColor: 0xFF0682BC,
      ),
      AdminKpiMetric(
        label: 'Alertas pendientes',
        value: '14',
        badgeLabel: 'Urgente',
        badgeColor: 0xFFD64545,
      ),
    ];
  }

  List<AdminGrowthPoint> fetchGrowthSeries({required bool monthly}) {
    if (monthly) {
      return const <AdminGrowthPoint>[
        AdminGrowthPoint(label: '20 AGO', value: 0.18),
        AdminGrowthPoint(label: '24 AGO', value: 0.24),
        AdminGrowthPoint(label: '28 AGO', value: 0.31),
        AdminGrowthPoint(label: '01 SEP', value: 0.36),
        AdminGrowthPoint(label: '05 SEP', value: 0.42),
        AdminGrowthPoint(label: '09 SEP', value: 0.48),
        AdminGrowthPoint(label: '13 SEP', value: 0.55),
        AdminGrowthPoint(label: '17 SEP', value: 0.63),
        AdminGrowthPoint(label: '20 SEP', value: 0.71),
        AdminGrowthPoint(label: '24 SEP', value: 0.82),
      ];
    }
    return const <AdminGrowthPoint>[
      AdminGrowthPoint(label: 'LUN', value: 0.22),
      AdminGrowthPoint(label: 'MAR', value: 0.28),
      AdminGrowthPoint(label: 'MIE', value: 0.35),
      AdminGrowthPoint(label: 'JUE', value: 0.41),
      AdminGrowthPoint(label: 'VIE', value: 0.52),
      AdminGrowthPoint(label: 'SAB', value: 0.61),
      AdminGrowthPoint(label: 'DOM', value: 0.68),
    ];
  }

  List<AdminInterestRanking> fetchInterestRankings() {
    return const <AdminInterestRanking>[
      AdminInterestRanking(
        rank: 1,
        name: 'Tecnologia',
        usersLabel: '842.102',
        marketShare: 0.82,
        icon: Icons.memory_outlined,
        barColor: 0xFF005F9A,
      ),
      AdminInterestRanking(
        rank: 2,
        name: 'Futbol',
        usersLabel: '615.449',
        marketShare: 0.66,
        icon: Icons.sports_soccer_outlined,
        barColor: 0xFF7B61B5,
      ),
      AdminInterestRanking(
        rank: 3,
        name: 'Arte digital',
        usersLabel: '502.991',
        marketShare: 0.54,
        icon: Icons.brush_outlined,
        barColor: 0xFF0682BC,
      ),
      AdminInterestRanking(
        rank: 4,
        name: 'Bienestar',
        usersLabel: '428.211',
        marketShare: 0.42,
        icon: Icons.self_improvement_outlined,
        barColor: 0xFF9AB4D3,
      ),
      AdminInterestRanking(
        rank: 5,
        name: 'Negocios',
        usersLabel: '311.558',
        marketShare: 0.31,
        icon: Icons.business_center_outlined,
        barColor: 0xFFB8C9DE,
      ),
    ];
  }

  AdminModerationIncident fetchSampleIncident({String reportId = '849201'}) {
    return AdminModerationIncident(
      reportId: reportId,
      contentType: AdminReportContentType.post,
      contentId: 0,
      authorUserId: 0,
      authorName: 'Marcus Vance',
      authorHandle: '@marcus_22',
      postedLabel: 'Publicado hace 4 horas',
      riskLabel: 'ALTO RIESGO',
      content:
          'El ecosistema se esta cayendo por el liderazgo. Tenemos que empujar mas fuerte contra los moderadores que estan silenciando nuestra comunidad. Si no escuchan, los haremos escuchar. Este es el inicio del cambio.',
      likesLabel: '1.2k',
      commentsLabel: '458',
      joinedLabel: '12 ene 2023',
      statusLabel: 'Verificado',
      followersLabel: '12.4k',
      pendingReportsLabel: '3 pendientes',
      reasonTags: <String>['Acoso', 'Incitacion'],
      reportVolumeLabel: '42 reportes en las ultimas 12 h',
      reporterComments: <String>[
        'Esta publicacion apunta a nuestros moderadores con lenguaje hostil.',
        'Parece acoso coordinado. Varias cuentas republicaron el mismo tono.',
      ],
      previousActions: <String>[
        'Advertencia: discurso de odio (hace 2 meses)',
        'Resuelto: descartado (hace 1 ano)',
      ],
    );
  }

  List<AdminCommunityRow> fetchCommunities() {
    return const <AdminCommunityRow>[
      AdminCommunityRow(
        id: 1,
        name: 'Tech Hub Global',
        category: 'TECNOLOGIA',
        leadCreator: 'Alec Rivera',
        engagementLabel: '12.4K',
        postsLabel: '8.2K PUBLICACIONES',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF005F9A,
        canUnblock: false,
      ),
      AdminCommunityRow(
        id: 2,
        name: 'Green Earth Collective',
        category: 'SOSTENIBILIDAD',
        leadCreator: 'Sofia Mendez',
        engagementLabel: '9.1K',
        postsLabel: '5.4K PUBLICACIONES',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF2E9E6A,
        canUnblock: false,
      ),
      AdminCommunityRow(
        id: 3,
        name: 'Urban Sketchers',
        category: 'ARTE Y DISENO',
        leadCreator: 'Leo Park',
        engagementLabel: '6.8K',
        postsLabel: '3.1K PUBLICACIONES',
        status: AdminCommunityStatus.banned,
        thumbnailColor: 0xFF7B61B5,
        canUnblock: true,
      ),
      AdminCommunityRow(
        id: 4,
        name: 'Mindful Mornings',
        category: 'BIENESTAR',
        leadCreator: 'Elena Solis',
        engagementLabel: '4.2K',
        postsLabel: '2.0K PUBLICACIONES',
        status: AdminCommunityStatus.active,
        thumbnailColor: 0xFF0682BC,
        canUnblock: false,
      ),
    ];
  }

  List<AdminModerationStat> fetchModerationStats() {
    return const <AdminModerationStat>[
      AdminModerationStat(
        label: 'Reportes totales',
        value: '1.482',
        subtitle: '+5% respecto a ayer',
        subtitleColor: 0xFF2E9E6A,
        icon: Icons.trending_up,
      ),
      AdminModerationStat(
        label: 'Tiempo de respuesta prom.',
        value: '14m',
        subtitle: 'Dentro del objetivo',
        subtitleColor: 0xFF2E9E6A,
        icon: Icons.check_circle_outline,
      ),
      AdminModerationStat(
        label: 'Resueltos hoy',
        value: '342',
        subtitle: 'Alta eficiencia',
        subtitleColor: 0xFF0682BC,
        icon: Icons.bolt_outlined,
      ),
    ];
  }

  List<AdminReportQueueRow> fetchReportQueue() {
    final DateTime now = DateTime.now();
    return <AdminReportQueueRow>[
      AdminReportQueueRow(
        id: '1',
        dateLabel: '21 oct, 14:20',
        sortDate: now,
        reporterHandle: '@julia_v',
        objectLabel: 'Publicacion ID: 8823-X',
        objectAuthor: '@marcus_22',
        reason: 'Acoso',
        reasonColor: 0xFFD64545,
        status: AdminReportStatus.pending,
        actionLabel: 'Procesado por IA',
        incidentReportId: 'post-849201',
        contentType: AdminReportContentType.post,
      ),
      AdminReportQueueRow(
        id: '2',
        dateLabel: '21 oct, 13:05',
        sortDate: now.subtract(const Duration(hours: 1)),
        reporterHandle: '@diego.dev',
        objectLabel: 'Comentario: 1122-Y',
        objectAuthor: '@spam_bot',
        reason: 'Spam',
        reasonColor: 0xFF0682BC,
        status: AdminReportStatus.reviewed,
        actionLabel: 'Resuelto',
        incidentReportId: 'post-849202',
        contentType: AdminReportContentType.post,
      ),
      AdminReportQueueRow(
        id: '3',
        dateLabel: '21 oct, 11:48',
        sortDate: now.subtract(const Duration(hours: 3)),
        reporterHandle: '@camila.foodie',
        objectLabel: 'Publicacion ID: 7710-Z',
        objectAuthor: '@unknown_user',
        reason: 'Inapropiado',
        reasonColor: 0xFFE08A3A,
        status: AdminReportStatus.pending,
        actionLabel: 'Pendiente',
        incidentReportId: 'post-849203',
        contentType: AdminReportContentType.post,
      ),
      AdminReportQueueRow(
        id: '4',
        dateLabel: '21 oct, 10:12',
        sortDate: now.subtract(const Duration(hours: 4)),
        reporterHandle: '@martina.loop',
        objectLabel: 'Evento ID: 6601-A',
        objectAuthor: '@fake_profile',
        reason: 'Suplantacion',
        reasonColor: 0xFF5B79AA,
        status: AdminReportStatus.pending,
        actionLabel: 'Pendiente',
        incidentReportId: 'event-849204',
        contentType: AdminReportContentType.event,
      ),
    ];
  }

  List<AdminUserRow> fetchUsers() {
    return const <AdminUserRow>[
      AdminUserRow(
        idUsuario: 1,
        name: 'Sarah Jenkins',
        email: 'sarah.j@loop.io',
        role: 'ADMIN',
        interests: <String>['Diseno', 'IA'],
        joinedLabel: '12 ene 2024',
        status: AdminUserStatus.active,
        avatarColor: 0xFF0682BC,
      ),
      AdminUserRow(
        idUsuario: 2,
        name: 'Marcus Vance',
        email: 'marcus.v@loop.io',
        role: 'USER',
        interests: <String>['Fintech', 'Running'],
        joinedLabel: '03 mar 2024',
        status: AdminUserStatus.pending,
        avatarColor: 0xFF7B61B5,
      ),
      AdminUserRow(
        idUsuario: 3,
        name: 'Elena Solis',
        email: 'elena.s@loop.io',
        role: 'USER',
        interests: <String>['Bienestar', 'Yoga'],
        joinedLabel: '18 jun 2024',
        status: AdminUserStatus.active,
        avatarColor: 0xFF2E9E6A,
      ),
      AdminUserRow(
        idUsuario: 4,
        name: 'Diego Rojas',
        email: 'diego.r@loop.io',
        role: 'USER',
        interests: <String>['Gaming', 'Tech'],
        joinedLabel: '02 ago 2023',
        status: AdminUserStatus.suspended,
        avatarColor: 0xFFD64545,
      ),
    ];
  }

  List<AdminEventStat> fetchEventStats() {
    return const <AdminEventStat>[
      AdminEventStat(label: 'Eventos activos', value: '1.284'),
      AdminEventStat(label: 'Solicitudes pendientes', value: '432'),
      AdminEventStat(label: 'Velocidad del chat', value: 'Alta'),
      AdminEventStat(label: 'Contenido marcado', value: '12'),
    ];
  }

  List<AdminEventRow> fetchLiveEvents() {
    return const <AdminEventRow>[
      AdminEventRow(
        idEvento: 1,
        name: 'Proyecto Musica Urbana',
        dateLabel: '21 oct 2025',
        community: 'Creative Arts Hub',
        type: AdminEventType.publicEvent,
        participantsLabel: '164/150',
        chatStatus: AdminEventChatStatus.active,
        chatDetail: 'Activo (63 msg/min)',
        iconColor: 0xFF005F9A,
        needsModeration: false,
      ),
      AdminEventRow(
        idEvento: 2,
        name: 'Noche de Pitch Startups',
        dateLabel: '21 oct 2025',
        community: 'Founders Circle',
        type: AdminEventType.privateEvent,
        participantsLabel: '48/50',
        chatStatus: AdminEventChatStatus.quiet,
        chatDetail: 'Silencioso',
        iconColor: 0xFF7B61B5,
        needsModeration: false,
      ),
      AdminEventRow(
        idEvento: 3,
        name: 'Night Run Santiago',
        dateLabel: '22 oct 2025',
        community: 'Running Santiago',
        type: AdminEventType.publicEvent,
        participantsLabel: '92/120',
        chatStatus: AdminEventChatStatus.moderationRequired,
        chatDetail: 'Requiere moderacion',
        iconColor: 0xFFD64545,
        needsModeration: true,
      ),
      AdminEventRow(
        idEvento: 4,
        name: 'Taller de Ceramica',
        dateLabel: '23 oct 2025',
        community: 'Maker Studio',
        type: AdminEventType.publicEvent,
        participantsLabel: '24/30',
        chatStatus: AdminEventChatStatus.active,
        chatDetail: 'Activo (12 msg/min)',
        iconColor: 0xFF0682BC,
        needsModeration: false,
      ),
    ];
  }

  List<AdminAdStat> fetchAdStats() {
    return const <AdminAdStat>[
      AdminAdStat(label: 'Campanas activas', value: '18'),
      AdminAdStat(label: 'Impresiones totales', value: '2.4M'),
      AdminAdStat(label: 'CTR promedio', value: '3.8%'),
      AdminAdStat(label: 'Ingresos ads (mes)', value: '\$12.4K'),
    ];
  }

  List<AdminAdCampaignRow> fetchAdCampaigns() {
    return const <AdminAdCampaignRow>[
      AdminAdCampaignRow(
        name: 'Lanzamiento LOOP Premium',
        placement: 'Banner del feed',
        budgetLabel: '\$2.500',
        impressionsLabel: '842K',
        ctrLabel: '4.2%',
        status: AdminAdCampaignStatus.running,
        accentColor: 0xFF0682BC,
      ),
      AdminAdCampaignRow(
        name: 'Promo Running Santiago',
        placement: 'Carrusel explorador',
        budgetLabel: '\$800',
        impressionsLabel: '312K',
        ctrLabel: '3.1%',
        status: AdminAdCampaignStatus.running,
        accentColor: 0xFF2E9E6A,
      ),
      AdminAdCampaignRow(
        name: 'Semana del Bienestar',
        placement: 'Encabezado comunidad',
        budgetLabel: '\$1.200',
        impressionsLabel: '0',
        ctrLabel: '—',
        status: AdminAdCampaignStatus.scheduled,
        accentColor: 0xFF7B61B5,
      ),
      AdminAdCampaignRow(
        name: 'Eventos Flash Q4',
        placement: 'Detalle de evento',
        budgetLabel: '\$600',
        impressionsLabel: '98K',
        ctrLabel: '2.4%',
        status: AdminAdCampaignStatus.paused,
        accentColor: 0xFFE08A3A,
      ),
    ];
  }

  List<AdminServiceStatusRow> fetchServiceStatuses() {
    return const <AdminServiceStatusRow>[
      AdminServiceStatusRow(
        name: 'API Supabase',
        description: 'Capa REST + PostgREST',
        health: AdminServiceHealth.operational,
        latencyLabel: '42 ms',
        uptimeLabel: '99.98%',
      ),
      AdminServiceStatusRow(
        name: 'Servicio de auth',
        description: 'Login, OTP, OAuth',
        health: AdminServiceHealth.operational,
        latencyLabel: '68 ms',
        uptimeLabel: '99.95%',
      ),
      AdminServiceStatusRow(
        name: 'Almacenamiento',
        description: 'Subida de media (posts/eventos)',
        health: AdminServiceHealth.degraded,
        latencyLabel: '210 ms',
        uptimeLabel: '99.12%',
      ),
      AdminServiceStatusRow(
        name: 'Realtime',
        description: 'Notificaciones y actualizaciones en vivo',
        health: AdminServiceHealth.operational,
        latencyLabel: '55 ms',
        uptimeLabel: '99.90%',
      ),
      AdminServiceStatusRow(
        name: 'Edge Functions',
        description: 'RPC y trabajos en segundo plano',
        health: AdminServiceHealth.operational,
        latencyLabel: '91 ms',
        uptimeLabel: '99.87%',
      ),
    ];
  }

  List<AdminSystemIncidentRow> fetchSystemIncidents() {
    return const <AdminSystemIncidentRow>[
      AdminSystemIncidentRow(
        timeLabel: 'Hoy 09:14',
        service: 'Almacenamiento',
        message: 'Latencia elevada en bucket de media (region sa-east-1)',
        severityColor: 0xFFE08A3A,
      ),
      AdminSystemIncidentRow(
        timeLabel: 'Ayer 22:03',
        service: 'Servicio de auth',
        message: 'Retraso en entrega OTP resuelto (proveedor de email)',
        severityColor: 0xFF2E9E6A,
      ),
      AdminSystemIncidentRow(
        timeLabel: '19 oct 16:40',
        service: 'API Supabase',
        message: 'Pico breve de timeouts durante trafico maximo',
        severityColor: 0xFFD64545,
      ),
    ];
  }
}
