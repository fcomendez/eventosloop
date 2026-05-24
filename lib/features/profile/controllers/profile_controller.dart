import 'package:eventosloop/core/config/supabase_runtime.dart';
import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/services/profile_mock_service.dart';
import 'package:eventosloop/features/profile/services/profile_supabase_service.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileMockService? service, this.userId})
      : _service = service ?? ProfileMockService(),
        _supabaseService = ProfileSupabaseService();

  final ProfileMockService _service;
  final ProfileSupabaseService _supabaseService;
  final int? userId;

  ProfileModel? _profile;
  List<ProfilePastEventModel> _allPastEvents = <ProfilePastEventModel>[];
  bool _loading = false;
  String? _error;
  bool _isFollowing = false;
  int? _targetUserId;

  ProfileModel? get profile => _profile;
  List<ProfilePastEventModel> get allPastEvents => _allPastEvents;
  bool get loading => _loading;
  String? get error => _error;
  bool get isOwnProfile => userId == null;
  bool get isFollowing => _isFollowing;
  int? get targetUserId => _targetUserId;

  Future<void> loadProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      if (supabaseLive) {
        final int? targetId = userId ?? await _resolveCurrentUserId();
        if (targetId != null) {
          final ProfileModel? fromDb =
              await _supabaseService.fetchFullProfile(targetId);
          if (fromDb != null) {
            _profile = fromDb;
            _targetUserId = fromDb.userId;
            _allPastEvents = await _supabaseService.fetchPastEvents(targetId);
            _isFollowing = fromDb.isFollowing;
            _loading = false;
            notifyListeners();
            return;
          }
        }
        _error = 'No se pudo cargar el perfil';
      } else if (allowMockFallback) {
        _profile = userId == null
            ? await _service.fetchProfile()
            : await _service.fetchProfileByUserId(userId!);
        _allPastEvents = await _service.fetchPastEvents(userId: userId);
        _targetUserId = _profile?.userId;
        _isFollowing = _profile?.isFollowing ?? false;
      } else {
        _error = 'Supabase no esta configurado';
      }
    } catch (_) {
      _error = 'No se pudo cargar el perfil';
    }

    _loading = false;
    notifyListeners();
  }

  Future<int?> _resolveCurrentUserId() async {
    final ProfileHeaderData? header =
        await _supabaseService.fetchCurrentUserHeader();
    return header?.userId;
  }

  Future<void> toggleFollow() async {
    if (_targetUserId == null || isOwnProfile) {
      return;
    }

    if (supabaseLive) {
      try {
        await _supabaseService.toggleFollow(_targetUserId!);
        await loadProfile();
        return;
      } catch (_) {}
    } else if (allowMockFallback) {
      _isFollowing = !_isFollowing;
      notifyListeners();
    }
  }
}
