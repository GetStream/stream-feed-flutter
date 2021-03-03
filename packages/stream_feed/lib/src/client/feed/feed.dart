import 'package:stream_feed_dart/src/client/feed/flat_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

/// Manage api calls for specific feeds
/// The feed object contains convenience functions
/// such add activity, remove activity etc
class Feed {
  ///Initialize a feed object
  const Feed(this.secret, this.feedId, this.feed)
      : assert(secret != null, "Can't create Feed w/o a Secret"),
        assert(feedId != null, "Can't create feed w/o an FeedId"),
        assert(feed != null, "Can't create feed w/o a FeedApi");

  /// Your API secret
  final String secret;

  /// The feed id
  final FeedId feedId;

  ///The stream client this feed is constructed from
  final FeedApi feed;

  /// Adds the given [Activity] to the feed
  /// parameters:
  /// [activity] : The activity to add
  /// Example
  /// ```dart
  ///  final activity = Activity(
  ///             actor: user.id,
  ///             verb: 'tweet',
  ///             object: '1',
  ///             extraData: {
  ///               'tweet': message,
  ///             },
  ///           );
  /// await userFeed.addActivity(activity);
  /// ```
  ///
  /// API docs: [adding-activities-basic](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#adding-activities-basic)
  Future<Activity> addActivity(Activity activity) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write, feedId);
    return feed.addActivity(token, feedId, activity);
  }

  /// Adds the given activities to the feed
  ///
  /// Usage :
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
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write, feedId);
    return feed.addActivities(token, feedId, activities);
  }

  /// Removes the activity by activityId or foreignId
  ///
  /// parameters
  /// [id] : activityId Identifier of activity to remove
  ///
  /// Usage:
  /// ```dart
  /// await userFeed.removeActivityById('e561de8f-00f1-11e4-b400-0cc47a024be0');
  /// ```
  /// API docs: [removing-activities](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#removing-activities)
  Future<void> removeActivityById(String id) {
    //TODO: named removeActivity in js
    //TODO: should return response
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    return feed.removeActivityById(token, feedId, id);
  }

  Future<void> removeActivityByForeignId(String foreignId) {
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    return feed.removeActivityByForeignId(token, feedId, foreignId);
  }

  /// API docs: [following](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart)
  Future<void> follow(
    FlatFeet flatFeet, {
    int activityCopyLimit,
  }) {
    //TODO: should return API response
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.write, feedId);
    final targetToken =
        TokenHelper.buildFeedToken(secret, TokenAction.read, flatFeet.feedId);
    return feed.follow(token, targetToken, feedId, flatFeet.feedId,
        activityCopyLimit ?? Default.activityCopyLimit);
  }

  Future<List<Follow>> getFollowers({
    Iterable<FeedId> feedIds,
    int limit,
    int offset,
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.read, feedId);
    return feed.getFollowers(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, feedIds ?? []);
  }

  Future<List<Follow>> getFollowed({
    Iterable<FeedId> feedIds,
    int limit,
    int offset,
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.read, feedId);
    return feed.getFollowed(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, feedIds ?? []);
  }

  Future<void> unfollow(
    FlatFeet flatFeet, {
    bool keepHistory,
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.delete, feedId);
    return feed.unfollow(token, feedId, flatFeet.feedId, keepHistory ?? false);
  }

  Future<void> updateActivityToTargets(
      ActivityUpdate update, Iterable<FeedId> add, Iterable<FeedId> remove) {
    final token =
        TokenHelper.buildToTargetUpdateToken(secret, TokenAction.write, feedId);
    return feed.updateActivityToTargets(token, feedId, update,
        add: add, remove: remove);
  }

  Future<void> replaceActivityToTargets(
      ActivityUpdate update, Iterable<FeedId> newTargets) {
    final token =
        TokenHelper.buildToTargetUpdateToken(secret, TokenAction.write, feedId);
    return feed.updateActivityToTargets(token, feedId, update,
        replace: newTargets);
  }

  Future<List<Activity>> updateActivitiesById(
      Iterable<ActivityUpdate> updates) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivitiesById(token, updates);
  }

  Future<Activity> updateActivityById(ActivityUpdate update) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivityById(token, update);
  }

  Future<List<Activity>> updateActivitiesByForeignId(
      Iterable<ActivityUpdate> updates) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivitiesByForeignId(token, updates);
  }

  Future<Activity> updateActivityByForeignId(ActivityUpdate update) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivityByForeignId(token, update);
  }
}
