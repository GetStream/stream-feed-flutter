import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class FeedApiImpl implements FeedApi {
  final HttpClient client;

  const FeedApiImpl(this.client);

  @override
  Future<List<Activity>> addActivities(
      Token token, FeedId feed, Iterable<Activity> activities) async {
    final result = await client.post(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: {'activities': activities},
    );
    print(result);
  }

  @override
  Future<Activity> addActivity(
      Token token, FeedId feed, Activity activity) async {
    final result = await client.post(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: activity,
    );
    print(result);
  }

  @override
  Future<Response> follow(Token token, Token targetToken, FeedId sourceFeed,
      FeedId targetFeed, int activityCopyLimit) async {
    final result = await client.post(
      Routes.buildFeedUrl(sourceFeed, 'following'),
      headers: {'Authorization': '$token'},
      data: {
        'target': '$targetFeed',
        'activity_copy_limit': activityCopyLimit,
        'target_token': '$targetToken',
      },
    );
    print(result);
  }

  @override
  Future<Response> getActivities(
          Token token, FeedId feed, Map<String, Object> options) =>
      client.get(
        Routes.buildFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      );

  @override
  Future<Response> getEnrichedActivities(
          Token token, FeedId feed, Map<String, Object> options) =>
      client.get(
        Routes.buildEnrichedFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      );

  @override
  Future<List<Follow>> getFollowed(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds) async {
    final result = await client.get(
      Routes.buildFeedUrl(feed, 'following'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (feedIds.isNotEmpty)
          'filter': feedIds.map((it) => it.toString()).join(',')
      },
    );
    print(result);
  }

  @override
  Future<List<Follow>> getFollowers(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds) async {
    final result = await client.get(
      Routes.buildFeedUrl(feed, 'followers'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (feedIds.isNotEmpty)
          'filter': feedIds.map((it) => it.toString()).join(',')
      },
    );
    print(result);
  }

  @override
  Future<Response> removeActivityByForeignId(
      Token token, FeedId feed, String foreignID) async {
    final result = await client.delete(
      Routes.buildFeedUrl(feed, foreignID),
      headers: {'Authorization': '$token'},
      queryParameters: {'foreign_id': '1'},
    );
    print(result);
  }

  @override
  Future<Response> removeActivityById(
      Token token, FeedId feed, String id) async {
    final result = await client.delete(
      Routes.buildFeedUrl(feed, id),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<Response> unfollow(
      Token token, FeedId source, FeedId target, bool keepHistory) async {
    final result = await client.delete(
      Routes.buildFeedUrl(source, 'following/$target'),
      headers: {'Authorization': '$token'},
      queryParameters: {'keep_history': keepHistory},
    );
    print(result);
  }

  @override
  Future<List<Activity>> updateActivitiesByForeignId(
      Token token, Iterable<ActivityUpdate> updates) async {
    final result = await client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    print(result);
  }

  @override
  Future<List<Activity>> updateActivitiesById(
      Token token, Iterable<ActivityUpdate> updates) async {
    final result = await client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    print(result);
  }

  @override
  Future<Activity> updateActivityByForeignId(
      Token token, ActivityUpdate update) async {
    final result = await client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    print(result);
  }

  @override
  Future<Activity> updateActivityById(
      Token token, ActivityUpdate update) async {
    final result = await client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    print(result);
  }

  @override
  Future<Response> updateActivityToTargets(
    Token token,
    FeedId feed,
    Activity activity, {
    Iterable<FeedId> add = const [],
    Iterable<FeedId> remove = const [],
    Iterable<FeedId> replace = const [],
  }) async {
    final result = await client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {
        'foreign_id': activity.foreignId,
        'time': activity.time,
        'added_targets': add.map((it) => it.toString()),
        'removed_targets': remove.map((it) => it.toString()),
        'new_targets': replace.map((it) => it.toString()),
      },
    );
    print(result);
  }
}
