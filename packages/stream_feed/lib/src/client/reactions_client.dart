import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Provides methods for reacting to Activities.
///
/// {@template reactions}
/// Reactions are a special kind of data that can be used
/// to capture user interaction with specific activities.
///
/// Common examples of reactions are likes, comments, and upvotes.
///
/// Reactions are automatically returned to feeds' activities at read time
/// when the reactions parameters are used.
/// {@endtemplate}
class ReactionsClient {
  ///Initialize a reaction client
  const ReactionsClient(this._reactions, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  /// User JWT
  final Token? userToken;

  /// The reactions client
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
  ///  userId: 'john-doe',
  ///   data: {'text': 'awesome post!'},
  /// );
  ///```
  ///
  /// API docs: [adding-reactions](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_introduction/?language=dart#adding-reactions)
  Future<Reaction> add(
    String kind,
    String activityId, {
    String? userId,
    Map<String, Object>? data,
    List<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      kind: kind,
      activityId: activityId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds,
    );
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.write);
    return _reactions.add(token, reaction);
  }

  /// A reaction can also be added to another reaction; in this case,
  /// a child reaction is created. Child reactions are created
  /// in the same way as regular reactions but have a few crucial differences:
  ///
  ///     Child reactions are not part of the parent activity counts
  ///     Child reactions are only returned when the parent is returned
  ///     In order to paginate over reactions,
  /// you need to filter using the parent reaction ID
  ///     Recent children reactions and their counts
  /// are added to the parent reaction body
  ///
  /// Reaction nesting is limited. The deepest level
  /// where you can insert your child reaction is 3.
  ///
  /// Let's take an example: Bob creates an activity
  ///
  ///     Alice comments on this activity
  ///     Bob comments on Alice's comment
  ///     Carl comments on Bob's comment.
  ///
  /// Carl's comment is at the maximum third nesting level,
  /// so Alice can't like or comment on Carl's comment because it would be
  /// the fourth level of nesting.
  ///
  /// ## Example:
  /// Adds a like to the previously created comment
  ///` ``dart
  /// final reaction = await client.reactions.addChild(
  ///   'like',
  ///   comment.id,
  ///   'john-doe',
  /// );
  ///```
  ///
  /// API docs: [reactions_add_child](https://getstream.io/activity-feeds/docs/flutter-dart/reactions_add_child/?language=dart)
  Future<Reaction> addChild(
    String kind,
    String parentId, {
    String? userId,
    Map<String, Object>? data,
    List<FeedId>? targetFeeds,
  }) async {
    final reaction = Reaction(
      kind: kind,
      parent: parentId,
      userId: userId,
      data: data,
      targetFeeds: targetFeeds,
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

  /// Reactions can be updated by providing the reaction ID parameter.
  ///
  /// Changes to reactions are propagated to all notified feeds;
  ///
  /// if the target_feeds list is updated,
  /// notifications will be added and removed accordingly.
  /// # Examples
  /// ```dart
  /// await client.reactions.update(
  ///   reaction.id,
  ///   data: {'text': 'love it!'},
  /// );
  ///```
  Future<Reaction> update(
    String reactionId, {
    Map<String, Object>? data,
    List<FeedId>? targetFeeds,
  }) {
    final reaction = Reaction(
      id: reactionId,
      data: data,
      targetFeeds: targetFeeds,
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
  ///
  /// {@macro filter}
  Future<List<Reaction>> filter(
    LookupAttribute lookupAttr,
    String lookupValue, {
    //TODO: check if it is a valid UUID with package uuid isValidUUID
    Filter? filter,
    EnrichmentFlags? flags,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    final options = {
      'limit': limit ?? Default.limit,
      ...filter?.params ?? Default.filter.params,
      if (flags != null) ...flags.params,
      'with_activity_data': lookupAttr == LookupAttribute.activityId,
    };
    return _reactions.filter(
      token,
      lookupAttr,
      lookupValue,
      filter ?? Default.filter,
      limit ?? Default.limit,
      kind ?? '',
      options,
    );
  }

  //------------------------- Server side methods ----------------------------//
  /// Paginated reactions and filter them
  ///
  /// {@macro filter}
  Future<PaginatedReactions<A, Ob, T, Or>> paginatedFilter<A, Ob, T, Or>(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    EnrichmentFlags? flags,
    int? limit,
    String? kind,
  }) {
    final token =
        userToken ?? TokenHelper.buildReactionToken(secret!, TokenAction.read);
    return _reactions.paginatedFilter<A, Ob, T, Or>(
      token,
      lookupAttr,
      lookupValue,
      filter ?? Default.filter,
      flags,
      limit ?? Default.limit,
      kind ?? '',
    );
  }
}
