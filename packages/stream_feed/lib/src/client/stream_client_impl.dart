import 'package:faye_dart/faye_dart.dart';
import 'package:stream_feed_dart/src/client/aggregated_feed.dart';
import 'package:stream_feed_dart/src/client/flat_feed.dart';
import 'package:stream_feed_dart/src/client/notification_feed.dart';
import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/client/file_storage_client.dart';
import 'package:stream_feed_dart/src/client/image_storage_client.dart';
import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/client/stream_client.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class StreamClientImpl implements StreamClient {
  StreamClientImpl(this.apiKey,
      {this.userToken,
      StreamClientOptions? options,
      StreamApi? api,
      this.secret,
      this.appId,
      this.fayeUrl = 'wss://faye-us-east.stream-io-api.com/faye'})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        ),
        _api = api ??
            StreamApiImpl(apiKey, options: options ?? StreamClientOptions()) {
    faye = FayeClient(fayeUrl, authExtension: AuthExtension());
  }
  final String apiKey;
  final String? appId;
  final Token? userToken;
  final StreamApi _api;
  final String? secret;
  final String fayeUrl;
  late FayeClient faye;

  @override
  BatchOperationsClient get batch {
    checkNotNull(secret, "You can't use batch operations client side");
    return BatchOperationsClient(_api.batch, secret: secret!);
  }

  @override
  CollectionsClient get collections =>
      CollectionsClient(_api.collections, userToken: userToken, secret: secret);

  @override
  ReactionsClient get reactions =>
      ReactionsClient(_api.reactions, userToken: userToken, secret: secret);

  @override
  UsersClient get users =>
      UsersClient(_api.users, userToken: userToken, secret: secret);

  @override
  FileStorageClient get files =>
      FileStorageClient(_api.files, userToken: userToken, secret: secret);

  @override
  ImageStorageClient get images =>
      ImageStorageClient(_api.images, userToken: userToken, secret: secret);

  @override
  AggregatedFeed aggregatedFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return AggregatedFeed(id, _api.feed,
        userToken: userToken, secret: secret, appId: appId, faye: faye);
  }

  @override
  FlatFeed flatFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return FlatFeed(id, _api.feed,
        apiKey: apiKey,
        userToken: userToken,
        secret: secret,
        appId: appId,
        faye: faye);
  }

  @override
  NotificationFeed notificationFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return NotificationFeed(id, _api.feed,
        userToken: userToken, secret: secret, appId: appId, faye: faye);
  }

  @override
  Token frontendToken(
    String userId, {
    DateTime? expiresAt,
  }) {
    checkNotNull(secret, "You can't use the frontendToken method client side");
    return TokenHelper.buildFrontendToken(secret!, userId,
        expiresAt: expiresAt);
  }

  @override
  Future<OpenGraphData> openGraph(String targetUrl) {
    final token = userToken ?? TokenHelper.buildOpenGraphToken(secret!);
    return _api.openGraph(token, targetUrl);
  }
}
