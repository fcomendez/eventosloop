import 'package:eventosloop/features/feed/models/feed_item_model.dart';
import 'package:eventosloop/features/feed/models/feed_page_result.dart';
import 'package:eventosloop/features/feed/services/feed_service.dart';
import 'package:flutter/foundation.dart';

class FeedController extends ChangeNotifier {
  FeedController({FeedService? service})
      : _service = service ?? FeedService();

  final FeedService _service;

  final List<FeedItemModel> _items = <FeedItemModel>[];
  int? _cursor;
  bool _loadingInitial = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;

  List<FeedItemModel> get items => List<FeedItemModel>.unmodifiable(_items);
  bool get loadingInitial => _loadingInitial;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadInitial() async {
    _loadingInitial = true;
    _error = null;
    _cursor = null;
    _items.clear();
    notifyListeners();

    try {
      final FeedPageResult result = await _service.fetchPage();
      _items.addAll(result.items);
      _cursor = result.nextCursor;
      _hasMore = result.hasMore;
    } catch (_) {
      _error = 'No se pudo cargar el feed';
    }

    _loadingInitial = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_loadingMore || _loadingInitial || !_hasMore) {
      return;
    }
    _loadingMore = true;
    notifyListeners();

    try {
      final FeedPageResult result = await _service.fetchPage(cursor: _cursor);
      final Set<int> currentIds =
          _items.map((FeedItemModel item) => item.id).toSet();
      _items.addAll(
        result.items.where((FeedItemModel item) => !currentIds.contains(item.id)),
      );
      _cursor = result.nextCursor;
      _hasMore = result.hasMore;
    } catch (_) {
      _error = 'No se pudo cargar mas contenido';
    }

    _loadingMore = false;
    notifyListeners();
  }

  Future<void> toggleLike(int id) async {
    final int index = _items.indexWhere((FeedItemModel item) => item.id == id);
    if (index == -1) {
      return;
    }
    final FeedItemModel current = _items[index];
    final bool wasLiked = current.likedByMe;

    _items[index] = FeedItemModel(
      id: current.id,
      type: current.type,
      author: current.author,
      publishedLabel: current.publishedLabel,
      title: current.title,
      body: current.body,
      contextLabel: current.contextLabel,
      mediaLabel: current.mediaLabel,
      mediaColorHex: current.mediaColorHex,
      mediaUrl: current.mediaUrl,
      likesCount: wasLiked ? current.likesCount - 1 : current.likesCount + 1,
      commentsCount: current.commentsCount,
      sharesCount: current.sharesCount,
      likedByMe: !wasLiked,
    );
    notifyListeners();

    try {
      await _service.toggleLike(
        postId: id,
        currentlyLiked: wasLiked,
      );
    } catch (_) {
      _items[index] = current;
      notifyListeners();
    }
  }
}
