import 'dart:convert';

import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/models/foreign_id_time_pair.dart';

import 'batch_api.dart';

class BatchApiImpl implements BatchApi {
  final HttpClient client;

  const BatchApiImpl(this.client);

  @override
  Future<void> addToMany(
      Token token, Activity activity, Iterable<FeedId> feedIds) async {
    final ids = feedIds?.map((e) => '$e')?.toList(growable: false) ?? [];
    final result = await client.post(
      Routes.addToManyUrl,
      headers: {'Authorization': '$token'},
      data: json.encode({'feeds': ids, 'activity': activity}),
    );
    print(result);
  }

  @override
  Future<void> followMany(
      Token token, int activityCopyLimit, Iterable<Follow> follows) async {
    final result = await client.post(
      Routes.followManyUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'activity_copy_limit': activityCopyLimit},
      data: follows,
    );
    print(result);
  }

  @override
  Future<void> unfollowMany(Token token, Iterable<UnFollow> unfollows) async {
    final result = await client.post(
      Routes.unfollowManyUrl,
      headers: {'Authorization': '$token'},
      data: unfollows,
    );
    print(result);
  }

  @override
  Future<List<Activity>> getActivitiesById(
      Token token, Iterable<String> ids) async {
    final result = await client.get(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'ids': ids.join(',')},
    );
    print(result);
  }

  @override
  Future<List<Activity>> getActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) async {
    final result = await client.get(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {
        'foreign_ids': pairs.map((it) => it.foreignID).join(','),
        'timestamps': pairs.map((it) {
          return it.time.toUtc().toIso8601String();
        }).join(','),
      },
    );
    print(result);
  }

  @override
  Future<List<EnrichedActivity>> getEnrichedActivitiesById(
      Token token, Iterable<String> ids) async {
    final result = await client.get(
      Routes.enrichedActivitiesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'ids': ids.join(',')},
    );
    print(result);
  }

  @override
  Future<List<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) async {
    final result = await client.get(
      Routes.enrichedActivitiesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {
        'foreign_ids': pairs.map((it) => it.foreignID).join(','),
        'timestamps': pairs.map((it) {
          return it.time.toUtc().toIso8601String();
        }).join(','),
      },
    );
    print(result);
  }

  @override
  Future<void> updateActivities(
      Token token, Iterable<Activity> activities) async {
    final result = await client.post(
      Routes.activitesUrl,
      headers: {'Authorization': '$token'},
      data: activities,
    );
    print(result);
  }
}
