import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';

class CloudReactionsClient {
  const CloudReactionsClient(this.token, this.reactions);
  final Token token;
  final ReactionsApi reactions;

  @override
  Future<Reaction> add(
    String kind,
    String activityId,
    String userId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      kind: kind,
      activityId: activityId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds as List<FeedId>?,
    );
    return reactions.add(token, reaction);
  }

  @override
  Future<Reaction> addChild(
    String kind,
    String parentId,
    String userId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      kind: kind,
      parent: parentId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds as List<FeedId>?,
    );
    return reactions.add(token, reaction);
  }

  @override
  Future<void> delete(String id) => reactions.delete(token, id);

  @override
  Future<Reaction> get(String id) => reactions.get(token, id);

  @override
  Future<void> update(
    String reactionId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      id: reactionId,
      data: data,
      targetFeeds: targetFeeds as List<FeedId>?,
    );
    return reactions.update(token, reaction);
  }

  @override
  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  }) =>
      reactions.filter(token, lookupAttr, lookupValue, filter ?? Default.filter,
          limit ?? Default.limit, kind ?? '');
}
