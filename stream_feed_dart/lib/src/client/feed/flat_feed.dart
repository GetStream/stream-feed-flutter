import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'feed.dart';

class FlatFeet extends Feed {
  const FlatFeet(String secret, FeedId id, FeedApi feed)
      : super(secret, id, feed);

  Future<List<Activity>> getActivities({
    int limit,
    int offset,
    Filter filter,
    String ranking,
  }) async {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
    };
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  Future<List<EnrichedActivity>> getEnrichedActivities({
    int limit,
    int offset,
    Filter filter,
    EnrichmentFlags flags,
    String ranking,
  }) async {
    final token = TokenHelper.buildFeedToken(secret, TokenAction.read, feedId);
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
    };
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(e))
        .toList(growable: false);
    return data;
  }
}
