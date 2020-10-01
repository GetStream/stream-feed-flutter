import 'package:stream_feed_dart/src/client/batch_operations_client.dart';
import 'package:stream_feed_dart/src/client/batch_operations_client_impl.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/client/collections_client_impl.dart';
import 'package:stream_feed_dart/src/client/feed/aggregated_feed.dart';
import 'package:stream_feed_dart/src/client/feed/flat_feed.dart';
import 'package:stream_feed_dart/src/client/feed/notification_feed.dart';
import 'package:stream_feed_dart/src/client/reactions_client.dart';
import 'package:stream_feed_dart/src/client/reactions_client_impl.dart';
import 'package:stream_feed_dart/src/client/stream_client.dart';
import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/client/users_client_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class StreamClientImpl implements StreamClient {
  final String _secret;
  final StreamApi _api;

  StreamClientImpl(
    this._secret,
    String apiKey, {
    String appId,
    StreamClientOptions options,
    StreamApi api,
  }) : _api = api ?? StreamApiImpl(apiKey, options: options);

  @override
  BatchOperationsClient get batch =>
      BatchOperationsClientImpl(_secret, _api.batch);

  @override
  ReactionsClient get reactions => ReactionsClientImpl(_secret, _api.reaction);

  @override
  UsersClient get users => UsersClientImpl(_secret, _api.users);

  @override
  CollectionsClient get collections =>
      CollectionsClientImpl(_secret, _api.collections);

  @override
  FlatFeet flatFeed(String slug, String userId) {
    // TODO: implement flatFeed
    throw UnimplementedError();
  }

  @override
  AggregatedFeed aggregatedFeed(String slug, String userId) {
    // TODO: implement aggregatedFeed
    throw UnimplementedError();
  }

  @override
  NotificationFeed notificationFeed(String slug, String userId) {
    // TODO: implement notificationFeed
    throw UnimplementedError();
  }

  @override
  Token frontendToken(
    String userId, {
    DateTime expiresAt,
  }) =>
      TokenHelper.buildFrontendToken(_secret, userId, expiresAt: expiresAt);
}
