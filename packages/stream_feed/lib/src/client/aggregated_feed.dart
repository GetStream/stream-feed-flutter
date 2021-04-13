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

import 'package:stream_feed_dart/src/client/feed.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class AggregatedFeed extends Feed {
  AggregatedFeed(FeedId feedId, FeedApi feed,
      {Token? userToken, String? secret, TokenHelper? tokenHelper})
      : super(feedId, feed,
            userToken: userToken, secret: secret, tokenHelper: tokenHelper);

  Future<List<Group<Activity>>> getActivities({
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

    final token = userToken ??
        tokenHelper!.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => Group.fromJson(
            e, (json) => Activity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }

  Future<List<Group<EnrichedActivity>>> getEnrichedActivities({
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
    final token = userToken ??
        tokenHelper!.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => Group.fromJson(e,
            (json) => EnrichedActivity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }
}
