import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/follow.dart';
import 'package:stream_feed_dart/src/core/models/foreign_id_time_pair.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class BatchOperationsClient {
  BatchOperationsClient(this.batch, {required this.secret, this.tokenHelper});
  final String secret;
  final BatchApi batch;
  late TokenHelper? tokenHelper = TokenHelper();

  /// Add one activity to many feeds
  ///
  /// It takes in parameters:
  /// - [activity] : the [Activity] to add
  /// - [feedIds] : an Iterable of feed ids [FeedId]
  ///
  /// API docs: [batch-activity-add](https://getstream.io/activity-feeds/docs/flutter-dart/add_many_activities/?language=dart#batch-activity-add)
  Future<void> addToMany(Activity activity, Iterable<FeedId> feedIds) {
    //TODO: why is this void vs Future<APIResponse> compared to js client
    final token = tokenHelper!.buildFeedToken(secret, TokenAction.write);
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
  Future<void> followMany(
    Iterable<Follow> follows, {
    int? activityCopyLimit,
  }) {
    final token = tokenHelper!.buildFollowToken(secret, TokenAction.write);
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
  Future<void> unfollowMany(
    Iterable<Follow> unfollows, {
    // TODO: seems to be Iterable<UnFollow> unfollows here
    required bool keepHistory,
  }) {
    final token = tokenHelper!.buildFollowToken(secret, TokenAction.write);
    return batch.unfollowMany(
      token,
      unfollows.map((e) => UnFollow.fromFollow(e, keepHistory)),
    );
  }

  Future<Iterable<Activity>> getActivitiesById(Iterable<String> ids) {
    final token = tokenHelper!.buildActivityToken(secret, TokenAction.read);
    return batch.getActivitiesById(token, ids);
  }

  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesById(
      Iterable<String> ids) {
    final token = tokenHelper!.buildActivityToken(secret, TokenAction.read);
    return batch.getEnrichedActivitiesById(token, ids);
  }

  Future<Iterable<Activity>> getActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs) {
    final token = tokenHelper!.buildActivityToken(secret, TokenAction.read);
    return batch.getActivitiesByForeignId(token, pairs);
  }

  Future<Iterable<EnrichedActivity>> getEnrichedActivitiesByForeignId(
      Iterable<ForeignIdTimePair> pairs) {
    final token = tokenHelper!.buildActivityToken(secret, TokenAction.read);
    return batch.getEnrichedActivitiesByForeignId(token, pairs);
  }

  Future<void> updateActivity(Activity activity) =>
      updateActivities([activity]);

  Future<void> updateActivities(Iterable<Activity> activities) {
    final token = tokenHelper!.buildActivityToken(secret, TokenAction.write);
    return batch.updateActivities(token, activities);
  }
}
