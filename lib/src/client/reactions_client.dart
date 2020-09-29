import 'package:stream_feed_dart/src/core/lookup_attribute.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/models/reaction_filter.dart';

abstract class ReactionsClient {
  Future<Reaction> add(
    String kind,
    String activityId,
    String userId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  });

  Future<Reaction> addChild(
    String kind,
    String parentId,
    String userId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  });

  Future<Reaction> get(String id);

  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    ReactionFilter filter,
    int limit = 10,
    String kind = '',
  });

  Future<PaginatedReactions> paginatedFilter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    ReactionFilter filter,
    int limit = 10,
    String kind = '',
  });

  Future<void> update(
    String reactionId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  });

  Future<void> delete(String id);
}
