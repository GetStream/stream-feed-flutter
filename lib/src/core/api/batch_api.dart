import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/models/activity.dart';
import 'package:stream_feed_dart/src/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/models/feed_id.dart';
import 'package:stream_feed_dart/src/models/follow.dart';
import 'package:stream_feed_dart/src/models/foreign_id_time_pair.dart';

abstract class BatchApi {
  Future<void> addToMany(
      Token token, Activity activity, Iterable<FeedId> feedIds);

  Future<void> followMany(
      Token token, int activityCopyLimit, Iterable<Follow> follows);

  Future<void> unfollowMany(Token token, Iterable<UnFollow> unfollows);

  Future<List<Activity>> getActivitiesById(Token token, Iterable<String> ids);

  Future<List<EnrichedActivity>> getEnrichedActivitiesById(
      Token token, Iterable<String> ids);

  Future<List<Activity>> getActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs);

  Future<List<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Token token, Iterable<ForeignIdTimePair> pairs);

  Future<void> updateActivities(Token token, Iterable<Activity> activities);
}
