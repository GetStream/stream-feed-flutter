import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_update.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/follow.dart';
import 'package:stream_feed/src/core/models/follow_stats.dart';
import 'package:stream_feed/src/core/models/paginated_activities.dart';
import 'package:stream_feed/src/core/models/paginated_activities_group.dart';
import 'package:stream_feed/src/core/models/personalized_feed.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Feeds
class FeedAPI {
  /// Builds a [FeedAPI].
  const FeedAPI(this._client);

  final StreamHttpClient _client;

  /// Adds the given activities to the feed
  Future<List<Activity>> addActivities(
    Token token,
    FeedId feed,
    Iterable<Activity> activities,
  ) async {
    checkArgument(activities.isNotEmpty, 'No activities to add');
    final result = await _client.post<Map>(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: {'activities': activities},
    );
    final data = (result.data!['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Adds the given [Activity] to the feed
  Future<Activity> addActivity(
    Token token,
    FeedId feed,
    Activity activity,
  ) async {
    final result = await _client.post<Map>(
      Routes.buildFeedUrl(feed),
      headers: {'Authorization': '$token'},
      data: activity.toJson(),
    );
    final data = Activity.fromJson(result.data as Map<String, dynamic>?);
    return data;
  }

  /// Follows the given target feed
  Future<Response> follow(
    Token token,
    Token targetToken,
    FeedId sourceFeed,
    FeedId targetFeed,
    int activityCopyLimit,
  ) async {
    checkArgument(sourceFeed != targetFeed, "Feed can't follow itself");
    checkArgument(activityCopyLimit >= 0,
        'Activity copy limit should be a non-negative number');
    checkArgument(
      activityCopyLimit <= Default.maxActivityCopyLimit,
      'Activity copy limit should be less then ${Default.maxActivityCopyLimit}',
    );
    return _client.post(
      Routes.buildFeedUrl(sourceFeed, 'following'),
      headers: {'Authorization': '$token'},
      data: {
        'target': '$targetFeed',
        'activity_copy_limit': activityCopyLimit,
        'target_token': '$targetToken',
      },
    );
  }

  /// Retrieve activities
  Future<Response<Map>> getActivities(
    Token token,
    FeedId feed,
    Map<String, Object?> options,
  ) =>
      _client.get<Map>(
        Routes.buildFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      );

  /// Retrieve paginated activities
  Future<PaginatedActivities<A, Ob, T, Or>> paginatedActivities<A, Ob, T, Or>(
    Token token,
    FeedId feed,
    Map<String, Object?> options,
  ) async {
    final response = await _client.get<Map>(
      Routes.buildEnrichedFeedUrl(feed),
      headers: {'Authorization': '$token'},
      queryParameters: options,
    );
    return PaginatedActivities<A, Ob, T, Or>.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Retrieve paginated activities
  Future<PaginatedActivitiesGroup<A, Ob, T, Or>>
      paginatedActivitiesGroup<A, Ob, T, Or>(
    Token token,
    FeedId feed,
    Map<String, Object?> options,
  ) async {
    final response = await _client.get<Map>(
      Routes.buildEnrichedFeedUrl(feed),
      headers: {'Authorization': '$token'},
      queryParameters: options,
    );
    return PaginatedActivitiesGroup<A, Ob, T, Or>.fromJson(
        response.data as Map<String, dynamic>);
  }

  /// Retrieve the number of followers and following feed stats of the current
  /// feed.
  ///
  /// For each count, feed slugs can be provided to filter counts accordingly.
  Future<FollowStats> followStats(
    Token token,
    Map<String, Object?> options,
  ) async {
    final response = await _client.get<Map>(Routes.statsFollowUrl,
        headers: {'Authorization': '$token'}, queryParameters: options);
    return FollowStats.fromJson(response.data!['results']);
  }

  /// Retrieve activities with reaction enrichment
  Future<Response> getEnrichedActivities(
    Token token,
    FeedId feed,
    Map<String, Object?> options,
  ) =>
      _client.get(
        Routes.buildEnrichedFeedUrl(feed),
        headers: {'Authorization': '$token'},
        queryParameters: options,
      );

  /// List which feeds this feed is following
  Future<List<Follow>> following(
    Token token,
    FeedId feed,
    int limit,
    int offset,
    Iterable<FeedId> feedIds,
  ) async {
    checkArgument(limit >= 0, 'Limit should be a non-negative number');
    checkArgument(offset >= 0, 'Offset should be a non-negative number');

    final result = await _client.get<Map>(
      Routes.buildFeedUrl(feed, 'following'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (feedIds.isNotEmpty)
          'filter': feedIds.map((it) => it.toString()).join(',')
      },
    );
    final data = (result.data!['results'] as List)
        .map((e) => Follow.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// List the followers of this feed
  Future<List<Follow>> followers(
    Token token,
    FeedId feed,
    int limit,
    int offset,
    Iterable<FeedId> feedIds,
  ) async {
    checkArgument(limit >= 0, 'Limit should be a non-negative number');
    checkArgument(offset >= 0, 'Offset should be a non-negative number');

    final result = await _client.get(
      Routes.buildFeedUrl(feed, 'followers'),
      headers: {'Authorization': '$token'},
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (feedIds.isNotEmpty)
          'filter': feedIds.map((it) => it.toString()).join(',')
      },
    );
    final data = (result.data['results'] as List)
        .map((e) => Follow.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Remove an Activity by referencing its foreign_id
  Future<Response> removeActivityByForeignId(
    Token token,
    FeedId feed,
    String foreignId,
  ) =>
      _client.delete(
        Routes.buildFeedUrl(feed, foreignId),
        headers: {'Authorization': '$token'},
        queryParameters: {'foreign_id': '1'},
      );

  /// Removes the activity by activityId
  Future<Response> removeActivityById(Token token, FeedId feed, String id) =>
      _client.delete(
        Routes.buildFeedUrl(feed, id),
        headers: {'Authorization': '$token'},
      );

  /// Unfollow the given feed
  Future<Response> unfollow(
    Token token,
    FeedId source,
    FeedId target, {
    bool keepHistory = false,
  }) =>
      _client.delete(
        Routes.buildFeedUrl(source, 'following/$target'),
        headers: {'Authorization': '$token'},
        queryParameters: {'keep_history': keepHistory},
      );

  /// Update Activities By `foreignId`.
  ///
  /// Note: the keys of set and unset must not be identical.
  Future<List<Activity>> updateActivitiesByForeignId(
      Token token, Iterable<ActivityUpdate> updates) async {
    checkArgument(updates.isNotEmpty, 'No updates');
    checkArgument(updates.length <= 100, 'Maximum length is 100');
    for (final update in updates) {
      checkNotNull(update.foreignId, 'No activity to update');
      checkNotNull(update.time, 'Missing timestamp');
      checkArgument(
        update.set?.isNotEmpty == true || update.unset?.isNotEmpty == true,
        'No activity properties to set or unset',
      );
    }
    final result = await _client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    final data = (result.data!['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Update Activities By `id`.
  ///
  /// Note: the keys of set and unset must not be identical.
  Future<List<Activity>> updateActivitiesById(
      Token token, Iterable<ActivityUpdate> updates) async {
    checkArgument(updates.isNotEmpty, 'No updates');
    checkArgument(updates.length <= 100, 'Maximum length is 100');
    for (final update in updates) {
      checkNotNull(update.id, 'No activity to update');
      checkArgument(
        update.set?.isNotEmpty == true || update.unset?.isNotEmpty == true,
        'No activity properties to set or unset',
      );
    }
    final result = await _client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {'changes': updates},
    );
    final data = (result.data!['activities'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Update [Activity.foreignId] By `foreignId`.
  ///
  /// Note: the keys of set and unset must not be identical.
  Future<Activity> updateActivityByForeignId(
      Token token, ActivityUpdate update) async {
    checkNotNull(update.foreignId, 'No activity to update');
    checkNotNull(update.time, 'Missing timestamp');
    checkArgument(
      update.set?.isNotEmpty == true || update.unset?.isNotEmpty == true,
      'No activity properties to set or unset',
    );
    final result = await _client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    final data = Activity.fromJson(result.data as Map<String, dynamic>?);
    return data;
  }

  /// Partial update by activity ID.
  ///
  /// Note: the keys of set and unset must not be identical.
  Future<Activity> updateActivityById(
      Token token, ActivityUpdate update) async {
    checkNotNull(update.id, 'No activity to update');
    checkArgument(
      update.set?.isNotEmpty == true || update.unset?.isNotEmpty == true,
      'No activity properties to set or unset',
    );
    final result = await _client.post<Map>(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: update,
    );
    final data = Activity.fromJson(result.data as Map<String, dynamic>?);
    return data;
  }

  /// Updates an activity's [Activity.to] fields.
  ///
  /// Note: the keys of set and unset must not be identical.
  Future<Response> updateActivityToTargets(
    Token token,
    FeedId feed,
    ActivityUpdate update, {
    Iterable<FeedId> add = const [],
    Iterable<FeedId> remove = const [],
    Iterable<FeedId> replace = const [],
  }) async {
    checkArgument(
      update.set?.isNotEmpty == true || update.unset?.isNotEmpty == true,
      'No activity properties to set or unset',
    );
    checkNotNull(
      update.foreignId,
      'Activity is required to have foreign ID attribute',
    );
    checkNotNull(update.time, 'Activity is required to have time attribute');
    final modification =
        replace.isEmpty && (add.isNotEmpty || remove.isNotEmpty);
    final replacement = replace.isNotEmpty && add.isEmpty && remove.isEmpty;
    checkArgument(modification || replacement,
        "Can't replace and modify activity to targets at the same time");

    return _client.post(
      Routes.activityUpdateUrl,
      headers: {'Authorization': '$token'},
      data: {
        'foreign_id': update.foreignId,
        'time': update.time!.toIso8601String(),
        'added_targets': add.map((it) => it.toString()).toList(),
        'removed_targets': remove.map((it) => it.toString()).toList(),
        'new_targets': replace.map((it) => it.toString()).toList(),
      },
    );
  }

  /// {@macro personalizedFeed}
  Future<PersonalizedFeed<A, Ob, T, Or>> personalizedFeed<A, Ob, T, Or>(
    Token token,
    Map<String, Object> options,
  ) async {
    final response = await _client.get(
      Routes.personalizedFeedUrl,
      headers: {'Authorization': '$token'},
      queryParameters: options,
    );
    return PersonalizedFeed<A, Ob, T, Or>.fromJson(response.data!);
  }
}
