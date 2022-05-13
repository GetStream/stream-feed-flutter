import 'package:equatable/equatable.dart';
import 'package:faye_dart/faye_dart.dart';
import 'package:logging/logging.dart';
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
import 'package:stream_feed/src/core/index.dart';
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
class StreamFeedClientImpl with EquatableMixin implements StreamFeedClient {
  /// Builds a [StreamFeedClientImpl].
  ///{@macro stream_feed_client}
  StreamFeedClientImpl(
    this.apiKey, {
    this.secret,
    this.appId,
    this.fayeUrl = 'wss://faye-us-east.stream-io-api.com/faye',
    this.runner = Runner.client,
    this.logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
    StreamAPI? api,
    StreamHttpClientOptions? options,
  }) {
    _logger = Logger.detached('📜')..level = logLevel;
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
    _logger.info('instantiating new client');

    _api = api ?? StreamApiImpl(apiKey, logger: _logger, options: options);
  }

  bool _ensureCredentials() {
    assert(() {
      if (secret == null && userToken == null) {
        throw AssertionError('At least a secret or userToken must be provided');
      }
      switch (runner) {
        case Runner.server:
          if (secret == null) {
            throw AssertionError(
              '`secret` must be provided while running on server-side',
            );
          }
          break;
        case Runner.client:
          if (userToken == null) {
            throw AssertionError(
              '`userToken` must be provided while running on client-side '
              'please make sure to call client.setUser',
            );
          }
          if (secret != null) {
            throw AssertionError(
              'You are publicly sharing your App Secret. '
              'Do not expose the App Secret in `browsers`, '
              '`native` mobile apps, or other non-trusted environments.',
            );
          }
          break;
      }
      return true;
    }(), '');
    return true;
  }

  final Level logLevel;
  final String apiKey;
  final String? appId;
  Token? userToken;
  final String? secret;
  final String fayeUrl;
  final Runner runner;
  late StreamAPI _api;
  late final Logger _logger;

  void _defaultLogHandler(LogRecord record) {
    print(
      '(${record.time}) '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message}',
    );
    if (record.stackTrace != null) print(record.stackTrace);
  }

  StreamUser? _currentUser;

  bool get _userConnected => _currentUser?.createdAt != null;

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

  late final FayeClient _faye = FayeClient(fayeUrl, logLevel: logLevel)
    ..addExtension(_authExtension);

  late final _subscriptions = <String, _FeedSubscription>{};

  @override
  StreamUser? get currentUser => _currentUser;

  @override
  Future<StreamUser> setUser(
    User user,
    Token userToken, {
    Map<String, Object?>? extraData,
  }) async {
    this.userToken = userToken;
    final createdUser =
        await this.user(user.id!).getOrCreate(extraData ?? user.data ?? {});
    return _currentUser = await createdUser.profile();
  }

  @override
  BatchOperationsClient get batch {
    assert(_ensureCredentials(), '');
    assert(
      runner == Runner.server,
      "You can't use batch operations client side",
    );
    return BatchOperationsClient(_api.batch, secret: secret!);
  }

  @override
  CollectionsClient get collections {
    assert(_ensureCredentials(), '');
    return CollectionsClient(_api.collections,
        userToken: userToken, secret: secret);
  }

  @override
  ReactionsClient get reactions {
    assert(_ensureCredentials(), '');
    return ReactionsClient(_api.reactions,
        userToken: userToken, secret: secret);
  }

  @override
  PersonalizationClient get personalization {
    assert(_ensureCredentials(), '');
    return PersonalizationClient(_api.personalization,
        userToken: userToken, secret: secret);
  }

  @override
  StreamUser user(String userId) {
    // assert(_ensureCredentials(), '');
    return StreamUser(_api.users, userId, userToken: userToken, secret: secret);
  }

  @override
  FileStorageClient get files {
    assert(_ensureCredentials(), '');
    return FileStorageClient(_api.files, userToken: userToken, secret: secret);
  }

  @override
  ImageStorageClient get images {
    assert(_ensureCredentials(), '');
    return ImageStorageClient(_api.images,
        userToken: userToken, secret: secret);
  }

  Future<Subscription> _feedSubscriber(
    Token token,
    FeedId feedId,
    MessageDataCallback callback,
  ) async {
    checkNotNull(
      appId,
      'Missing app id, which is needed in order to subscribe feed',
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

  String _getUserId([String? userId]) {
    assert(
      _userConnected || userId != null,
      'Provide a `userId` if you are using it server-side '
      'or call `setUser` before creating feeds',
    );
    return userId ??= currentUser!.id;
  }

  @override
  AggregatedFeed aggregatedFeed(
    String slug, [
    String? userId,
    Token? userToken,
  ]) {
    assert(_ensureCredentials(), '');
    final id = FeedId(slug, _getUserId(userId));
    return AggregatedFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @override
  FlatFeed flatFeed(
    String slug, [
    String? userId,
    Token? userToken,
  ]) {
    assert(_ensureCredentials(), '');
    final id = FeedId(slug, _getUserId(userId));
    return FlatFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @override
  NotificationFeed notificationFeed(
    String slug, [
    String? userId,
    Token? userToken,
  ]) {
    assert(_ensureCredentials(), '');
    final id = FeedId(slug, _getUserId(userId));
    return NotificationFeed(
      id,
      _api.feed,
      userToken: userToken ?? this.userToken,
      secret: secret,
      subscriber: _feedSubscriber,
    );
  }

  @override
  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  }) {
    assert(_ensureCredentials(), '');
    assert(
      runner == Runner.server,
      "You can't use the `frontendToken` method client side",
    );
    return TokenHelper.buildFrontendToken(secret!, userId,
        expiresAt: expiresAt);
  }

  @override
  Future<OpenGraphData> og(String targetUrl) {
    assert(_ensureCredentials(), '');
    final token = userToken ?? TokenHelper.buildOpenGraphToken(secret!);
    return _api.openGraph(token, targetUrl);
  }

  @override
  Future<User> createUser(
    String id,
    Map<String, Object?> data, {
    bool getOrCreate = false,
  }) {
    assert(_ensureCredentials(), '');
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.createUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.create(token, id, data, getOrCreate: getOrCreate);
  }

  @override
  Future<User> getUser(String id, {bool withFollowCounts = false}) {
    assert(_ensureCredentials(), '');
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.getUser` only server-side');
    }

    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.read);
    return _api.users.get(token, id, withFollowCounts: withFollowCounts);
  }

  @override
  Future<User> updateUser(String id, Map<String, Object?> data) {
    assert(_ensureCredentials(), '');
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.updateUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.update(token, id, data);
  }

  @override
  Future<void> deleteUser(String id) {
    assert(_ensureCredentials(), '');
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.deleteUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.delete);
    return _api.users.delete(token, id);
  }

  @override
  List<Object?> get props => [
        apiKey,
        appId,
        secret,
        userToken,
        _userConnected,
        _faye,
        _subscriptions,
      ];

  @override
  bool get stringify => true;
}

class _FeedSubscription extends Equatable {
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

  @override
  List<Object?> get props => [token, userId, fayeSubscription];
}
