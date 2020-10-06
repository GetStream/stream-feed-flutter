import 'package:stream_feed_dart/src/client/feed/aggregated_feed.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
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
  }) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };
    feed.getActivities(token, feedId, options);
  }

  @override
  Future<List<NotificationGroup<EnrichedActivity>>> getEnrichedActivities({
    int limit,
    int offset,
    Filter filter,
    ActivityMarker marker,
    EnrichmentFlags flags,
  }) {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
    };
    feed.getEnrichedActivities(token, feedId, options);
  }
}
