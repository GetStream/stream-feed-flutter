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

import 'package:stream_feed_dart/src/models/activity_partial_update.dart';
import 'package:stream_feed_dart/src/models/foreign_id_time.dart';

import '../models/activity.dart';
import '../models/follow.dart';
import 'feed/feed.dart';

abstract class BatchOperationsClient {
  Future<void> addToMany(
    Activity activity, {
    Iterable<Feed> feeds,
    Iterable<String> feedIds,
  });

  Future<void> followMany(
    Iterable<Follow> follows, {
    int activityCopyLimit = 300,
  });

  Future<void> unfollowMany(Iterable<Follow> unfollows);

  Future<Iterable<Activity>> getActivities({
    Iterable<String> ids,
    Iterable<ForeignIdTime> foreignIdTimes,
  });

  Future<void> updateActivity(Activity activity);

  Future<void> updateActivities(Iterable<Activity> activities);

  Future<void> activityPartialUpdate(ActivityPartialUpdate data);

  Future<void> activitiesPartialUpdate(Iterable<ActivityPartialUpdate> data);
}
