import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/src/client/batch_operations_client.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart';

import 'package:stream_feed/src/client/reactions_client.dart';
import 'package:stream_feed/src/client/user_client.dart';
import 'package:stream_feed/src/client/stream_client_impl.dart';

/// The client class that manages API calls and authentication
/// To instantiate the client you need an API key and secret.
/// You can find the key and secret on the dashboard.
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
    String? appId,
    StreamHttpClientOptions? options,
  }) =>
      StreamClientImpl(
        apiKey,
        userToken: token,
        secret: secret,
        appId: appId,
        options: options,
      );

  /// Convenient getter for [BatchOperationsClient]
  BatchOperationsClient get batch;

  /// Convenient getter for [CollectionsClient]
  CollectionsClient get collections;

  /// Convenient getter for [ReactionsClient]
  ReactionsClient get reactions;

  /// Convenient getter for [UsersClient]
  UserClient user(String userId);

  /// Convenient getter for [FileStorageClient]
  FileStorageClient get files;

  /// Convenient getter for [ImageStorageClient]
  ImageStorageClient get images;

  /// Convenient getter for [FlatFeed]
  FlatFeed flatFeed(String slug, [String? userId]);

  /// Convenient getter for [AggregatedFeed]
  AggregatedFeed aggregatedFeed(String slug, [String? userId]);

  /// Convenient getter for [NotificationFeed]
  NotificationFeed notificationFeed(String slug, [String? userId]);

  /// Generate a JWT tokens that include the [userId] as payload
  /// and that are signed using your Stream API Secret.
  ///
  /// Optionally you can have tokens expire after a certain amount of time.
  ///
  /// By default all SDK libraries generate user tokens
  /// without an expiration time.
  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  });

  ///This endpoint allows you to retrieve open graph information from a URL
  ///which you can then use to add images and a description to activities.
  ///
  ///For example:
  ///```dart
  /// final urlPreview = await client.openGraph(
  ///   'http://www.imdb.com/title/tt0117500/',
  /// );
  /// ```
  Future<OpenGraphData> og(String targetUrl);
}
