import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/models/paginated.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Reactions are a special kind of data that can be used
/// to capture user interaction with specific activities.
///
/// Common examples of reactions are likes, comments, and upvotes.
///
/// Reactions are automatically returned to feeds' activities at read time
/// when the reactions parameters are used.
class ReactionsClient {
  ///Initialize a reaction client
  ReactionsClient(this._reactions, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  ///User JWT Token
  final Token? userToken;

  ///The reactions client
  final ReactionsAPI _reactions;

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
    return _reactions.add(token, reaction);
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
    return _reactions.add(token, reaction);
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
    return _reactions.delete(token, id);
  }

  /// Get reaction
  /// [retrieving-reactions](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_introduction/?language=dart#retrieving-reactions)
  Future<Reaction> get(String id) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return _reactions.get(token, id);
  }

  ///Reactions can be updated by providing the reaction ID parameter.
  ///
  ///Changes to reactions are propagated to all notified feeds;
  ///
  ///if the target_feeds list is updated,
  ///notifications will be added and removed accordingly.
  ///# Examples
  ///```dart
  /// await client.reactions.update(
  ///   reaction.id,
  ///   data: {'text': 'love it!'},
  /// );
  ///```
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
    return _reactions.update(token, reaction);
  }

  /// You can read reactions and filter them
  /// based on their user_id or activity_id values.
  /// Further filtering can be done
  /// with the kind parameter (e.g. retrieve all likes by one user,
  ///  retrieve all comments for one activity, etc.).
  ///
  /// Reactions are returned in descending order (newest to oldest) by default
  /// and when using id_lt[e] , and in ascending order (oldest to newest)
  /// when using id_gt[e].
  /// # Examples
  /// - retrieve all kind of reactions for an activity
  /// ```dart
  /// var reactions = await client.reactions.filter(
  ///   LookupAttribute.activityId,
  ///   'ed2837a6-0a3b-4679-adc1-778a1704852d',
  /// );
  /// ```
  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return _reactions.filter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }

  //Server side functions
  ///paginated reactions and filter them
  Future<PaginatedReactions> paginatedFilter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return _reactions.paginatedFilter(token, lookupAttr, lookupValue,
        filter ?? Default.filter, limit ?? Default.limit, kind ?? '');
  }
}
