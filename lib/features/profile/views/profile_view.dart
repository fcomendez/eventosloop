import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:eventosloop/features/profile/controllers/profile_controller.dart';
import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/views/followers_following_view.dart';
import 'package:eventosloop/features/profile/views/profile_settings_view.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _controller = ProfileController();
  int _selectedSection = 0;

  @override
  void initState() {
    super.initState();
    _controller.loadProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0xFFF5F0F8), Color(0xFFEAF4FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _topBar(),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    if (_controller.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final ProfileModel? profile = _controller.profile;
                    if (profile == null) {
                      return _ErrorState(
                        message: _controller.error ?? 'No se pudo cargar el perfil',
                        onRetry: _controller.loadProfile,
                      );
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _ProfileHeader(
                            profile: profile,
                            onFollowersTap: () => _openConnections(
                              initialTab: 0,
                              profile: profile,
                            ),
                            onFollowingTap: () => _openConnections(
                              initialTab: 1,
                              profile: profile,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _SectionSelector(
                            selected: _selectedSection,
                            onChanged: (int value) {
                              setState(() {
                                _selectedSection = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          if (_selectedSection == 0)
                            _ImageGrid(posts: profile.imagePosts)
                          else if (_selectedSection == 1)
                            _WrittenPosts(posts: profile.writtenPosts)
                          else
                            _StatsSection(profile: profile),
                        ],
                      ),
                    );
                  },
                ),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.perfil,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.perfil) {
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

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Text(
              'LOOP',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfileSettingsView(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }

  void _openConnections({
    required int initialTab,
    required ProfileModel profile,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FollowersFollowingView(
          initialTab: initialTab,
          followersCount: profile.followersCount,
          followingCount: profile.followingCount,
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final ProfileModel profile;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF0E3554), Color(0xFFB8DFF6)],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  profile.avatarInitials,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          profile.fullName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          profile.username,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _Counter(label: 'Posts', value: '${profile.postsCount}'),
            _Counter(
              label: 'Seguidores',
              value: _formatCount(profile.followersCount),
              onTap: onFollowersTap,
            ),
            _Counter(
              label: 'Siguiendo',
              value: '${profile.followingCount}',
              onTap: onFollowingTap,
            ),
          ],
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$value';
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionSelector extends StatelessWidget {
  const _SectionSelector({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          _button(index: 0, icon: Icons.grid_on, label: 'Imagenes'),
          _button(index: 1, icon: Icons.article_outlined, label: 'Escritos'),
          _button(index: 2, icon: Icons.bar_chart, label: 'Stats'),
        ],
      ),
    );
  }

  Widget _button({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool active = selected == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: active ? AppColors.white : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: active ? AppColors.white : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.posts});

  final List<ProfileImagePostModel> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        final ProfileImagePostModel post = posts[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                _parseHex(post.colorHex),
                AppColors.primaryDark.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: Center(
            child: Text(
              post.label,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _parseHex(String hex) {
    return Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
  }
}

class _WrittenPosts extends StatelessWidget {
  const _WrittenPosts({required this.posts});

  final List<ProfileWrittenPostModel> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: posts.map((ProfileWrittenPostModel post) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.divider,
                    child: Icon(Icons.person, size: 16, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    post.authorName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '· ${post.publishedLabel}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                post.body,
                style: const TextStyle(color: AppColors.textPrimary, height: 1.35),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Icon(Icons.favorite_border, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${post.likesCount}'),
                  const SizedBox(width: 14),
                  const Icon(Icons.mode_comment_outlined, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${post.commentsCount}'),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _SectionTitle(title: 'Intereses'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.interests
              .map(
                (String interest) => Chip(
                  label: Text(interest),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 18),
        const _SectionTitle(title: 'Actividad'),
        _ActivityCard(
          icon: Icons.event_available_outlined,
          title: 'Eventos participados',
          subtitle: 'Historial de participacion',
          value: '${profile.eventsAttendedCount}',
        ),
        _ActivityCard(
          icon: Icons.groups_outlined,
          title: 'Comunidades activas',
          subtitle: 'Membresias vigentes',
          value: '${profile.communitiesJoinedCount}',
        ),
        const SizedBox(height: 18),
        Row(
          children: <Widget>[
            const Expanded(child: _SectionTitle(title: 'Eventos asistidos')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Total: ${profile.pastEvents.length}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        ...profile.pastEvents.map(
          (ProfilePastEventModel event) => _PastEventCard(event: event),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryDark),
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
                    fontWeight: FontWeight.w800,
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
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PastEventCard extends StatelessWidget {
  const _PastEventCard({required this.event});

  final ProfilePastEventModel event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abrir detalle: ${event.title}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.divider.withValues(alpha: 0.65)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _eventIcon(event.category),
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${event.month} ${event.day}, 2026',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.groups_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.check_circle, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  IconData _eventIcon(String category) {
    final String normalized = category.toLowerCase();
    if (normalized.contains('tecnologia')) {
      return Icons.terminal;
    }
    if (normalized.contains('deporte')) {
      return Icons.directions_run;
    }
    if (normalized.contains('cultura')) {
      return Icons.public;
    }
    if (normalized.contains('ajedrez')) {
      return Icons.extension;
    }
    return Icons.event_available_outlined;
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
