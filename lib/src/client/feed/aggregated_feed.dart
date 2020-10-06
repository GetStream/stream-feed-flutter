import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/activity_marker.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'feed.dart';

class AggregatedFeed extends Feed {
  const AggregatedFeed(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);

  Future<List<Group<Activity>>> getActivities({
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
    feed.getActivities(token, feedId, options);
  }

  Future<List<Group<EnrichedActivity>>> getEnrichedActivities({
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
