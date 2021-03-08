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

  /// Remove an Activity by referencing its foreign_id
  ///
  /// Parameters:
  /// [foreignId]: Identifier of activity to remove
  ///
  /// For example :
  ///```dart
  /// final chris = client.flatFeed('user', 'chris');
  /// await chris.removeActivityByForeignId('picture:10');
  /// ```
  ///
  /// API docs: [removing-activities](https://getstream.io/activity-feeds/docs/flutter-dart/adding_activities/?language=dart#removing-activities)
  Future<void> removeActivityByForeignId(String foreignId) {
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    return feed.removeActivityByForeignId(token, feedId, foreignId);
  }

  /// Follows the given target feed
  ///
  /// Parameters:
  ///
  /// [flatFeet] : Slug of the target feed
  /// [activityCopyLimit] : Limit the amount of activities copied over on follow
  ///
  /// For example to create a following relationship
  /// between Jack's "timeline" feed and Chris' "user" feed
  /// you'd do the following
  /// ```dart
  /// final jack = client.flatFeed('timeline', 'jack');
  /// await jack.follow(chris);
  /// ```
  ///
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

  /// List the followers of this feed
  ///
  /// Parameters:
  /// [offset] : pagination offset
  /// [limit] : limit offset
  ///
  /// Usage:
  /// ```dart
  /// final followers = await userFeed.getFollowers(limit: 10, offset: 0);
  /// ```
  ///
  /// API docs: [reading-feed-followers](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart#reading-feed-followers)
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

  /// List which feeds this feed is following
  ///
  /// - Retrieve last 10 feeds followed by user
  /// ```dart
  /// var followed = await userFeed.getFollowed(limit: 10, offset: 0);
  ///```
  ///
  /// - Retrieve 10 feeds followed by user starting from the 11th
  /// ```dart
  /// followed = await userFeed.getFollowed(limit: 10, offset: 10);
  ///```
  ///
  /// - Check if user follows specific feeds
  /// ```dart
  /// followed = await userFeed.getFollowed(limit: 2, offset: 0, feedIds: [
  ///  FeedId.id('user:42'),
  ///  FeedId.id('user:43'),
  ///]);
  ///```
  ///
  /// API docs: [reading-followed-feeds](https://getstream.io/activity-feeds/docs/flutter-dart/following/?language=dart#reading-followed-feeds)
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
    FlatFeet flatFeet, {
    bool keepHistory,
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.delete, feedId);
    return feed.unfollow(token, feedId, flatFeet.feedId, keepHistory ?? false);
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
    final token =
        TokenHelper.buildToTargetUpdateToken(secret, TokenAction.write, feedId);
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
  ///  ```dart
  /// final unset = ['daily_likes', 'popularity'];
  /// const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
  /// final update = ActivityUpdate.withId(id, set, unset);
  /// await userFeed.updateActivityById(update);
  ///  ```

  Future<Activity> updateActivityById(ActivityUpdate update) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivityById(token, update);
  }

  Future<List<Activity>> updateActivitiesByForeignId(
      Iterable<ActivityUpdate> updates) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivitiesByForeignId(token, updates);
  }

  /// Update [Activity.foreignId] By ForeignId
  /// 
  /// Usage:
  ///```dart
  ///await userFeed.updateActivityByForeignId(update);
  ///```
  Future<Activity> updateActivityByForeignId(ActivityUpdate update) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return feed.updateActivityByForeignId(token, update);
  }
}
