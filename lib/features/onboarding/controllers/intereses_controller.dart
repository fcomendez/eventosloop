import 'package:eventosloop/features/onboarding/models/interes_model.dart';
import 'package:eventosloop/features/onboarding/services/intereses_service.dart';
import 'package:flutter/foundation.dart';

class InteresesController extends ChangeNotifier {
  InteresesController({InteresesService? service})
      : _service = service ?? InteresesService();

  final InteresesService _service;

  static const int minimoIntereses = 5;

  List<InteresModel> _intereses = const <InteresModel>[];
  final Set<int> _seleccionados = <int>{};
  bool _cargando = false;
  bool _guardando = false;
  String? _error;

  List<InteresModel> get intereses => _intereses;
  Set<int> get seleccionados => _seleccionados;
  bool get cargando => _cargando;
  bool get guardando => _guardando;
  String? get error => _error;
  int get cantidadSeleccionados => _seleccionados.length;
  bool get puedeAvanzar => _seleccionados.length >= minimoIntereses;
  bool puedeGuardarConMinimo(int minimo) => _seleccionados.length >= minimo;
  bool alcanzoMaximo(int maximo) => _seleccionados.length >= maximo;

  List<String> get categorias {
    final Set<String> cats = <String>{};
    for (final InteresModel i in _intereses) {
      cats.add(i.categoria);
    }
    return cats.toList();
  }

  List<InteresModel> interesesPorCategoria(String categoria) {
    return _intereses
        .where((InteresModel i) => i.categoria == categoria)
        .toList();
  }

  Future<void> cargarIntereses() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    _intereses = await _service.obtenerIntereses();
    final List<int> previos = await _service.obtenerInteresesUsuario();
    _seleccionados.addAll(previos);

    if (_intereses.isEmpty) {
      _error = 'No se pudieron cargar los intereses';
    }

    _cargando = false;
    notifyListeners();
  }

  bool toggleInteres(int idInteres, {int? maximo}) {
    if (_seleccionados.contains(idInteres)) {
      _seleccionados.remove(idInteres);
    } else if (maximo == null || _seleccionados.length < maximo) {
      _seleccionados.add(idInteres);
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  bool estaSeleccionado(int idInteres) => _seleccionados.contains(idInteres);

  Future<bool> guardarSeleccion() async {
    if (!puedeAvanzar) {
      return false;
    }
    return guardarSeleccionConMinimo(minimoIntereses);
  }

  Future<bool> guardarSeleccionConMinimo(int minimo) async {
    if (!puedeGuardarConMinimo(minimo)) {
      return false;
    }
    _guardando = true;
    notifyListeners();

    final bool ok = await _service.guardarIntereses(_seleccionados);

    _guardando = false;
    if (!ok) {
      _error = 'No se pudieron guardar los intereses';
    }
    notifyListeners();
    return ok;
  }
}
