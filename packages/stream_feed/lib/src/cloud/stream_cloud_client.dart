import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/cloud/cloud_collections_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_file_storage_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_image_storage_client.dart';
import 'package:stream_feed_dart/src/core/index.dart';

import 'package:stream_feed_dart/src/cloud/cloud_reactions_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_users_client.dart';
import 'package:stream_feed_dart/src/cloud/feed/index.dart';
import 'package:stream_feed_dart/src/cloud/stream_cloud_client_impl.dart';

//TODO: stream_feed_dart/src/cloud/cloud.dart
abstract class StreamCloudClient {
  factory StreamCloudClient.connect(
    String apiKey,
    String token, {
    StreamClientOptions? options,
  }) =>
      StreamCloudClientImpl(apiKey, token, options: options);

  CloudCollectionsClient get collections;

  CloudReactionsClient get reactions;

  CloudUsersClient get users;

  CloudFileStorageClient get files;

  CloudImageStorageClient get images;

  CloudFlatFeed flatFeed(String slug, String userId);

  CloudAggregatedFeed aggregatedFeed(String slug, String userId);

  CloudNotificationFeed notificationFeed(String slug, String userId);

  Future<OpenGraphData> openGraph(String targetUrl);
}
