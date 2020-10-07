import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_update.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class FeedApiImpl implements FeedApi {
  final HttpClient client;

  const FeedApiImpl(this.client)
      : assert(client != null, "Can't create a FeedApi w/o Client");

  @override
  Future<List<Activity>> addActivities(
      Token token, FeedId feed, Iterable<Activity> activities) async {
    checkNotNull(activities, 'No activities to add');
    checkArgument(activities.isNotEmpty, 'No activities to add');
    final result = await client.post<Map>(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: {'activities': activities},
    );
    final data = (result.data['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<Activity> addActivity(
      Token token, FeedId feed, Activity activity) async {
    checkNotNull(activity, 'No activity to add');
    final result = await client.post<Map>(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: activity,
    );
    final data = Activity.fromJson(result.data);
    return data;
  }

  @override
  Future<Response> follow(Token token, Token targetToken, FeedId sourceFeed,
      FeedId targetFeed, int activityCopyLimit) {
    checkNotNull(targetFeed, 'No feed to follow');
    checkArgument(sourceFeed != targetFeed, "Feed can't follow itself");
    checkArgument(activityCopyLimit >= 0,
        'Activity copy limit should be a non-negative number');
    checkArgument(activityCopyLimit <= Default.maxActivityCopyLimit,
        'Activity copy limit should be less then ${Default.maxActivityCopyLimit}');
    return client.post(
      Routes.buildFeedUrl(sourceFeed, 'following'),
      headers: {'Authorization': '$token'},
      data: {
        'target': '$targetFeed',
        'activity_copy_limit': activityCopyLimit,
        'target_token': '$targetToken',
      },
    );
  }

  @override
  Future<Response<Map>> getActivities(
      Token token, FeedId feed, Map<String, Object> options) {
    checkNotNull(options, 'Missing request options');
    return client.get<Map>(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      queryParameters: options,
    );
  }

  @override
  Future<Response> getEnrichedActivities(
      Token token, FeedId feed, Map<String, Object> options) {
    checkNotNull(options, 'Missing request options');
    return client.get(
      Routes.buildEnrichedFeedUrl(feed),
      headers: {'Authorization': '$token'},
      queryParameters: options,
    );
  }

  @override
  Future<List<Follow>> getFollowed(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds) async {
    checkArgument(limit >= 0, 'Limit should be a non-negative number');
    checkArgument(offset >= 0, 'Offset should be a non-negative number');
    checkNotNull(feedIds, 'No feed ids to filter on');
    final result = await client.get<Map>(
      Routes.buildFeedUrl(feed, 'following'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (feedIds.isNotEmpty)
          'filter': feedIds.map((it) => it.toString()).join(',')
      },
    );
    final data = (result.data['results'] as List)
        .map((e) => Follow.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<List<Follow>> getFollowers(Token token, FeedId feed, int limit,
      int offset, Iterable<FeedId> feedIds) async {
    checkArgument(limit >= 0, 'Limit should be a non-negative number');
    checkArgument(offset >= 0, 'Offset should be a non-negative number');
    checkNotNull(feedIds, 'No feed ids to filter on');
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
    final data = (result.data['results'] as List)
        .map((e) => Follow.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<Response> removeActivityByForeignId(
      Token token, FeedId feed, String foreignId) {
    checkNotNull(foreignId, 'No activity id to remove');
    return client.delete(
      Routes.buildFeedUrl(feed, foreignId),
      headers: {'Authorization': '$token'},
      queryParameters: {'foreign_id': '1'},
    );
  }

  @override
  Future<Response> removeActivityById(Token token, FeedId feed, String id) {
    checkNotNull(id, 'No activity id to remove');
    return client.delete(
      Routes.buildFeedUrl(feed, id),
      headers: {'Authorization': '$token'},
    );
  }

  @override
  Future<Response> unfollow(
      Token token, FeedId source, FeedId target, bool keepHistory) {
    checkNotNull(target, 'No target feed to unfollow');
    return client.delete(
      Routes.buildFeedUrl(source, 'following/$target'),
      headers: {'Authorization': '$token'},
      queryParameters: {'keep_history': keepHistory},
    );
  }

  @override
  Future<List<Activity>> updateActivitiesByForeignId(
      Token token, Iterable<ActivityUpdate> updates) async {
    checkNotNull(updates, 'No updates');
    checkArgument(updates.isNotEmpty, 'No updates');
    checkArgument(updates.length <= 100, 'Maximum length is 100');
    for (var update in updates) {
      checkNotNull(update.foreignId, 'No activity to update');
      checkNotNull(update.time, 'Missing timestamp');
      checkNotNull(update.set, 'No activity properties to set');
      checkNotNull(update.unset, 'No activity properties to unset');
    }
    final result = await client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    final data = (result.data['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<List<Activity>> updateActivitiesById(
      Token token, Iterable<ActivityUpdate> updates) async {
    checkNotNull(updates, 'No updates');
    checkArgument(updates.isNotEmpty, 'No updates');
    checkArgument(updates.length <= 100, 'Maximum length is 100');
    for (var update in updates) {
      checkNotNull(update.id, 'No activity to update');
      checkNotNull(update.set, 'No activity properties to set');
      checkNotNull(update.unset, 'No activity properties to unset');
    }
    final result = await client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    final data = (result.data['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  @override
  Future<Activity> updateActivityByForeignId(
      Token token, ActivityUpdate update) async {
    checkNotNull(update, 'No activity to update');
    checkNotNull(update.foreignId, 'No activity to update');
    checkNotNull(update.time, 'Missing timestamp');
    checkNotNull(update.set, 'No activity properties to set');
    checkNotNull(update.unset, 'No activity properties to unset');
    final result = await client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    final data = Activity.fromJson(result.data);
    return data;
  }

  @override
  Future<Activity> updateActivityById(
      Token token, ActivityUpdate update) async {
    checkNotNull(update, 'No activity to update');
    checkNotNull(update.id, 'No activity to update');
    checkNotNull(update.set, 'No activity properties to set');
    checkNotNull(update.unset, 'No activity properties to unset');
    final result = await client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    final data = Activity.fromJson(result.data);
    return data;
  }

  @override
  Future<Response> updateActivityToTargets(
    Token token,
    FeedId feed,
    ActivityUpdate update, {
    Iterable<FeedId> add = const [],
    Iterable<FeedId> remove = const [],
    Iterable<FeedId> replace = const [],
  }) async {
    checkNotNull(update, 'No activity to update');
    checkNotNull(
        update.foreignId, 'Activity is required to have foreign ID attribute');
    checkNotNull(update.time, 'Activity is required to have time attribute');
    checkNotNull(add, 'No targets to add');
    checkNotNull(remove, 'No targets to remove');
    checkNotNull(replace, 'No targets to set');
    final modification =
        replace.isEmpty && (add.isNotEmpty || remove.isNotEmpty);
    final replacement = replace.isNotEmpty && add.isEmpty && remove.isEmpty;
    checkArgument(modification || replacement,
        "Can't replace and modify activity to targets at the same time");

    return client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {
        'foreign_id': update.foreignId,
        'time': update.time.toIso8601String(),
        'added_targets': add.map((it) => it.toString()).toList(),
        'removed_targets': remove.map((it) => it.toString()).toList(),
        'new_targets': replace.map((it) => it.toString()).toList(),
      },
    );
  }
}
