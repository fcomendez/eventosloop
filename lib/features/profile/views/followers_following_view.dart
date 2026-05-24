import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:eventosloop/core/widgets/loop_user_avatar.dart';
import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/services/profile_mock_service.dart';
import 'package:eventosloop/features/profile/services/profile_supabase_service.dart';
import 'package:flutter/material.dart';

class FollowersFollowingView extends StatefulWidget {
  const FollowersFollowingView({
    super.key,
    required this.initialTab,
    required this.followersCount,
    required this.followingCount,
    this.userId,
  });

  final int initialTab;
  final int followersCount;
  final int followingCount;
  final int? userId;

  @override
  State<FollowersFollowingView> createState() => _FollowersFollowingViewState();
}

class _FollowersFollowingViewState extends State<FollowersFollowingView> {
  final ProfileSupabaseService _supabaseService = ProfileSupabaseService();
  final ProfileMockService _mockService = ProfileMockService();
  final TextEditingController _searchController = TextEditingController();
  final List<ProfileConnectionModel> _followers = <ProfileConnectionModel>[];
  final List<ProfileConnectionModel> _following = <ProfileConnectionModel>[];

  late int _selectedTab;
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _load();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.userId != null) {
      final List<ProfileConnectionModel> followers =
          await _supabaseService.fetchFollowers(widget.userId!);
      final List<ProfileConnectionModel> following =
          await _supabaseService.fetchFollowing(widget.userId!);
      if (!mounted) {
        return;
      }
      setState(() {
        _followers
          ..clear()
          ..addAll(followers);
        _following
          ..clear()
          ..addAll(following);
        _loading = false;
      });
      return;
    }

    final List<ProfileConnectionModel> followers =
        await _mockService.fetchFollowers();
    final List<ProfileConnectionModel> following =
        await _mockService.fetchFollowing();
    if (!mounted) {
      return;
    }
    setState(() {
      _followers
        ..clear()
        ..addAll(followers);
      _following
        ..clear()
        ..addAll(following);
      _loading = false;
    });
  }

  List<ProfileConnectionModel> get _visibleItems {
    final List<ProfileConnectionModel> source =
        _selectedTab == 0 ? _followers : _following;
    if (_query.isEmpty) {
      return source;
    }
    return source
        .where(
          (ProfileConnectionModel item) =>
              item.name.toLowerCase().contains(_query) ||
              item.username.toLowerCase().contains(_query),
        )
        .toList();
  }

  void _toggleFollow(ProfileConnectionModel item) {
    final List<ProfileConnectionModel> source =
        _selectedTab == 0 ? _followers : _following;
    final int index = source.indexWhere(
      (ProfileConnectionModel current) => current.id == item.id,
    );
    if (index == -1) {
      return;
    }
    setState(() {
      source[index] = ProfileConnectionModel(
        id: item.id,
        name: item.name,
        username: item.username,
        avatarInitials: item.avatarInitials,
        isFollowing: !item.isFollowing,
        isOnline: item.isOnline,
      );
    });
  }

  void _removeFollower(ProfileConnectionModel item) {
    setState(() {
      _followers.removeWhere(
        (ProfileConnectionModel current) => current.id == item.id,
      );
    });
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
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: _tabSelector(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _selectedTab == 0
                        ? 'Buscar seguidores...'
                        : 'Buscar seguidos...',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: const Color(0xFFE4EEF9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                        itemCount: _visibleItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ProfileConnectionModel item =
                              _visibleItems[index];
                          return _ConnectionCard(
                            item: item,
                            isFollowersTab: _selectedTab == 0,
                            onToggleFollow: () => _toggleFollow(item),
                            onRemove: () => _removeFollower(item),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 4),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          const Text(
            'Conexiones',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabSelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: <Widget>[
          _tabButton(
            index: 0,
            label: 'Seguidores',
            count: widget.followersCount,
          ),
          _tabButton(
            index: 1,
            label: 'Siguiendo',
            count: widget.followingCount,
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required int index,
    required String label,
    required int count,
  }) {
    final bool active = _selectedTab == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: active
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            '$label  ${_formatCount(count)}',
            style: TextStyle(
              color: active ? AppColors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({
    required this.item,
    required this.isFollowersTab,
    required this.onToggleFollow,
    required this.onRemove,
  });

  final ProfileConnectionModel item;
  final bool isFollowersTab;
  final VoidCallback onToggleFollow;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              LoopUserAvatar(
                avatarUrl: item.avatarUrl,
                initials: item.avatarInitials,
                radius: 25,
              ),
              if (item.isOnline)
                Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF28C76F),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  item.username,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _actionButton(),
        ],
      ),
    );
  }

  Widget _actionButton() {
    if (isFollowersTab && item.isFollowing) {
      return OutlinedButton(
        onPressed: onRemove,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text('Remove'),
      );
    }
    return ElevatedButton(
      onPressed: onToggleFollow,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: item.isFollowing ? AppColors.inputBackground : AppColors.primary,
        foregroundColor: item.isFollowing ? AppColors.textSecondary : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(item.isFollowing ? 'Following' : 'Follow'),
    );
  }
}
