import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class BatchOperationsClientImpl implements BatchOperationsClient {
  const BatchOperationsClientImpl(this.secret, this.batch);
  final String secret;
  final BatchApi batch;

  /// Add one activity to many feeds
  ///
  /// It takes in parameters:
  /// - [activity] : the [Activity] to add
  /// - [feedIds] : an Iterable of feed ids [FeedId]
  ///
  /// API docs: [batch-activity-add](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-activity-add)
  @override
  Future<void> addToMany(Activity activity, Iterable<FeedId> feedIds) {
    //TODO: why is this void vs Future<APIResponse> compared to js client
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write);
    return batch.addToMany(token, activity, feedIds);
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
  @override
  Future<void> followMany(
    Iterable<Follow> follows, {
    int? activityCopyLimit,
  }) {
    final token = TokenHelper.buildFollowToken(secret, TokenAction.write);
    return batch.followMany(
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
  @override
  Future<void> unfollowMany(
    Iterable<Follow> unfollows, {
    // TODO: seems to be Iterable<UnFollow> unfollows here
    bool? keepHistory = true,
  }) {
    final token = TokenHelper.buildFollowToken(secret, TokenAction.write);
    return batch.unfollowMany(
      token,
      unfollows.map((e) => UnFollow.fromFollow(e, keepHistory)),
    );
  }

  @override
  Future<Iterable<Activity>> getActivitiesById(Iterable<String> ids) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return batch.getActivitiesById(token, ids);
  }

  @override
  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesById(
      Iterable<String> ids) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return batch.getEnrichedActivitiesById(token, ids);
  }

  @override
  Future<Iterable<Activity>> getActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return batch.getActivitiesByForeignId(token, pairs);
  }

  @override
  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.read);
    return batch.getEnrichedActivitiesByForeignId(token, pairs);
  }

  @override
  Future<void> updateActivity(Activity activity) =>
      updateActivities([activity]);

  @override
  Future<void> updateActivities(Iterable<Activity> activities) {
    final token = TokenHelper.buildActivityToken(secret, TokenAction.write);
    return batch.updateActivities(token, activities);
  }
}
