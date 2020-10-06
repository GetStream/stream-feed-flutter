import 'package:stream_feed_dart/src/client/feed/flat_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class Feed {
  final String secret;
  final FeedId feedId;
  final FeedApi feed;

  const Feed(this.secret, this.feedId, this.feed);

  String get slug => feedId.slug;

  String get userId => feedId.userId;

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
    //TODO
    feed.removeActivityById(token, feedId, id);
  }

  Future<void> removeActivityByForeignId(String foreignId) {
    final token =
        TokenHelper.buildFeedToken(secret, TokenAction.delete, feedId);
    //TODO
    feed.removeActivityByForeignId(token, feedId, foreignId);
  }

  Future<void> follow(
    FlatFeet flatFeet, {
    int activityCopyLimit,
  }) {
    // TODO : Check max activityCopyLimit
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.write, feedId);
    final targetToken =
        TokenHelper.buildFeedToken(secret, TokenAction.read, flatFeet.feedId);
    return feed.follow(token, targetToken, feedId, flatFeet.feedId,
        activityCopyLimit ?? Default.activityCopyLimit);
  }

  Future<List<Follow>> getFollowers({
    int limit,
    int offset,
    Iterable<FeedId> feedIds = const [],
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.read, feedId);
    return feed.getFollowers(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, feedIds);
  }

  Future<List<Follow>> getFollowed({
    int limit,
    int offset,
    Iterable<FeedId> feedIds = const [],
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.read, feedId);
    return feed.getFollowed(token, feedId, limit ?? Default.limit,
        offset ?? Default.offset, feedIds);
  }

  Future<void> unfollow(
    FlatFeet flatFeet, {
    bool keepHistory = false,
  }) {
    final token =
        TokenHelper.buildFollowToken(secret, TokenAction.delete, feedId);
    return feed.unfollow(token, feedId, flatFeet.feedId, keepHistory);
  }

  Future<void> updateActivityToTargets(
      Activity activity, Iterable<FeedId> add, Iterable<FeedId> remove) {
    final token =
        TokenHelper.buildToTargetUpdateToken(secret, TokenAction.write, feedId);
    // TODO :
    feed.updateActivityToTargets(token, feedId, activity,
        add: add, remove: remove);
  }

  Future<void> replaceActivityToTargets(
      Activity activity, Iterable<FeedId> newTargets) {
    final token =
        TokenHelper.buildToTargetUpdateToken(secret, TokenAction.write, feedId);
    // TODO :
    feed.updateActivityToTargets(token, feedId, activity, replace: newTargets);
  }
}
