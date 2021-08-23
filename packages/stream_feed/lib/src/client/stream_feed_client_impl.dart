import 'package:faye_dart/faye_dart.dart';

import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/client/feed.dart';
import 'package:stream_feed/src/client/flat_feed.dart';
import 'package:stream_feed/src/client/notification_feed.dart';
import 'package:stream_feed/src/client/batch_operations_client.dart';
import 'package:stream_feed/src/client/collections_client.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/client/personalization_client.dart';
import 'package:stream_feed/src/client/reactions_client.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/stream_api_impl.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

import 'package:stream_feed/src/client/stream_user.dart';
import 'package:stream_feed/src/client/stream_feed_client.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:logging/logging.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

// ignore: public_member_api_docs
class StreamFeedClientImpl implements StreamFeedClient {
  /// [StreamFeedClientImpl] constructor
  StreamFeedClientImpl(
    this.apiKey, {
    this.secret,
    this.userToken,
    this.appId,
    this.fayeUrl = 'wss://faye-us-east.stream-io-api.com/faye',
    this.runner = Runner.client,
    Level logLevel = Level.WARNING,
    LogHandlerFunction? logHandlerFunction,
    StreamAPI? api,
    StreamHttpClientOptions? options,
  }) {
    assert(_ensureCredentials(), '');
    _logger = Logger.detached('📜')..level = logLevel;
    _logger.onRecord.listen(logHandlerFunction ?? _defaultLogHandler);
    _logger.info('instantiating new client');

    _api = api ?? StreamApiImpl(apiKey, logger: _logger, options: options);

    if (userToken != null) {
      final jwtBody = jwtDecode(userToken!);
      final userId = jwtBody.claims.getTyped('user_id');
      assert(
        userId != null,
        'Invalid `userToken`, It should contain `user_id`',
      );
      _currentUser = user(userId);
    }
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
              '`userToken` must be provided while running on client-side',
            );
          }
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

  final String apiKey;
  final String? appId;
  final Token? userToken;
  final String? secret;
  final String fayeUrl;
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

  late final FayeClient _faye = FayeClient(fayeUrl)
    ..addExtension(_authExtension);

  late final _subscriptions = <String, _FeedSubscription>{};

  @override
  StreamUser? get currentUser => _currentUser;

  @override
  Future<StreamUser> setUser(Map<String, Object> data) async {
    assert(
      runner == Runner.client,
      'This method can only be used client-side using a user token',
    );
    final body = <String, Object>{...data}..remove('id');
    return _currentUser!.getOrCreate(body);
  }

  @override
  BatchOperationsClient get batch {
    assert(
      runner == Runner.server,
      "You can't use batch operations client side",
    );
    return BatchOperationsClient(_api.batch, secret: secret!);
  }

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
    assert(
      runner == Runner.server,
      "You can't use the `frontendToken` method client side",
    );
    return TokenHelper.buildFrontendToken(secret!, userId,
        expiresAt: expiresAt);
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
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.createUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.create(token, id, data, getOrCreate: getOrCreate);
  }

  @override
  Future<User> getUser(String id, {bool withFollowCounts = false}) {
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.getUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.read);
    return _api.users.get(token, id, withFollowCounts: withFollowCounts);
  }

  @override
  Future<User> updateUser(String id, Map<String, Object?> data) {
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.updateUser` only server-side');
    }
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _api.users.update(token, id, data);
  }

  @override
  Future<void> deleteUser(String id) {
    if (runner == Runner.client) {
      _logger.warning('We advice using `client.deleteUser` only server-side');
    }
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
