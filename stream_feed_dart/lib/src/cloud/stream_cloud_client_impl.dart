import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

import 'feed/index.dart';
import 'stream_cloud_client.dart';

class StreamCloudClientImpl implements StreamCloudClient {
  final String _token;
  final StreamApi _api;

  StreamCloudClientImpl(
    String apiKey,
    this._token, {
    StreamClientOptions options,
    StreamApi api,
  }) : _api = api ?? StreamApiImpl(apiKey, options: options);

  @override
  CloudAggregatedFeed aggregatedFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    final token = Token(_token);
    return CloudAggregatedFeed(token, id, _api.feed);
  }

  @override
  CloudFlatFeed flatFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    final token = Token(_token);
    return CloudFlatFeed(token, id, _api.feed);
  }

  @override
  CloudNotificationFeed notificationFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    final token = Token(_token);
    return CloudNotificationFeed(token, id, _api.feed);
  }
}
