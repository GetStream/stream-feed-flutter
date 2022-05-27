import 'package:faye_dart/faye_dart.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_update.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/follow.dart';
import 'package:stream_feed/src/core/models/follow_stats.dart';
import 'package:stream_feed/src/core/models/followers.dart';
import 'package:stream_feed/src/core/models/following.dart';
import 'package:stream_feed/src/core/models/realtime_message.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// A type definition for the callback to be invoked when data is received.
typedef MessageDataCallback = void Function(Map<String, dynamic>? data);

/// A type definition for the callback to be invoked when a message is received.
typedef FeedSubscriber = Future<Subscription> Function(
  Token token,
  FeedId feedId,
  MessageDataCallback callback,
);

///{@template feed}
/// The feed object contains convenient functions for manipulating feeds,
/// such as add activity, remove activity, etc.
///{@endtemplate}
class Feed {
  ///Initialize a feed object
  const Feed(
    this.feedId,
    this.feed, {
    this.userToken,
    this.secret,
    this.subscriber,
  }) : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  final FeedSubscriber? subscriber;

  /// Your API secret
  @protected
  final String? secret;

  /// Your user token obtain via the dashboard.
  /// Required if you are using the sdk client side
  @protected
  final Token? userToken;

  /// The feed id
  @protected
  final FeedId feedId;

  /// The stream client this feed is constructed from
  @protected
  final FeedAPI feed;

  /// Subscribes to any changes in the feed, return a [Subscription]
  @experimental
  Future<Subscription> subscribe<A, Ob, T, Or>(
    void Function(RealtimeMessage<A, Ob, T, Or>? message) callback,
  ) {
    checkNotNull(
      subscriber,
      'A subscriber must me provided in order to start listening to a feed',
    );
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);

    return subscriber!(token, feedId, (data) {
      final realtimeMessage = RealtimeMessage<A, Ob, T, Or>.fromJson(
        data!,
      );
      callback(realtimeMessage);
    });
  }

  /// Retrieves the number of followers
  /// and following feed stats of the current feed.
  ///
  /// For each count, feed slugs can be provided to filter counts accordingly.
  /// Example:
  /// ```dart
  /// await client.feed.followStats(followerSlugs:['user', 'news'], followingSlugs:['timeline']);
  /// ```
  Future<FollowStats> followStats({
    List<String>? followingSlugs,
    List<String>? followerSlugs,
  }) {
    final options = FollowStats(
      following: Following(
        feed: feedId,
        slugs: followingSlugs,
      ),
      followers: Followers(
        feed: feedId,
        slugs: followerSlugs,
      ),
    );
    final token =
        userToken ?? TokenHelper.buildFollowToken(secret!, TokenAction.any);
    return feed.followStats(token, options.toJson());
  }

  /// Adds the given [Activity] to the feed
  /// parameters:
  /// [activity] : The activity to add
  ///
  /// # Example
  /// ```dart
  ///  final activity = Activity(
  ///    actor: user.id,
  ///    verb: 'tweet',
  ///    object: '1',
  ///    extraData: {
  ///      'tweet': message,
  ///    },
  ///  );
  /// await userFeed.addActivity(activity);
  /// ```
  ///
  /// API docs: [adding-activities-basic](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#adding-activities-basic)
  Future<Activity> addActivity(Activity activity) {
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.write, feedId);
    return feed.addActivity(token, feedId, activity);
  }

  /// Adds the given activities to the feed
  ///
  /// # Usage :
  /// ```dart
  /// final activities = <Activity>[
  ///   const Activity(
  ///     actor: 'user:1',
  ///     verb: 'tweet',
  ///     object: 'tweet:1',
  ///   ),
  ///   const Activity(
  ///     actor: 'user:2',
  ///     verb: 'watch',
  ///     object: 'movie:1',
  ///   ),
  /// ];
  /// await userFeed.addActivities(activities);
  /// ```
  /// API docs : [batch-add-activities](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-add-activities)
  Future<List<Activity>> addActivities(Iterable<Activity> activities) {
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.write, feedId);
    return feed.addActivities(token, feedId, activities);
  }

  /// Removes the activity by `activityId` or `foreignId`
  ///
  /// parameters
  /// [id] : activityId Identifier of activity to remove
  ///
  /// # Usage:
  /// ```dart
  /// await userFeed.removeActivityById('e561de8f-00f1-11e4-b400-0cc47a024be0');
  /// ```
  /// API docs: [removing-activities](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#removing-activities)
  Future<void> removeActivityById(String id) {
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.delete, feedId);
    return feed.removeActivityById(token, feedId, id);
  }

  /// Remove an [Activity] by referencing its `foreign_id`
  ///
  /// Parameters:
  /// `foreignId`: Identifier of activity to remove
  ///
  /// For example :
  /// ```dart
  /// final chris = client.flatFeed('user', 'chris');
  /// await chris.removeActivityByForeignId('picture:10');
  /// ```
  ///
  /// API docs: [removing-activities](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#removing-activities)
  Future<void> removeActivityByForeignId(String foreignId) {
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.delete, feedId);
    return feed.removeActivityByForeignId(token, feedId, foreignId);
  }

  /// Follows the given target feed
  ///
  /// Parameters:
  ///
  /// [flatFeet] : Slug of the target feed
  /// [activityCopyLimit] : Limit the amount of activities copied over on follow
  ///
  /// For example, to create a following relationship
  /// between Jack's "timeline" feed and Chris' "user" feed
  /// you'd do the following
  /// ```dart
  /// final jack = client.flatFeed('timeline', 'jack');
  /// await jack.follow(chris);
  /// ```
  ///
  /// API docs: [following](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart)
  Future<void> follow(
    FlatFeed flatFeed, {
    int? activityCopyLimit,
  }) async {
    final token = userToken ??
        TokenHelper.buildFollowToken(secret!, TokenAction.write, feedId);
    final targetToken = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, flatFeed.feedId);
    await feed.follow(token, targetToken, feedId, flatFeed.feedId,
        activityCopyLimit ?? Default.activityCopyLimit);
  }

  /// List the followers of this feed
  ///
  /// Parameters:
  /// [offset] : pagination offset
  /// [limit] : limit offset
  ///
  /// Usage:
  /// ```dart
  /// final followers = await userFeed.followers(limit: 10, offset: 0);
  /// ```
  ///
  /// API docs: [reading-feed-followers](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart#reading-feed-followers)
  Future<List<Follow>> followers({
    Iterable<FeedId>? feedIds,
    int? limit,
    int? offset,
    String? session,
  }) {
    final token = userToken ??
        TokenHelper.buildFollowToken(secret!, TokenAction.read, feedId);
    return feed.followers(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, feedIds ?? []);
  }

  /// List which feeds this feed is following
  ///
  /// - Retrieve last 10 feeds followed by user
  /// ```dart
  /// var followed = await userFeed.getFollowed(limit: 10, offset: 0);
  /// ```
  ///
  /// - Retrieve 10 feeds followed by user starting from the 11th
  /// ```dart
  /// followed = await userFeed.getFollowed(limit: 10, offset: 10);
  /// ```
  ///
  /// - Check if user follows specific feeds
  /// ```dart
  /// following = await userFeed.following(limit: 2, offset: 0, feedIds: [
  ///   FeedId.id('user:42'),
  ///   FeedId.id('user:43'),
  /// ]);
  /// ```
  /// {@macro filter}
  /// API docs: [reading-followed-feeds](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart#reading-followed-feeds)
  Future<List<Follow>> following({
    Iterable<FeedId>? filter,
    int? limit,
    int? offset,
    String? session,
  }) {
    final token = userToken ??
        TokenHelper.buildFollowToken(secret!, TokenAction.read, feedId);
    return feed.following(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, filter ?? []);
  }

  /// Unfollow the given feed
  ///
  /// Parameters:
  /// - [flatFeet] : Slug of the target feed
  /// - [keepHistory] when provided the activities from target
  /// feed will not be kept in the feed
  ///
  /// For example:
  /// - Stop following feed user:user_42
  /// ```dart
  /// await timeline.unfollow(user);
  /// ```
  /// - Stop following feed user:user_42 but keep history of activities
  /// ```dart
  /// await timeline.unfollow(user, keepHistory: true);
  /// ```
  ///
  /// API docs: [unfollowing-feeds](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart#unfollowing-feeds)
  Future<void> unfollow(
    FlatFeed flatFeet, {
    bool keepHistory = false,
  }) {
    final token = userToken ??
        TokenHelper.buildFollowToken(secret!, TokenAction.delete, feedId);
    return feed.unfollow(
      token,
      feedId,
      flatFeet.feedId,
      keepHistory: keepHistory,
    );
  }

  /// Updates an activity's [Activity.to] fields
  ///
  /// Parameters:
  ///
  /// - [update]: the [Activity] to update
  /// - [remove]: Remove these targets from the activity
  /// - [add] : Add these new targets to the activity
  ///
  /// For example:
  /// ```dart
  /// final add = <FeedId>[];
  /// final remove = <FeedId>[];
  /// await userFeed.updateActivityToTargets(update, add, remove);
  /// ```
  ///
  /// API docs: [targeting](https://getstream.io/activity-feeds/docs/flutter-dart/targeting/?language=dart)
  Future<void> updateActivityToTargets(
      ActivityUpdate update, Iterable<FeedId> add, Iterable<FeedId> remove) {
    final token = userToken ??
        TokenHelper.buildToTargetUpdateToken(
            secret!, TokenAction.write, feedId);
    return feed.updateActivityToTargets(token, feedId, update,
        add: add, remove: remove);
  }

  /// Replace [Activity.to] Targets
  /// Usage:
  /// ```dart
  /// await userFeed.replaceActivityToTargets(update, newTargets);
  /// ```
  Future<void> replaceActivityToTargets(
      ActivityUpdate update, Iterable<FeedId> newTargets) {
    final token = userToken ??
        TokenHelper.buildToTargetUpdateToken(
            secret!, TokenAction.write, feedId);
    return feed.updateActivityToTargets(token, feedId, update,
        replace: newTargets);
  }

  /// Update Activities By Id
  Future<List<Activity>> updateActivitiesById(
      Iterable<ActivityUpdate> updates) {
    //TODO: further document that thing
    final token =
        userToken ?? TokenHelper.buildActivityToken(secret!, TokenAction.write);
    return feed.updateActivitiesById(token, updates);
  }

  /// Partial update by activity ID
  ///
  /// For example
  /// First, prepare the set operations
  /// ```dart
  /// final set = {
  ///   'product.price': 19.99,
  ///   'shares': {
  ///     'facebook': '...',
  ///     'twitter': '...',
  ///   }
  /// };
  /// ```
  /// Prepare the unset operations
  /// ```dart
  /// final unset = ['daily_likes', 'popularity'];
  /// const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
  /// final update = ActivityUpdate.withId(id, set, unset);
  /// await userFeed.updateActivityById(update);
  /// ```
  Future<Activity> updateActivityById({
    required String id,
    Map<String, Object>? set,
    List<String>? unset,
  }) {
    final update = ActivityUpdate.withId(id: id, set: set, unset: unset);
    final token =
        userToken ?? TokenHelper.buildActivityToken(secret!, TokenAction.write);
    return feed.updateActivityById(token, update);
  }

  /// Update Activities By ForeignId
  Future<List<Activity>> updateActivitiesByForeignId(
      Iterable<ActivityUpdate> updates) {
    final token =
        userToken ?? TokenHelper.buildActivityToken(secret!, TokenAction.write);
    return feed.updateActivitiesByForeignId(token, updates);
  }

  /// Update [Activity.foreignId] By ForeignId
  ///
  /// Usage:
  /// ```dart
  /// await userFeed.updateActivityByForeignId(update);
  /// ```
  Future<Activity> updateActivityByForeignId({
    required String foreignId,
    required DateTime time,
    Map<String, Object>? set,
    List<String>? unset,
  }) {
    final update = ActivityUpdate.withForeignId(
        foreignId: foreignId, time: time, set: set, unset: unset);
    final token =
        userToken ?? TokenHelper.buildActivityToken(secret!, TokenAction.write);

    return feed.updateActivityByForeignId(token, update);
  }
}
