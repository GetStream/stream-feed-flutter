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
  /// If you want to use the API client directly on your web/mobile app
  /// you need to generate a user token server-side and pass it.
  ///
  ///
  /// - Instantiate a new client (server side) with [StreamClient.connect]
  /// using your api [secret] parameter and [apiKey]
  /// ```dart
  /// var client = connect('YOUR_API_KEY',secret: 'API_KEY_SECRET');
  /// ```
  /// - Create a token for user with id "the-user-id"
  /// ```dart
  /// var userToken = client.frontendToken('the-user-id');
  /// ```
  /// - if you are using the SDK client side, get a userToken in your dashboard
  /// and pass it to [StreamClient.connect] using the [token] parameter
  /// and [apiKey]
  /// ```dart
  /// var client = connect('YOUR_API_KEY',token: Token('userToken'));
  /// ```
  factory StreamClient.connect(
    String apiKey, {
    Token? token,
    String? secret,
    StreamClientOptions? options,
  }) =>
      StreamClientImpl(apiKey,
          userToken: token, secret: secret, options: options);

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
