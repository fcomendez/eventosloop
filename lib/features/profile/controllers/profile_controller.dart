import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/services/profile_mock_service.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileMockService? service, this.userId})
      : _service = service ?? ProfileMockService();

  final ProfileMockService _service;
  final int? userId;

  ProfileModel? _profile;
  List<ProfilePastEventModel> _allPastEvents = <ProfilePastEventModel>[];
  bool _loading = false;
  String? _error;
  bool _isFollowing = false;

  ProfileModel? get profile => _profile;
  List<ProfilePastEventModel> get allPastEvents => _allPastEvents;
  bool get loading => _loading;
  String? get error => _error;
  bool get isOwnProfile => userId == null;
  bool get isFollowing => _isFollowing;

  Future<void> loadProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = userId == null
          ? await _service.fetchProfile()
          : await _service.fetchProfileByUserId(userId!);
      _allPastEvents = await _service.fetchPastEvents(userId: userId);
      _isFollowing = _profile?.isFollowing ?? false;
    } catch (_) {
      _error = 'No se pudo cargar el perfil';
    }

    _loading = false;
    notifyListeners();
  }

  void toggleFollow() {
    _isFollowing = !_isFollowing;
    notifyListeners();
  }
}
