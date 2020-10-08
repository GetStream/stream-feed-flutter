import 'package:stream_feed_dart/src/client/feed/aggregated_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class NotificationFeed extends AggregatedFeed {
  const NotificationFeed(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);

  @override
  Future<List<NotificationGroup<Activity>>> getActivities({
    int limit,
    int offset,
    Filter filter,
    ActivityMarker marker,
  }) async {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
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
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
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
