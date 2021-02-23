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

import 'cloud_aggregated_feed.dart';

class CloudNotificationFeed extends CloudAggregatedFeed {
  const CloudNotificationFeed(Token token, FeedId feedId, FeedApi feed)
      : super(token, feedId, feed);

  @override
  Future<List<NotificationGroup<Activity>>> getActivities({
    int limit,
    int offset,
    Filter filter,
    ActivityMarker marker,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) =>
            NotificationGroup.fromJson(e, (json) => Activity.fromJson(json)))
        .toList(growable: false);
    return data;
  }

  @override
  Future<List<NotificationGroup<EnrichedActivity>>> getEnrichedActivities({
    int limit,
    int offset,
    Filter filter,
    ActivityMarker marker,
    EnrichmentFlags flags,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
    };
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => NotificationGroup.fromJson(
            e, (json) => EnrichedActivity.fromJson(json)))
        .toList(growable: false);
    return data;
  }
}
