import 'package:eventosloop/features/feed/models/feed_item_model.dart';

class FeedPageResult {
  const FeedPageResult({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  final List<FeedItemModel> items;
  final int? nextCursor;
  final bool hasMore;
}
