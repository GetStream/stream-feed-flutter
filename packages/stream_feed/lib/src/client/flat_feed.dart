import 'package:faye_dart/faye_dart.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/enriched_activity.dart';
import 'package:stream_feed_dart/src/core/models/enrichment_flags.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/models/filter.dart';
import 'package:stream_feed_dart/src/core/util/default.dart';

import 'package:stream_feed_dart/src/client/feed.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class FlatFeed extends Feed {
  FlatFeed(FeedId feedId, FeedApi feed,
      {Token? userToken,
      String? secret,
      String? appId,
      String? apiKey,
      FayeClient? faye})
      : super(feedId, feed,
            userToken: userToken,
            secret: secret,
            appId: appId,
            apiKey: apiKey,
            faye: faye);

  Future<List<Activity>> getActivities({
    int? limit,
    int? offset,
    Filter? filter,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => Activity.fromJson(e))
        .toList(growable: false);
    return data;
  }

  Future<List<EnrichedActivity>> getEnrichedActivities({
    int? limit,
    int? offset,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...Default.marker.params,
      if (ranking != null) 'ranking': ranking,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => EnrichedActivity.fromJson(e))
        .toList(growable: false);
    return data;
  }
}
