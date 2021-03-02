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
  ///Initialize a reaction client
  const ReactionsClientImpl(this.secret, this.reactions);

  /// Your API secret. You can get it in your Stream Dashboard [here](https://dashboard.getstream.io/dashboard/v2/)
  final String secret;
  final ReactionsApi reactions;

  /// add reaction
  ///
  /// Examples:
  /// - add a like reaction to the activity with id activityId
  // ignore: lines_longer_than_80_chars
  /// ```dart
  /// final like = await client.reactions.add('like', activity.id, 'john-doe');
  /// ```
  /// - adds a comment reaction to the activity with id activityId
  ///```dart
  /// final comment = await client.reactions.add(
  ///   'comment',
  ///   activity.id,
  ///   'john-doe',
  ///   data: {'text': 'awesome post!'},
  /// );
  ///```
  ///
  ///API docs:

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

  /// adds a like to the previously created comment
  ///
  ///Example:
  ///```dart
  ///final reaction = await client.reactions.addChild(
  ///'like',
  ///comment.id,
  ///'john-doe',
  ///);
  ///```
  ///
  /// API docs: [reactions_add_child](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_add_child/?language=dart)
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

  /// delete reaction
  ///
  /// It takes in parameters:
  /// - [id] : Reaction Id
  ///
  /// Example:
  /// ```dart
  /// reactions.delete("67b3e3b5-b201-4697-96ac-482eb14f88ec");
  /// ```
  ///
  /// API docs: [removing-reactions](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_introduction/?language=dart#removing-reactions)
  @override
  Future<void> delete(String id) {
    final token = TokenHelper.buildReactionToken(secret, TokenAction.delete);
    return reactions.delete(token, id);
  }

  /// get reaction
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
