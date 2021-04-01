import 'package:stream_feed_dart/src/client/aggregated_feed.dart';
import 'package:stream_feed_dart/src/client/flat_feed.dart';
import 'package:stream_feed_dart/src/client/notification_feed.dart';
import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/client/file_storage_client.dart';
import 'package:stream_feed_dart/src/client/image_storage_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';

import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';

//TODO: stream_feed_dart/src/cloud/cloud.dart
abstract class StreamClient {
  factory StreamClient.connect(
    String apiKey, {
    Token? token,
    String? secret,
    StreamClientOptions? options,
    String? appId
  }) =>
      StreamClientImpl(apiKey,
          userToken: token, secret: secret, options: options,appId:appId);

  BatchOperationsClient get batch;
  CollectionsClient get collections;

  ReactionsClient get reactions;

  UsersClient get users;

  FileStorageClient get files;

  ImageStorageClient get images;

  FlatFeed flatFeed(String slug, String userId);

  AggregatedFeed aggregatedFeed(String slug, String userId);

  NotificationFeed notificationFeed(String slug, String userId);

  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  });

  Future<OpenGraphData> openGraph(String targetUrl);
}
