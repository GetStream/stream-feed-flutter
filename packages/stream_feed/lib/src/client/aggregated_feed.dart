import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template aggregatedFeed}
/// Aggregated feeds are helpful for grouping activities.
///
/// Here are some examples of what you can achieve using aggregated feeds:
/// - 'Eric followed 10 people'
/// - 'Julie and 14 others liked your photo'
/// {@endtemplate}
class AggregatedFeed extends Feed {
  /// Initialize a [AggregatedFeed] object
  const AggregatedFeed(
    FeedId feedId,
    FeedAPI feed, {
    Token? userToken,
    String? secret,
    FeedSubscriber? subscriber,
  }) : super(
          feedId,
          feed,
          userToken: userToken,
          secret: secret,
          subscriber: subscriber,
        );

  /// Retrieves one activity from a feed
  Future<Group<Activity>> getActivityDetail(String activityId) async {
    final activities = await getActivities(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  /// Retrieve activities of type Aggregated feed
  ///
  /// {@macro filter}
  Future<List<Group<Activity>>> getActivities({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };

    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => Group.fromJson(
            e, (json) => Activity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }

  /// Retrieve activities with reaction enrichment
  ///
  /// {@macro filter}
  Future<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>
      getEnrichedActivities<A, Ob, T, Or>({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
    EnrichmentFlags? flags,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => Group.fromJson(
              e,
              (json) => GenericEnrichedActivity<A, Ob, T, Or>.fromJson(
                json! as Map<String, dynamic>?,
              ),
            ))
        .toList(growable: false);
    return data;
  }

  /// Retrieves one enriched activity from a feed
  Future<Group<GenericEnrichedActivity<A, Ob, T, Or>>>
      getEnrichedActivityDetail<A, Ob, T, Or>(String activityId) async {
    final activities = await getEnrichedActivities<A, Ob, T, Or>(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  Future<PaginatedActivitiesGroup<A, Ob, T, Or>>
      getPaginatedActivities<A, Ob, T, Or>({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
    EnrichmentFlags? flags,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    return feed.paginatedActivitiesGroup(token, feedId, options);
  }
}
