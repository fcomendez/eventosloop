import 'package:eventosloop/features/profile/models/profile_model.dart';
import 'package:eventosloop/features/profile/services/profile_mock_service.dart';
import 'package:flutter/foundation.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({ProfileMockService? service})
      : _service = service ?? ProfileMockService();

  final ProfileMockService _service;

  ProfileModel? _profile;
  bool _loading = false;
  String? _error;

  ProfileModel? get profile => _profile;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.fetchProfile();
    } catch (_) {
      _error = 'No se pudo cargar el perfil';
    }

    _loading = false;
    notifyListeners();
  }
}
