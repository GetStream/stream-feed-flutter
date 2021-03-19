import 'dart:async';

import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/models/foreign_id_time_pair.dart';

abstract class BatchOperationsClient {
  Future<void> addToMany(Activity activity, Iterable<FeedId> feedIds);

  Future<void> followMany(
    Iterable<Follow> follows, {
    int? activityCopyLimit,
  });

  Future<void> unfollowMany(
    Iterable<Follow> unfollows, {
    required bool keepHistory,
  });

  Future<Iterable<Activity>> getActivitiesById(Iterable<String> ids);

  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesById(
      Iterable<String> ids);

  Future<Iterable<Activity>> getActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs);

  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs);

  Future<void> updateActivity(Activity activity);

  Future<void> updateActivities(Iterable<Activity> activities);
}
