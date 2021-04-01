import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';

import 'package:stream_feed_dart/src/client/aggregated_feed.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class NotificationFeed extends AggregatedFeed {
  const NotificationFeed(FeedId feedId, FeedApi feed,
      {Token? userToken, String? secret, String? appId})
      : super(feedId, feed, userToken: userToken, secret: secret, appId: appId);

  @override
  Future<List<NotificationGroup<Activity>>> getActivities({
    int? limit,
    int? offset,
    Filter? filter,
    ActivityMarker? marker,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };
    final token = TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => NotificationGroup.fromJson(
            e, (json) => Activity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }

  @override
  Future<List<NotificationGroup<EnrichedActivity>>> getEnrichedActivities({
    int? limit,
    int? offset,
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
    final token = TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => NotificationGroup.fromJson(e,
            (json) => EnrichedActivity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }
}
