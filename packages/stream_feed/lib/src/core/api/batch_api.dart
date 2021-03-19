import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class BatchApi {
  const BatchApi(this.client);

  final HttpClient client;

  
  Future<Response> addToMany(
      Token token, Activity activity, Iterable<FeedId> feedIds) async {
    checkNotNull(activity, 'Missing activity');
    checkNotNull(feedIds, 'No feeds to add to');
    checkArgument(feedIds.isNotEmpty, 'No feeds to add to');
    return client.post(
      Routes.addToManyUrl,
      headers: {'Authorization': '$token'},
      data: json.encode({
        'feeds': feedIds.map((e) => e.toString()).toList(),
        'activity': activity,
      }),
    );
  }

  
  Future<Response> followMany(
      Token token, int activityCopyLimit, Iterable<Follow> follows) async {
    checkArgument(
        activityCopyLimit >= 0, 'Activity copy limit must be non negative');
    checkNotNull(follows, 'No feeds to follow');
    checkArgument(follows.isNotEmpty, 'No feeds to follow');
    return client.post(
      Routes.followManyUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'activity_copy_limit': activityCopyLimit},
      data: follows,
    );
  }

  
  Future<Response> unfollowMany(
      Token token, Iterable<UnFollow> unfollows) async {
    checkNotNull(unfollows, 'No feeds to unfollow');
    checkArgument(unfollows.isNotEmpty, 'No feeds to unfollow');
    return client.post(
      Routes.unfollowManyUrl,
      headers: {'Authorization': '$token'},
      data: unfollows,
    );
  }

  
  Future<List<Activity>> getActivitiesById(
      Token token, Iterable<String> ids) async {
    checkNotNull(ids, 'No activities to get');
    checkArgument(ids.isNotEmpty, 'No activities to get');
    final result = await client.get<Map>(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'ids': ids.join(',')},
    );
    final data = (result.data!['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  
  Future<List<Activity>> getActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) async {
    checkNotNull(pairs, 'No activities to get');
    checkArgument(pairs.isNotEmpty, 'No activities to get');
    final result = await client.get(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {
        'foreign_ids': pairs.map((it) => it.foreignID).join(','),
        'timestamps':
            pairs.map((it) => it.time.toUtc().toIso8601String()).join(','),
      },
    );
    final data = (result.data['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  
  Future<List<EnrichedActivity>> getEnrichedActivitiesById(
      Token token, Iterable<String> ids) async {
    checkNotNull(ids, 'No activities to get');
    checkArgument(ids.isNotEmpty, 'No activities to get');
    final result = await client.get(
      Routes.enrichedActivitiesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'ids': ids.join(',')},
    );
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  
  Future<List<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) async {
    checkNotNull(pairs, 'No activities to get');
    checkArgument(pairs.isNotEmpty, 'No activities to get');
    final result = await client.get(
      Routes.enrichedActivitiesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {
        'foreign_ids': pairs.map((it) => it.foreignID).join(','),
        'timestamps':
            pairs.map((it) => it.time.toUtc().toIso8601String()).join(','),
      },
    );
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  
  Future<Response> updateActivities(
      Token token, Iterable<Activity> activities) async {
    checkNotNull(activities, 'No activities to update');
    checkArgument(activities.isNotEmpty, 'No activities to update');
    return client.post(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      data: {'activities': activities},
    );
  }
}
