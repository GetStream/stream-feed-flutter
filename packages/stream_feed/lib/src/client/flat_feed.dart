import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/models/personalized_feed.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:stream_feed/stream_feed.dart';

/// {@template flatFeed}
/// Flat is the default feed type - and the only feed type that you can follow.
///
/// It's not possible to follow either aggregated or notification feeds.
///
/// You can create new feed groups based on the flat type in the dashboard.
/// {@endtemplate}
class FlatFeed extends Feed {
  /// Initialize a feed object
  const FlatFeed(
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
  Future<Activity> getActivityDetail(String activityId) async {
    final activities = await getActivities(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  /// Retrieves one enriched activity from a feed
  Future<GenericEnrichedActivity<A, Ob, T, Or>>
      getEnrichedActivityDetail<A, Ob, T, Or>(String activityId) async {
    final activities = await getEnrichedActivities<A, Ob, T, Or>(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  /// Retrieve activities
  ///
  /// # Example:
  ///  Read Jack's timeline
  /// ```dart
  ///  var activities = await jack.getActivities(limit: 10);
  /// ```
  ///
  /// {@macro filter}
  Future<List<Activity>> getActivities({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// Retrieve activities with reaction enrichment
  ///
  /// # Examples
  /// - read bob's timeline and include most recent reactions
  /// to all activities and their total count
  /// ```dart
  /// await client.flatFeed('timeline', 'bob').getEnrichedActivities(
  ///   flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
  /// );
  /// ```
  /// - read bob's timeline and include most recent reactions
  /// to all activities and her own reactions
  /// ```dart
  /// await client.flatFeed('timeline', 'bob').getEnrichedActivities(
  ///   flags: EnrichmentFlags()
  ///     .withOwnReactions()
  ///     .withRecentReactions()
  ///     .withReactionCounts(),
  /// );
  /// ```
  ///
  /// {@macro filter}
  Future<List<GenericEnrichedActivity<A, Ob, T, Or>>>
      getEnrichedActivities<A, Ob, T, Or>({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking, //TODO: no way to parameterized marker?
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset, //TODO:add session everywhere
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (flags != null) ...flags.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => GenericEnrichedActivity<A, Ob, T, Or>.fromJson(e))
        .toList(growable: false);
    return data;
  }

  /// ```dart
  /// final paginated = await flatFeed.getPaginatedEnrichedActivities();
  /// final nextParams = parseNext(paginated.next!);
  /// //parse next page
  /// await flatFeed.getPaginatedEnrichedActivities(limit: nextParams.limit,filter: nextParams.idLT);
  /// ```
  Future<PaginatedActivities<A, Ob, T, Or>>
      getPaginatedEnrichedActivities<A, Ob, T, Or>({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking, //TODO: no way to parameterized marker?
  }) {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset, //TODO:add session everywhere
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (flags != null) ...flags.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    return feed.paginatedActivities(token, feedId, options);
  }

  /// {@template personalizedFeed}
  /// Retrieve a personalized feed for the currentUser
  /// i.e. a feed of based on user's activities.
  /// {@endtemplate}
  ///
  /// # Example:
  /// - get a feed of activities from the current user
  /// ```dart
  /// var feed = await client.flatFeed('timeline').personalizedFeed();
  ///
  /// {@macro filter}
  Future<PersonalizedFeed> personalizedFeed({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
    EnrichmentFlags? flags,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      if (ranking != null) 'ranking': ranking,
      if (session != null) 'session': session,
    };
    final token = userToken ??
        TokenHelper.buildAnyToken(secret!, TokenAction.any,
            userId: feedId.userId);

    return feed.personalizedFeed(token, options);
  }
}
