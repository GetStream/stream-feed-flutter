import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/lookup_attribute.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/models/reaction.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class ReactionsClientImpl implements ReactionsClient {
  final String secret;
  final ReactionsApi reactions;

  const ReactionsClientImpl(this.secret, this.reactions);

  @override
  Future<Reaction> add(
    String kind,
    String activityId,
    String userId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  }) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.write);
    final reaction = Reaction(
      kind: kind,
      activityId: activityId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds,
    );
    return reactions.add(token, reaction);
  }

  @override
  Future<Reaction> addChild(
    String kind,
    String parentId,
    String userId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  }) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.write);
    final reaction = Reaction(
      kind: kind,
      parent: parentId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds,
    );
    return reactions.add(token, reaction);
  }

  @override
  Future<void> delete(String id) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.delete);
    return reactions.delete(token, id);
  }

  @override
  Future<Reaction> get(String id) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.read);
    return reactions.get(token, id);
  }

  @override
  Future<void> update(
    String reactionId, {
    Map<String, Object> data,
    Iterable<FeedId> targetFeeds,
  }) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.write);
    final reaction = Reaction(
      id: reactionId,
      data: data,
      targetFeeds: targetFeeds,
    );
    return reactions.update(token, reaction);
  }

  @override
  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter filter,
    int limit,
    String kind,
  }) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.read);
    return reactions.filter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }

  @override
  Future<PaginatedReactions> paginatedFilter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter filter,
    int limit,
    String kind,
  }) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.read);
    return reactions.paginatedFilter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }
}
