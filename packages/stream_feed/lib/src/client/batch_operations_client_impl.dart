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

  @override
  Future<void> addToMany(Activity activity, Iterable<FeedId> feedIds) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.write);
    return batch.addToMany(token, activity, feedIds);
  }

  @override
  Future<void> followMany(
    Iterable<Follow> follows, {
    int activityCopyLimit,
  }) {
    final token = TokenHelper.buildFollowToken(secret, TokenAction.write);
    return batch.followMany(
        token, activityCopyLimit ?? Default.activityCopyLimit, follows);
  }

  @override
  Future<void> unfollowMany(
    Iterable<Follow> unfollows, {
    bool keepHistory = true,
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
