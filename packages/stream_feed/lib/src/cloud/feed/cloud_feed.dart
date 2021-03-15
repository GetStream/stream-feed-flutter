import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';

import 'package:stream_feed_dart/src/cloud/feed/cloud_flat_feed.dart';

class CloudFeed {
  const CloudFeed(this.token, this.feedId, this.feed);

  final Token token;
  final FeedId feedId;
  final FeedApi feed;

  Future<Activity> addActivity(Activity activity) =>
      feed.addActivity(token, feedId, activity);

  Future<List<Activity>> addActivities(Iterable<Activity> activities) =>
      feed.addActivities(token, feedId, activities);

  Future<void> removeActivityById(String id) =>
      feed.removeActivityById(token, feedId, id);

  Future<void> removeActivityByForeignId(String foreignId) =>
      feed.removeActivityByForeignId(token, feedId, foreignId);

  Future<void> follow(
    CloudFlatFeed flatFeet, {
    int? activityCopyLimit,
  }) =>
      feed.follow(token, token, feedId, flatFeet.feedId,
          activityCopyLimit ?? Default.activityCopyLimit);

  Future<List<Follow>> getFollowers(
    Iterable<FeedId> feedIds, {
    int? limit,
    int? offset,
  }) =>
      feed.getFollowers(token, feedId, limit ?? Default.limit,
          offset ?? Default.offset, feedIds);

  Future<List<Follow>> getFollowed(
    Iterable<FeedId> feedIds, {
    int? limit,
    int? offset,
  }) =>
      feed.getFollowed(token, feedId, limit ?? Default.limit,
          offset ?? Default.offset, feedIds);

  Future<void> unfollow(
    CloudFlatFeed flatFeet, {
    bool? keepHistory,
  }) =>
      feed.unfollow(token, feedId, flatFeet.feedId, keepHistory ?? false);

  Future<void> updateActivityToTargets(ActivityUpdate update,
          Iterable<FeedId> add, Iterable<FeedId> remove) =>
      feed.updateActivityToTargets(token, feedId, update,
          add: add, remove: remove);

  Future<void> replaceActivityToTargets(
          ActivityUpdate update, Iterable<FeedId> newTargets) =>
      feed.updateActivityToTargets(token, feedId, update, replace: newTargets);

  Future<List<Activity>> updateActivitiesById(
          Iterable<ActivityUpdate> updates) =>
      feed.updateActivitiesById(token, updates);

  Future<Activity> updateActivityById(ActivityUpdate update) =>
      feed.updateActivityById(token, update);

  Future<List<Activity>> updateActivitiesByForeignId(
          Iterable<ActivityUpdate> updates) =>
      feed.updateActivitiesByForeignId(token, updates);

  Future<Activity> updateActivityByForeignId(ActivityUpdate update) =>
      feed.updateActivityByForeignId(token, update);
}
