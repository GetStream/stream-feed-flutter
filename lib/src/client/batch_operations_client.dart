//public interface IBatchOperations
//     {
//         Task AddToMany(Activity activity, IEnumerable<IStreamFeed> feeds);
//         Task AddToMany(Activity activity, IEnumerable<string> feedIds);
//         Task FollowMany(IEnumerable<Follow> follows, int activityCopyLimit = 300);
//         Task<IEnumerable<Activity>> GetActivities(IEnumerable<string> ids = null, IEnumerable<ForeignIDTime> foreignIDTimes = null);
//         Task UpdateActivities(IEnumerable<Activity> activities);
//         Task UpdateActivity(Activity activity);
//         Task ActivitiesPartialUpdate(IEnumerable<ActivityPartialUpdateRequestObject> updates);
//     }

import 'dart:async';

import '../core/models/activity.dart';
import '../core/models/enriched_activity.dart';
import '../core/models/feed_id.dart';
import '../core/models/follow.dart';
import '../core/models/foreign_id_time_pair.dart';

abstract class BatchOperationsClient {
  Future<void> addToMany(Activity activity, Iterable<FeedId> feedIds);

  Future<void> followMany(
    Iterable<Follow> follows, {
    int activityCopyLimit = 300,
  });

  Future<void> unfollowMany(
    Iterable<Follow> unfollows, {
    bool keepHistory,
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
