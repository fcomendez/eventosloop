import 'package:eventosloop/core/navigation/detail_navigation.dart';
import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:flutter/material.dart';

enum ExploreFilter { personas, comunidades, eventos }

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final TextEditingController _searchController = TextEditingController();
  ExploreFilter _selectedFilter = ExploreFilter.eventos;
  String _query = '';

  bool get _searching => _query.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFD8EAF7), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _SearchHeader(
                controller: _searchController,
                selectedFilter: _selectedFilter,
                onQueryChanged: (String value) {
                  setState(() {
                    _query = value;
                  });
                },
                onFilterChanged: (ExploreFilter filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              Expanded(
                child: _searching
                    ? _SearchResults(
                        filter: _selectedFilter,
                        query: _query,
                      )
                    : const _ExploreHome(),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.explorar,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.explorar) {
                    return;
                  }
                  navigateFromBar(context, item);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.selectedFilter,
    required this.onQueryChanged,
    required this.onFilterChanged,
  });

  final TextEditingController controller;
  final ExploreFilter selectedFilter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<ExploreFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.45)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onQueryChanged,
                  decoration: InputDecoration(
                    hintText: 'Buscar en LOOP',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: controller.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              controller.clear();
                              onQueryChanged('');
                            },
                            icon: const Icon(Icons.close, size: 18),
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              _FilterChip(
                label: 'Personas',
                selected: selectedFilter == ExploreFilter.personas,
                onTap: () => onFilterChanged(ExploreFilter.personas),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Comunidades',
                selected: selectedFilter == ExploreFilter.comunidades,
                onTap: () => onFilterChanged(ExploreFilter.comunidades),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Eventos',
                selected: selectedFilter == ExploreFilter.eventos,
                onTap: () => onFilterChanged(ExploreFilter.eventos),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.white : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreHome extends StatelessWidget {
  const _ExploreHome();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      children: <Widget>[
        const _ExploreSectionTitle(
          title: 'Eventos cerca de ti',
          action: 'Ver todo',
        ),
        const _NearbyEventsCarousel(),
        const SizedBox(height: 18),
        const _ExploreSectionTitle(title: 'Comunidades recomendadas'),
        const _CommunitiesCarousel(),
        const SizedBox(height: 18),
        const _ExploreSectionTitle(title: 'Eventos proximos'),
        const _UpcomingEventsCarousel(),
        const SizedBox(height: 18),
        const _ExploreSectionTitle(title: 'Publicaciones destacadas'),
        _ImagePostCard(
          postId: 118,
          user: '@martina.loop',
          linkedTo: 'Comunidad: Running Santiago',
          imageLabel: 'Atardecer en el parque',
          caption:
              'Gran salida grupal despues del trabajo. Buen ritmo, buena energia y nuevas personas para seguir entrenando.',
          likes: 42,
          comments: 11,
          onOpen: () => openPostDetail(context, 118),
        ),
        const SizedBox(height: 12),
        _TextPostCard(
          postId: 120,
          user: '@diego.dev',
          linkedTo: 'Evento: Workshop UX Editorial',
          title: 'Que llevarian a una jornada creativa?',
          body:
              'Estoy armando mi lista para el proximo encuentro y quiero recomendaciones de materiales, libros o apps utiles.',
          replies: 18,
          likes: 31,
          onOpen: () => openPostDetail(context, 120),
        ),
        const SizedBox(height: 12),
        _ImagePostCard(
          postId: 115,
          user: '@camila.foodie',
          linkedTo: 'Evento: Feria gastronomica',
          imageLabel: 'Sabores locales',
          caption:
              'Probamos cafeterias nuevas y varios stands de comida chilena. Recomendadisimo para ir en grupo.',
          likes: 76,
          comments: 24,
          onOpen: () => openPostDetail(context, 115),
        ),
      ],
    );
  }
}

class _ExploreSectionTitle extends StatelessWidget {
  const _ExploreSectionTitle({
    required this.title,
    this.action,
  });

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (action != null)
            Text(
              action!,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
        ],
      ),
    );
  }
}

class _NearbyEventsCarousel extends StatelessWidget {
  const _NearbyEventsCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _EventCompactCard(
            eventId: 6,
            title: 'Yoga al amanecer',
            meta: 'Providencia · 1.8 km',
            date: 'Hoy 07:30',
            color: Color(0xFF7BC8B7),
          ),
          _EventCompactCard(
            eventId: 2,
            title: 'Cafe y lectura',
            meta: 'Nunoa · 2.4 km',
            date: 'Hoy 18:00',
            color: Color(0xFFD9A441),
          ),
          _EventCompactCard(
            eventId: 4,
            title: 'Running nocturno',
            meta: 'Las Condes · 3.1 km',
            date: 'Manana 20:00',
            color: Color(0xFF0E3554),
          ),
        ],
      ),
    );
  }
}

class _CommunitiesCarousel extends StatelessWidget {
  const _CommunitiesCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _CommunityCard(
            title: 'Cine Club',
            members: '840 miembros',
            color: Color(0xFF111827),
          ),
          _CommunityCard(
            title: 'Outdoor Chile',
            members: '1.4k miembros',
            color: Color(0xFF245B4A),
          ),
          _CommunityCard(
            title: 'Foodies LOOP',
            members: '620 miembros',
            color: Color(0xFF9A5A00),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEventsCarousel extends StatelessWidget {
  const _UpcomingEventsCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const <Widget>[
          _EventCompactCard(
            eventId: 5,
            title: 'Festival urbano',
            meta: 'Santiago Centro',
            date: 'Sab 25',
            color: Color(0xFFC94F4F),
          ),
          _EventCompactCard(
            eventId: 1,
            title: 'Torneo de ajedrez',
            meta: 'La Reina',
            date: 'Dom 26',
            color: Color(0xFF2C3E50),
          ),
          _EventCompactCard(
            eventId: 3,
            title: 'Taller de ceramica',
            meta: 'Barrio Italia',
            date: 'Mar 28',
            color: Color(0xFFB97955),
          ),
        ],
      ),
    );
  }
}

class _EventCompactCard extends StatelessWidget {
  const _EventCompactCard({
    required this.eventId,
    required this.title,
    required this.meta,
    required this.date,
    required this.color,
  });

  final int eventId;
  final String title;
  final String meta;
  final String date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openEventDetail(context, eventId),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      width: 158,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 82,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.event_available_outlined,
                color: AppColors.white.withValues(alpha: 0.92),
                size: 34,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        date,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Text(
                      'Ver',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard({
    required this.title,
    required this.members,
    required this.color,
  });

  final String title;
  final String members;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.white,
            child: Icon(Icons.groups_outlined, color: AppColors.primary),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            members,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.78),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Unirme',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePostCard extends StatelessWidget {
  const _ImagePostCard({
    required this.postId,
    required this.user,
    required this.linkedTo,
    required this.imageLabel,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.onOpen,
  });

  final int postId;
  final String user;
  final String linkedTo;
  final String imageLabel;
  final String caption;
  final int likes;
  final int comments;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.inputBackground,
                  child: Icon(Icons.person, color: AppColors.primary, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        linkedTo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 190,
            width: double.infinity,
            color: AppColors.inputBackground,
            child: Center(
              child: Text(
                imageLabel,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: <Widget>[
                const Icon(Icons.favorite_border, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text('$likes'),
                const SizedBox(width: 18),
                const Icon(
                  Icons.mode_comment_outlined,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 5),
                Text('$comments'),
                const Spacer(),
                const Icon(Icons.send_outlined, color: AppColors.primary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  height: 1.32,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '$user ',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  TextSpan(text: caption),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _TextPostCard extends StatelessWidget {
  const _TextPostCard({
    required this.postId,
    required this.user,
    required this.linkedTo,
    required this.title,
    required this.body,
    required this.replies,
    required this.likes,
    required this.onOpen,
  });

  final int postId;
  final String user;
  final String linkedTo;
  final String title;
  final String body;
  final int replies;
  final int likes;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$user · $linkedTo',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.34),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const Icon(
                Icons.mode_comment_outlined,
                size: 17,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text('$replies respuestas'),
              const SizedBox(width: 14),
              const Icon(
                Icons.favorite_border,
                size: 17,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text('$likes'),
              const Spacer(),
              const Text(
                'Ver mas',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.filter,
    required this.query,
  });

  final ExploreFilter filter;
  final String query;

  @override
  Widget build(BuildContext context) {
    final String title = switch (filter) {
      ExploreFilter.personas => 'Personas',
      ExploreFilter.comunidades => 'Comunidades',
      ExploreFilter.eventos => 'Eventos',
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
      children: <Widget>[
        Text(
          '$title para "$query"',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        if (filter == ExploreFilter.personas) ...<Widget>[
          _PersonResult(
            userId: 101,
            name: 'Martina Flores',
            username: '@martina.loop',
          ),
          _PersonResult(
            userId: 102,
            name: 'Diego Rojas',
            username: '@diego.dev',
          ),
          _PersonResult(
            userId: 103,
            name: 'Camila Torres',
            username: '@camila.foodie',
          ),
        ] else if (filter == ExploreFilter.comunidades) ...<Widget>[
          _CommunityResult(
            communityId: 1,
            name: 'Running Santiago',
            members: '1.8k miembros',
          ),
          _CommunityResult(
            communityId: 2,
            name: 'Cine Club',
            members: '840 miembros',
          ),
          _CommunityResult(
            communityId: 3,
            name: 'Outdoor Chile',
            members: '1.4k miembros',
          ),
        ] else ...<Widget>[
          _EventResult(
            eventId: 6,
            name: 'Yoga al amanecer',
            meta: 'Hoy · Providencia',
          ),
          _EventResult(
            eventId: 5,
            name: 'Festival urbano',
            meta: 'Sab 25 · Santiago',
          ),
          _EventResult(
            eventId: 3,
            name: 'Taller de ceramica',
            meta: 'Mar 28 · Barrio Italia',
          ),
        ],
      ],
    );
  }
}

class _PersonResult extends StatelessWidget {
  const _PersonResult({
    required this.userId,
    required this.name,
    required this.username,
  });

  final int userId;
  final String name;
  final String username;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.person_outline,
      title: name,
      subtitle: username,
      action: 'Ver perfil',
      onAction: () => openUserProfile(context, userId),
    );
  }
}

class _CommunityResult extends StatelessWidget {
  const _CommunityResult({
    required this.communityId,
    required this.name,
    required this.members,
  });

  final int communityId;
  final String name;
  final String members;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.groups_outlined,
      title: name,
      subtitle: members,
      action: 'Ver',
      onAction: () => openCommunityDetail(context, communityId),
    );
  }
}

class _EventResult extends StatelessWidget {
  const _EventResult({
    required this.eventId,
    required this.name,
    required this.meta,
  });

  final int eventId;
  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      icon: Icons.event_available_outlined,
      title: name,
      subtitle: meta,
      action: 'Ver evento',
      onAction: () => openEventDetail(context, eventId),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.action,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAction,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.inputBackground,
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              action,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
