import 'package:logging/logging.dart';
import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/client/batch_operations_client.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/src/client/personalization_client.dart';
import 'package:stream_feed/src/client/reactions_client.dart';
import 'package:stream_feed/src/client/stream_feed_client_impl.dart';
import 'package:stream_feed/src/client/stream_user.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/index.dart';

/// Different sides on which you can run this [StreamFeedClient] on
enum Runner {
  /// Marks the [StreamFeedClient] that it is currently running on server-side
  server,

  /// Marks the [StreamFeedClient] that it is currently running on client-side
  client,
}

/// {@template stream_feed_client}
/// The client class that manages API calls and authentication.
///
/// To instantiate the client you need an API key and secret.
/// You can find the key and secret on the Stream dashboard.
///
/// If you want to use the API client directly on your web/mobile app
/// you need to generate a user token server-side and pass it.
///
/// There are a few different ways to use a [StreamFeedClient]:
///
/// {@macro connect}
/// {@endtemplate}
abstract class StreamFeedClient {
  /// {@template connect}
  /// - Instantiate a new client (server side) with [StreamFeedClient.connect]
  /// using your api [secret] parameter and [apiKey]
  /// ```dart
  /// var client = StreamFeedClient('YOUR_API_KEY',secret: 'API_KEY_SECRET');
  /// ```
  /// - Create a token for user with id "the-user-id"
  /// ```dart
  /// var userToken = client.frontendToken('the-user-id');
  /// ```
  /// - if you are using the SDK client side, get a userToken in your dashboard
  /// and pass it to [StreamFeedClient] using the [token] parameter
  /// and [apiKey]
  /// ```dart
  /// var client = StreamFeedClient('YOUR_API_KEY',token: Token('userToken'));
  /// ```
  /// {@endtemplate}
  factory StreamFeedClient(
    String apiKey, {
    String? secret,
    String? appId,
    StreamHttpClientOptions? options,
    Runner runner = Runner.client,
    StreamAPI? api,
    String fayeUrl = 'wss://faye-us-east.stream-io-api.com/faye',
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  }) =>
      StreamFeedClientImpl(
        apiKey,
        secret: secret,
        appId: appId,
        options: options,
        runner: runner,
        api: api,
        fayeUrl: fayeUrl,
        logLevel: logLevel,
        logHandlerFunction: logHandlerFunction,
      );

  /// Returns the currentUser assigned to [StreamFeedClient]
  StreamUser? get currentUser;

  /// Sets the [currentUser] assigned to [StreamFeedClient]
  ///
  /// If [extraData] is passed in, the user will be created with that data. If
  /// [extraData] is null, then [User.data] will be used, from `user`.
  ///
  ///
  /// The data will only be set the first time the user is created. Updates
  /// after a user is created needs to be performed with [updateUser].
  ///
  /// This method calls [StreamUser.getOrCreate] underneath.
  Future<StreamUser> setUser(
    User user,
    Token userToken, {
    Map<String, Object?>? extraData,
  });

  /// Convenient getter for [BatchOperationsClient]
  BatchOperationsClient get batch;

  /// Convenient getter for [CollectionsClient]:
  ///
  /// {@macro collections}
  CollectionsClient get collections;

  /// Convenient getter for [ReactionsClient]:
  ///
  /// {@macro reactions}
  ReactionsClient get reactions;

  /// Convenient getter for [UsersClient]:
  ///
  /// {@macro user}
  StreamUser user(String userId);

  /// Convenient getter for [PersonalizationClient]:
  ///
  /// {@macro personalization}
  PersonalizationClient get personalization;

  /// Convenient getter for [FileStorageClient]:
  ///
  /// {@macro filesandimages}
  ///
  /// {@macro files}
  FileStorageClient get files;

  /// Convenient getter for [ImageStorageClient]:
  ///
  /// {@macro filesandimages}
  ImageStorageClient get images;

  /// Convenient getter for [FlatFeed]:
  ///
  /// {@macro flatFeed}
  FlatFeed flatFeed(String slug, [String? userId]);

  /// Convenient getter for [AggregatedFeed]:
  ///
  /// {@macro aggregatedFeed}
  AggregatedFeed aggregatedFeed(String slug, [String? userId]);

  /// Convenient getter for [NotificationFeed]:
  ///
  /// {@macro notificationFeed}
  NotificationFeed notificationFeed(String slug, [String? userId]);

  /// Generate a JWT that includes the [userId] as payload and that is signed
  /// using your Stream API Secret.
  ///
  /// Optionally, you can have tokens expire after a certain amount of time.
  ///
  /// By default, all SDK libraries generate user tokens without an expiration
  /// time.
  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  });

  /// This endpoint allows you to retrieve open graph information from a URL,
  /// which you can then use to add images and a description to activities.
  ///
  /// For example:
  /// ```dart
  /// final urlPreview = await client.og(
  ///   'http://www.imdb.com/title/tt0117500/',
  /// );
  /// ```
  Future<OpenGraphData> og(String targetUrl);

  /// Create a new user in stream
  ///
  /// # Usage
  ///
  /// ```dart
  /// await createUser('john-doe', {
  ///   'name': 'John Doe',
  ///   'occupation': 'Software Engineer',
  ///   'gender': 'male',
  /// });
  /// ```
  /// API docs: [adding-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#adding-users)
  Future<User> createUser(
    String id,
    Map<String, Object?> data, {
    bool getOrCreate = false,
  });

  /// Get the user data
  ///
  /// # Usage
  /// ```dart
  /// await getUser('123');
  /// ```
  /// API docs: [retrieving-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#retrieving-users)
  Future<User> getUser(String id, {bool withFollowCounts = false});

  /// Update the user
  /// # Usage:
  /// ```dart
  ///   await updateUser('123', {
  ///    'name': 'Jane Doe',
  ///    'occupation': 'Software Engineer',
  ///    'gender': 'female',
  ///  });
  /// ```
  /// API docs: [updating-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#updating-users)
  Future<User> updateUser(String id, Map<String, Object?> data);

  /// Delete the user
  ///
  /// # Usage:
  /// ```dart
  /// await deleteUser('123');
  /// ```
  /// API docs: [removing-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#removing-users)
  Future<void> deleteUser(String id);
}
