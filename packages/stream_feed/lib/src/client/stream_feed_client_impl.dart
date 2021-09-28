import 'package:faye_dart/faye_dart.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/client/batch_operations_client.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/src/client/personalization_client.dart';
import 'package:stream_feed/src/client/reactions_client.dart';
import 'package:stream_feed/src/client/stream_feed_client.dart';
import 'package:stream_feed/src/client/stream_user.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/stream_api_impl.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

///{@macro stream_feed_client}
class StreamFeedClientImpl extends StreamFeedBaseImpl
    implements StreamFeedClient {
  /// Builds a [StreamFeedClientImpl].
  ///
  ///{@macro stream_feed_client}
  StreamFeedClientImpl(
    String apiKey, {
    String? appId,
    StreamHttpClientOptions? options,
    StreamAPI? api,
    required String fayeUrl,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  }) : super(
          apiKey,
          appId: appId,
          options: options,
          runner: Runner.client,
          api: api,
          fayeUrl: fayeUrl,
          logLevel: logLevel,
          logHandlerFunction: logHandlerFunction,
        );

  late StreamUser _currentUser;

  /// Determines if the [_currentUser] is connected by validating that
  /// `StreamUser.createdAt` is not null.
  bool get _userConnected => _currentUser.createdAt != null;

  String _getUserId() {
    _validateCurrentUserIsSet();
    return currentUser!.id;
  }

  void _validateCurrentUserIsSet() {
    if (!_userConnected || userToken == null) {
      throw AssertionError(
        'No user connected, call `setCurrentUser` before creating feeds',
      );
    }
  }

  @override
  Future<StreamUser> setCurrentUser(
    User user,
    Token userToken, {
    Map<String, Object?>? extraData,
  }) async {
    this.userToken = userToken;
    return _currentUser = await this.user(user.id!).getOrCreate(extraData);
  }

  @override
  StreamUser? get currentUser => _currentUser;

  @override
  FlatFeed flatFeed(
    String slug,
  ) {
    return flatFeedBase(slug, userId: _getUserId());
  }

  @override
  AggregatedFeed aggregatedFeed(
    String slug,
  ) {
    return aggregatedFeedBase(slug, userId: _getUserId());
  }

  @override
  NotificationFeed notificationFeed(String slug, {String? userId}) {
    return notificationFeedBase(slug, userId: _getUserId());
  }

  @override
  Future<User> createUser(String id, Map<String, Object?> data,
      {bool getOrCreate = false}) {
    _logger.warning('We advice using `createUser` only server-side');
    _validateCurrentUserIsSet();
    return super.createUser(id, data, getOrCreate: getOrCreate);
  }

  @override
  Future<User> getUser(String id, {bool withFollowCounts = false}) {
    _logger.warning('We advice using `getUser` only server-side');
    _validateCurrentUserIsSet();
    return super.getUser(id, withFollowCounts: withFollowCounts);
  }

  @override
  Future<User> updateUser(String id, Map<String, Object?> data) {
    _logger.warning('We advice using `updateUser` only server-side');
    _validateCurrentUserIsSet();
    return super.updateUser(id, data);
  }

  @override
  Future<void> deleteUser(String id) {
    _logger.warning('We advice using `deleteUser` only server-side');
    _validateCurrentUserIsSet();
    return super.deleteUser(id);
  }
}

/// {@macro stream_feed_server}
class StreamFeedServerImpl extends StreamFeedBaseImpl
    implements StreamFeedServer {
  /// Builds a [StreamFeedServerImpl].
  ///
  /// {@macro stream_feed_server}
  StreamFeedServerImpl(
    String apiKey, {
    required String secret,
    String? appId,
    StreamHttpClientOptions? options,
    StreamAPI? api,
    required String fayeUrl,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
  }) : super(
          apiKey,
          secret: secret,
          appId: appId,
          options: options,
          runner: Runner.server,
          api: api,
          fayeUrl: fayeUrl,
          logLevel: logLevel,
          logHandlerFunction: logHandlerFunction,
        );

  @override
  BatchOperationsClient get batch =>
      BatchOperationsClient(_api.batch, secret: secret!);

  @override
  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  }) {
    return TokenHelper.buildFrontendToken(
      secret!,
      userId,
      expiresAt: expiresAt,
    );
  }

  @override
  FlatFeed flatFeed(String slug, {required String userId}) {
    return flatFeedBase(slug, userId: userId);
  }

  @override
  AggregatedFeed aggregatedFeed(String slug, {required String userId}) {
    return aggregatedFeedBase(slug, userId: userId);
  }

  @override
  NotificationFeed notificationFeed(String slug, {required String userId}) {
    return notificationFeedBase(slug, userId: userId);
  }
}

///{@macro stream_feed_base}
class StreamFeedBaseImpl implements StreamFeedBase {
  /// Builds a [StreamFeedClientImpl].
  ///
  ///{@macro stream_feed_base}
  StreamFeedBaseImpl(
    this.apiKey, {
    this.secret,
    this.appId,
    required this.fayeUrl,
    required this.runner,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
    StreamAPI? api,
    StreamHttpClientOptions? options,
  }) {
    assert(_ensureCredentials(), '');
    _logger = Logger.detached('📜')..level = logLevel;
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
    _logger.info('instantiating new client: $runner');

    _api = api ?? StreamApiImpl(apiKey, logger: _logger, options: options);
  }

  bool _ensureCredentials() {
    assert(() {
      switch (runner) {
        case Runner.server:
          if (secret == null) {
            throw AssertionError(
              '`secret` must be provided while running server-side',
            );
          }
          break;
        case Runner.client:
          if (secret != null) {
            throw AssertionError(
              'You are publicly sharing your App Secret. '
              'Do not expose the App Secret in `browsers`, '
              '`native` mobile apps, or other non-trusted environments. ',
            );
          }
          break;
      }
      return true;
    }(), '');
    return true;
  }

  /// Stream Feed App API Key.
  ///
  /// A unique identifier for each app. Can be retrieved from the Stream
  /// Dashboard.
  final String apiKey;

  /// Stream Feed App ID.
  ///
  /// Can be retrieved from the Stream Dashboard.
  final String? appId;

  /// Stream Feed API User Auth Token. Used to perform operations on behalf
  /// of a user.
  ///
  /// Tokens can be generated using any Stream server-side SDK.
  Token? userToken;

  /// Stream Feed API secret. Used to perform sensitive operations.
  ///
  /// Can be retrieved from the Stream Dashboard.
  final String? secret;

  /// {@macro faye_url}
  final String fayeUrl;

  /// {@macro runner}
  @override
  final Runner runner;

  late final StreamAPI _api;
  late final Logger _logger;

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  late final _authExtension = <String, MessageHandler>{
    'outgoing': (message) {
      final subscription = _subscriptions[message.subscription];
      if (subscription != null) {
        message.ext = {
          'user_id': subscription.userId,
          'api_key': apiKey,
          'signature': subscription.token,
        };
      }
      return message;
    },
  };

  late final FayeClient _faye = FayeClient(fayeUrl)
    ..addExtension(_authExtension);

  late final _subscriptions = <String, _FeedSubscription>{};

  Future<Subscription> _feedSubscriber(
    Token token,
    FeedId feedId,
    MessageDataCallback callback,
  ) async {
    checkNotNull(
      appId,
      'Missing app id, which is needed in order to subscribe to a feed',
    );
    final claim = feedId.claim;
    final notificationChannel = 'site-$appId-feed-$claim';
    _subscriptions['/$notificationChannel'] = _FeedSubscription(
      token: token.toString(),
      userId: notificationChannel,
    );
    final subscription = await _faye.subscribe(
      '/$notificationChannel',
      callback: callback,
    );
    _subscriptions.update(
      '/$notificationChannel',
      (it) => it.copyWith(fayeSubscription: subscription),
    );
    return subscription;
  }

  // TODO(Gordon): Should these be cached once created.
  @override
  CollectionsClient get collections =>
      CollectionsClient(_api.collections, userToken: userToken, secret: secret);

  @override
  ReactionsClient get reactions =>
      ReactionsClient(_api.reactions, userToken: userToken, secret: secret);

  @override
  PersonalizationClient get personalization =>
      PersonalizationClient(_api.personalization,
          userToken: userToken, secret: secret);

  @override
  StreamUser user(String userId) =>
      StreamUser(_api.users, userId, userToken: userToken, secret: secret);

  @override
  FileStorageClient get files =>
      FileStorageClient(_api.files, userToken: userToken, secret: secret);

  @override
  ImageStorageClient get images =>
      ImageStorageClient(_api.images, userToken: userToken, secret: secret);

  @protected
  @override
  AggregatedFeed aggregatedFeedBase(
    String slug, {
    required String userId,
    Token? userToken,
  }) {
    final id = FeedId(slug, userId);
    return AggregatedFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @protected
  @override
  FlatFeed flatFeedBase(
    String slug, {
    String? userId,
    Token? userToken,
  }) {
    final id = FeedId(slug, userId!);
    return FlatFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @protected
  @override
  NotificationFeed notificationFeedBase(
    String slug, {
    required String userId,
    Token? userToken,
  }) {
    final id = FeedId(slug, userId);
    return NotificationFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @override
  Future<OpenGraphData> og(String targetUrl) {
    final token = userToken ?? TokenHelper.buildOpenGraphToken(secret!);
    return _api.openGraph(token, targetUrl);
  }

  @override
  Future<User> createUser(
    String id,
    Map<String, Object?> data, {
    bool getOrCreate = false,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.create(token, id, data, getOrCreate: getOrCreate);
  }

  @override
  Future<User> getUser(String id, {bool withFollowCounts = false}) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.read);
    return _api.users.get(token, id, withFollowCounts: withFollowCounts);
  }

  @override
  Future<User> updateUser(String id, Map<String, Object?> data) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.update(token, id, data);
  }

  @override
  Future<void> deleteUser(String id) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.delete);
    return _api.users.delete(token, id);
  }
}

class _FeedSubscription {
  const _FeedSubscription({
    required this.token,
    required this.userId,
    this.fayeSubscription,
  });

  _FeedSubscription copyWith({
    String? token,
    String? userId,
    Subscription? fayeSubscription,
  }) =>
      _FeedSubscription(
        token: token ?? this.token,
        userId: userId ?? this.userId,
        fayeSubscription: fayeSubscription ?? this.fayeSubscription,
      );

  final String token;
  final String userId;
  final Subscription? fayeSubscription;
}
