import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';

abstract class FeedApi {
  Future<List<Activity>> updateActivitiesById(
      Token token, Iterable<ActivityUpdate> updates);

  Future<Activity> updateActivityById(Token token, ActivityUpdate update);

  Future<List<Activity>> updateActivitiesByForeignId(
      Token token, Iterable<ActivityUpdate> updates);

  Future<Activity> updateActivityByForeignId(
      Token token, ActivityUpdate update);

  Future<Response<Map>> getActivities(
      Token token, FeedId feed, Map<String, Object> options);

  Future<Response> getEnrichedActivities(
      Token token, FeedId feed, Map<String, Object> options);

  Future<Activity> addActivity(Token token, FeedId feed, Activity activity);

  Future<List<Activity>> addActivities(
      Token token, FeedId feed, Iterable<Activity> activities);

  Future<Response> removeActivityById(Token token, FeedId feed, String id);

  Future<Response> removeActivityByForeignId(
      Token token, FeedId feed, String foreignId);

  Future<Response> follow(Token token, Token targetToken, FeedId sourceFeed,
      FeedId targetFeed, int activityCopyLimit);

  Future<List<Follow>> getFollowers(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds);

  Future<List<Follow>> getFollowed(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds);

  Future<Response> unfollow(
      Token token, FeedId source, FeedId target, bool keepHistory);

  Future<Response> updateActivityToTargets(
    Token token,
    FeedId feed,
    ActivityUpdate update, {
    Iterable<FeedId> add,
    Iterable<FeedId> remove,
    Iterable<FeedId> replace,
  });
}
