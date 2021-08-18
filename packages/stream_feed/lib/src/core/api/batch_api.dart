import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/follow_relation.dart';
import 'package:stream_feed/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:stream_feed/stream_feed.dart';

/// The http layer api for for anything related to Batch operations
class BatchAPI {
  /// [CollectionsAPI] constructor
  const BatchAPI(this._client);

  final StreamHttpClient _client;

  /// Add one activity to many feeds
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

  /// Follow multiple feeds
  Future<Response> followMany(Token token, int activityCopyLimit,
      Iterable<FollowRelation> follows) async {
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

  /// Unfollow multiple feeds
  Future<Response> unfollowMany(
      Token token, Iterable<UnFollowRelation> unfollows) async {
    checkArgument(unfollows.isNotEmpty, 'No feeds to unfollow');
    return _client.post(
      Routes.unfollowManyUrl,
      headers: {'Authorization': '$token'},
      data: unfollows,
    );
  }

  /// Retrieve a batch of activities by a single id.
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

  /// Retrieve a batch of activities by a single foreign id.
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

  /// Retrieve multiple enriched activities by a single id
  Future<List<EnrichedActivity>>
      getEnrichedActivitiesById<A extends Object, Ob>(
          Token token, Iterable<String> ids) async {
    checkArgument(ids.isNotEmpty, 'No activities to get');
    final result = await _client.get(
      Routes.enrichedActivitiesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'ids': ids.join(',')},
    );
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(
              e,
              (json) => (A is User)
                  ? User.fromJson(json! as Map<String, dynamic>)
                  : A,
              (json) => (Ob is CollectionEntry)
                  ? CollectionEntry.fromJson(json! as Map<String, dynamic>)
                  : json,
            ))
        .toList(growable: false);
    return data;
  }

  /// Retrieve multiple enriched activities by a single foreign id
  Future<List<EnrichedActivity>>
      getEnrichedActivitiesByForeignId<A extends Object, Ob>(
    Token token,
    Iterable<ForeignIdTimePair> pairs,
  ) async {
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
        .map((e) => EnrichedActivity.fromJson(
              e,
              (json) => (A is User)
                  ? User.fromJson(json! as Map<String, dynamic>)
                  : A,
              (json) => (Ob is CollectionEntry)
                  ? CollectionEntry.fromJson(json! as Map<String, dynamic>)
                  : json,
            ))
        .toList(growable: false);
    return data;
  }

  /// Update multiple Activities
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
