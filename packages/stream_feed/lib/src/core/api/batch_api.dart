import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/follow.dart';
import 'package:stream_feed/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for for anything related to Batch operations
class BatchApi {
  /// [CollectionsApi] constructor
  const BatchApi(this._client);

  final StreamHttpClient _client;

  Future<Response> addToMany(
      Token token, Activity activity, Iterable<FeedId> feedIds) async {
    checkArgument(feedIds.isNotEmpty, 'No feeds to add to');
    return _client.post(
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

    checkArgument(follows.isNotEmpty, 'No feeds to follow');
    return _client.post(
      Routes.followManyUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'activity_copy_limit': activityCopyLimit},
      data: follows,
    );
  }

  Future<Response> unfollowMany(
      Token token, Iterable<UnFollow> unfollows) async {
    checkArgument(unfollows.isNotEmpty, 'No feeds to unfollow');
    return _client.post(
      Routes.unfollowManyUrl,
      headers: {'Authorization': '$token'},
      data: unfollows,
    );
  }

  Future<List<Activity>> getActivitiesById(
      Token token, Iterable<String> ids) async {
    checkArgument(ids.isNotEmpty, 'No activities to get');
    final result = await _client.get<Map>(
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
    checkArgument(pairs.isNotEmpty, 'No activities to get');
    final result = await _client.get(
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
    checkArgument(ids.isNotEmpty, 'No activities to get');
    final result = await _client.get(
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
    checkArgument(pairs.isNotEmpty, 'No activities to get');
    final result = await _client.get(
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
    checkArgument(activities.isNotEmpty, 'No activities to update');
    return _client.post(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      data: {'activities': activities},
    );
  }
}
