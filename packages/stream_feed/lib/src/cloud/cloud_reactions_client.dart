import 'package:stream_feed_dart/src/core/index.dart';

abstract class CloudReactionsClient {
  Future<Reaction> add(
    String kind,
    String activityId,
    String userId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  });

  Future<Reaction> addChild(
    String kind,
    String parentId,
    String userId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  });

  Future<Reaction> get(String id);

  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  });

  Future<void> update(
    String reactionId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  });

  Future<void> delete(String id);
}
