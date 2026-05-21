import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/barra_interactiva.dart';
import 'package:eventosloop/features/feed/controllers/feed_controller.dart';
import 'package:eventosloop/features/feed/models/feed_item_model.dart';
import 'package:eventosloop/features/main_navigation/views/nav_placeholder_view.dart';
import 'package:flutter/material.dart';

class FeedHomeView extends StatefulWidget {
  const FeedHomeView({super.key, required this.email});

  final String email;

  @override
  State<FeedHomeView> createState() => _FeedHomeViewState();
}

class _FeedHomeViewState extends State<FeedHomeView> {
  final FeedController _controller = FeedController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final double threshold = _scrollController.position.maxScrollExtent - 280;
    if (_scrollController.position.pixels >= threshold) {
      _controller.loadMore();
    }
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
              const _FeedTopBar(),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    if (_controller.loadingInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (_controller.error != null && _controller.items.isEmpty) {
                      return _FeedErrorState(
                        message: _controller.error!,
                        onRetry: _controller.loadInitial,
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: _controller.loadInitial,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                        itemCount: _controller.items.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == _controller.items.length) {
                            return _FeedFooter(
                              loadingMore: _controller.loadingMore,
                              hasMore: _controller.hasMore,
                            );
                          }
                          final FeedItemModel item = _controller.items[index];
                          return _FeedPostCard(
                            item: item,
                            onLike: () => _controller.toggleLike(item.id),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              BarraInteractiva(
                selected: BarraInteractivaItem.inicio,
                onTap: (BarraInteractivaItem item) {
                  if (item == BarraInteractivaItem.inicio) {
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

class _FeedTopBar extends StatelessWidget {
  const _FeedTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(color: AppColors.divider.withValues(alpha: 0.45)),
        ),
      ),
      child: Row(
        children: <Widget>[
          const Text(
            'LOOP',
            style: TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  const _FeedPostCard({
    required this.item,
    required this.onLike,
  });

  final FeedItemModel item;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.16),
                  child: Text(
                    item.author.avatarInitials,
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.author.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${item.author.username} · ${item.publishedLabel}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _TypeChip(label: item.typeLabel),
              ],
            ),
          ),
          if (item.contextLabel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Text(
                item.contextLabel!,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          if (item.title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
              child: Text(
                item.title!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Text(
              item.body,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.35,
              ),
            ),
          ),
          if (item.mediaLabel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _MockMediaBlock(item: item),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                _ActionButton(
                  icon: item.likedByMe
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: '${item.likesCount}',
                  active: item.likedByMe,
                  onTap: onLike,
                ),
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  label: '${item.commentsCount}',
                  onTap: () {},
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send_outlined),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockMediaBlock extends StatelessWidget {
  const _MockMediaBlock({required this.item});

  final FeedItemModel item;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = _parseHex(item.mediaColorHex);
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            baseColor,
            AppColors.primaryDark.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.blur_on,
              color: AppColors.white.withValues(alpha: 0.16),
              size: 120,
            ),
          ),
          Center(
            child: Text(
              item.mediaLabel!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseHex(String? value) {
    final String clean = (value ?? '#D9EAF5').replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: 18,
        color: active ? AppColors.error : AppColors.textSecondary,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.error : AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FeedFooter extends StatelessWidget {
  const _FeedFooter({
    required this.loadingMore,
    required this.hasMore,
  });

  final bool loadingMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (loadingMore) {
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (!hasMore) {
      return const Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Text(
            'No hay mas publicaciones por ahora',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }
    return const SizedBox(height: 18);
  }
}

class _FeedErrorState extends StatelessWidget {
  const _FeedErrorState({
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
            const SizedBox(height: 14),
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
