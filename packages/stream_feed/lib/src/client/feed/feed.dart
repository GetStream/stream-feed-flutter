import 'package:stream_feed_dart/src/client/feed/flat_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class Feed {
  const Feed(this.secret, this.feedId, this.feed)
      : assert(secret != null, "Can't create Feed w/o a Secret"),
        assert(feedId != null, "Can't create feed w/o an FeedId"),
        assert(feed != null, "Can't create feed w/o a FeedApi");
  final String secret;
  final FeedId feedId;
  final FeedApi feed;

  Future<Activity> addActivity(Activity activity) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write, feedId);
    return feed.addActivity(token, feedId, activity);
  }

  Future<List<Activity>> addActivities(Iterable<Activity> activities) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write, feedId);
    return feed.addActivities(token, feedId, activities);
  }

  Future<void> removeActivityById(String id) {
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    return feed.removeActivityById(token, feedId, id);
  }

  Future<void> removeActivityByForeignId(String foreignId) {
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    return feed.removeActivityByForeignId(token, feedId, foreignId);
  }

  Future<void> follow(
    FlatFeet flatFeet, {
    int activityCopyLimit,
  }) {
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
