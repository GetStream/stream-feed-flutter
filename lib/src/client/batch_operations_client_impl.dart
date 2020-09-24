import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/models/activity.dart';
import 'package:stream_feed_dart/src/models/activity_partial_update.dart';
import 'package:stream_feed_dart/src/models/follow.dart';
import 'package:stream_feed_dart/src/models/foreign_id_time.dart';

import 'feed/feed.dart';

class BatchOperationsClientImpl implements BatchOperationsClient {
  @override
  Future<void> activitiesPartialUpdate(Iterable<ActivityPartialUpdate> data) {
    // TODO: implement activitiesPartialUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> activityPartialUpdate(ActivityPartialUpdate data) {
    // TODO: implement activityPartialUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> addToMany(Activity activity,
      {Iterable<Feed> feeds, Iterable<String> feedIds}) {
    // TODO: implement addToMany
    throw UnimplementedError();
  }

  @override
  Future<void> followMany(Iterable<Follow> follows,
      {int activityCopyLimit = 300}) {
    // TODO: implement followMany
    throw UnimplementedError();
  }

  @override
  Future<Iterable<Activity>> getActivities(
      {Iterable<String> ids, Iterable<ForeignIdTime> foreignIdTimes}) {
    // TODO: implement getActivities
    throw UnimplementedError();
  }

  @override
  Future<void> updateActivities(Iterable<Activity> activities) {
    // TODO: implement updateActivities
    throw UnimplementedError();
  }

  @override
  Future<void> updateActivity(Activity activity) {
    // TODO: implement updateActivity
    throw UnimplementedError();
  }

  @override
  Future<void> unfollowMany(Iterable<Follow> unfollows) {
    // TODO: implement unfollowMany
    throw UnimplementedError();
  }
}
