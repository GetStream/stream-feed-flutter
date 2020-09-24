import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:stream_feed_dart/src/models/activity.dart';
import 'package:stream_feed_dart/src/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/models/feed_id.dart';
import 'package:stream_feed_dart/src/models/follow.dart';
import 'package:stream_feed_dart/src/models/foreign_id_time_pair.dart';

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
      data: {'feeds': ids},
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  Future<void> followMany(
      Token token, int activityCopyLimit, Iterable<Follow> follows) {
    // TODO: implement followMany
    throw UnimplementedError();
  }

  @override
  Future<List<Activity>> getActivitiesById(Token token, Iterable<String> ids) {
    // TODO: implement getActivitiesById
    throw UnimplementedError();
  }

  @override
  Future<void> unfollowMany(Token token, Iterable<UnFollow> unfollows) {
    // TODO: implement unfollowMany
    throw UnimplementedError();
  }

  @override
  Future<void> updateActivities(Token token, Iterable<Activity> activities) {
    // TODO: implement updateActivities
    throw UnimplementedError();
  }

  @override
  Future<List<Activity>> getActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) {
    // TODO: implement getActivitiesByForeignId
    throw UnimplementedError();
  }

  @override
  Future<List<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs) {
    // TODO: implement getEnrichedActivitiesByForeignId
    throw UnimplementedError();
  }

  @override
  Future<List<EnrichedActivity>> getEnrichedActivitiesById(
      Token token, Iterable<String> ids) {
    // TODO: implement getEnrichedActivitiesById
    throw UnimplementedError();
  }
}
