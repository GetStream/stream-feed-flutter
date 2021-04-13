import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

/// Manage api calls for all things related to reactions
/// The ReactionsClientImpl object contains convenient functions
/// such add, delete, get, update ... reactions
class ReactionsClient {
  ///Initialize a reaction client
  ReactionsClient(this.reactions, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );
  final Token? userToken;

  final ReactionsApi reactions;

  /// Your API secret. You can get it in your Stream Dashboard [here](https://dashboard.getstream.io/dashboard/v2/)
  final String? secret;

  /// Add reaction
  ///
  /// Parameters:
  /// [kind] : kind of reaction
  /// [activityId] :  an ActivityID
  /// [data] : extra data related to target feeds
  /// [targetFeeds] : an array of feeds to which to send
  /// an activity with the reaction
  ///
  /// Examples:
  /// - Add a like reaction to the activity
  /// with id activityId
  ///
  /// ```dart
  /// final like = await client.reactions.add('like', activity.id, 'john-doe');
  /// ```
  /// - Add a comment reaction to the activity with id activityId
  ///```dart
  /// final comment = await client.reactions.add(
  ///   'comment',
  ///   activity.id,
  ///   'john-doe',
  ///   data: {'text': 'awesome post!'},
  /// );
  ///```
  ///
  /// API docs: [adding-reactions](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_introduction/?language=dart#adding-reactions)
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
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.write);
    return reactions.add(token, reaction);
  }

  /// Adds a like to the previously created comment
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
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.write);
    return reactions.add(token, reaction);
  }

  /// Delete reaction
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
  Future<void> delete(String id) {
    final token = userToken ??
        TokenHelper.buildReactionToken(secret!, TokenAction.delete);
    return reactions.delete(token, id);
  }

  /// Get reaction
  /// [retrieving-reactions](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_introduction/?language=dart#retrieving-reactions)
  Future<Reaction> get(String id) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return reactions.get(token, id);
  }

  Future<void> update(
    String? reactionId, {
    Map<String, Object>? data,
    Iterable<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      id: reactionId,
      data: data,
      targetFeeds: targetFeeds as List<FeedId>?,
    );
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.write);
    return reactions.update(token, reaction);
  }

  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return reactions.filter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }

  //Server side functions
  Future<PaginatedReactions> paginatedFilter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return reactions.paginatedFilter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }
}
