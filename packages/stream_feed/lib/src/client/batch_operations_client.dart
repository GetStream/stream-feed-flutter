import 'package:stream_feed/src/core/api/batch_api.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/follow_relation.dart';
import 'package:stream_feed/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Enables getting, adding and updating multiple activities with a single
/// operation.
class BatchOperationsClient {
  /// Builds a [BatchOperationsClient].
  BatchOperationsClient(this._batch, {required this.secret});
  final String secret;
  final BatchAPI _batch;

  /// Add one activity to many feeds
  ///
  /// It takes in parameters:
  /// - [activity] : the [Activity] to add
  /// - [feedIds] : an Iterable of feed ids [FeedId]
  ///
  /// API docs: [batch-activity-add](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-activity-add)
  Future<void> addToMany(Activity activity, List<FeedId> feedIds) {
    //TODO: why is this void vs Future<APIResponse> compared to js client
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write);
    return _batch.addToMany(token, activity, feedIds);
  }

  /// Follow multiple feeds with one API call
  ///
  /// It takes in parameters:
  /// - [follows] : The follow relations to create
  /// - [activityCopyLimit] : How many activities should be copied
  /// from the target feed
  ///
  /// API docs: [add_many_activities](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-follow)
  ///
  Future<void> followMany(
    Iterable<FollowRelation> follows, {
    int? activityCopyLimit,
  }) {
    final token = TokenHelper.buildFollowToken(secret, TokenAction.write);
    return _batch.followMany(
        token, activityCopyLimit ?? Default.activityCopyLimit, follows);
  }

  /// Unfollow multiple feeds with one API call
  /// This feature is usually restricted,
  /// please contact support if you face an issue
  ///
  /// It takes in parameter:
  ///
  ///  [unfollows]: The follow relations to remove
  ///
  /// API docs : [batch-unfollow](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-unfollow)
  ///
  Future<void> unfollowMany(
    Iterable<UnFollowRelation> unfollows, {
    // TODO: seems to be Iterable<UnFollow> unfollows here
    required bool keepHistory,
  }) {
    final token = TokenHelper.buildFollowToken(secret, TokenAction.write);
    return _batch.unfollowMany(
      token,
      unfollows
          .map((e) => UnFollowRelation.fromFollow(e, keepHistory: keepHistory)),
    );
  }

  /// Retrieve a batch of activities by a list of ids.
  Future<Iterable<Activity>> getActivitiesById(Iterable<String> ids) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return _batch.getActivitiesById(token, ids);
  }

  Future<Iterable<GenericEnrichedActivity<A, Ob, T, Or>>>
      getEnrichedActivitiesById<A, Ob, T, Or>(Iterable<String> ids) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return _batch.getEnrichedActivitiesById<A, Ob, T, Or>(token, ids);
  }

  /// Retrieve a batch of activities by a list of foreign ids.
  Future<Iterable<Activity>> getActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return _batch.getActivitiesByForeignId(token, pairs);
  }

  Future<Iterable<GenericEnrichedActivity<A, Ob, T, Or>>>
      getEnrichedActivitiesByForeignId<A, Ob, T, Or>(
          Iterable<ForeignIdTimePair> pairs) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return _batch.getEnrichedActivitiesByForeignId<A, Ob, T, Or>(token, pairs);
  }

  /// Update a single activity
  Future<void> updateActivity(Activity activity) =>
      updateActivities([activity]);

  /// Update a batch of activities
  Future<void> updateActivities(Iterable<Activity> activities) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return _batch.updateActivities(token, activities);
  }
}
