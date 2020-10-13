import 'package:stream_feed_dart/src/client/stream_client_options.dart';

import 'feed/index.dart';
import 'stream_cloud_client_impl.dart';

abstract class StreamCloudClient {
  factory StreamCloudClient.connect(
    String apiKey,
    String token, {
    StreamClientOptions options,
  }) =>
      StreamCloudClientImpl(apiKey, token, options: options);

  CloudFlatFeed flatFeed(String slug, String userId);

  CloudAggregatedFeed aggregatedFeed(String slug, String userId);

  CloudNotificationFeed notificationFeed(String slug, String userId);
}
