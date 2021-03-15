import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/client/file_storage_client.dart';
import 'package:stream_feed_dart/src/client/image_storage_client.dart';
import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';
import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';

import 'package:stream_feed_dart/src/client/feed/index.dart';

abstract class StreamClient {
  factory StreamClient.connect(
    String apiKey,
    String secret, {
    StreamClientOptions? options,
  }) =>
      StreamClientImpl(secret, apiKey,
          options: options ?? StreamClientOptions());

  BatchOperationsClient get batch;

  CollectionsClient get collections;

  ReactionsClient get reactions;

  UsersClient get users;

  FileStorageClient get files;

  ImageStorageClient get images;

  FlatFeet flatFeed(String slug, String userId);

  AggregatedFeed aggregatedFeed(String slug, String userId);

  NotificationFeed notificationFeed(String slug, String userId);

  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  });

  Future<OpenGraphData> openGraph(String targetUrl);
}
