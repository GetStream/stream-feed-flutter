import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/cloud/cloud_collections_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_collections_client_impl.dart';
import 'package:stream_feed_dart/src/cloud/cloud_file_storage_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_file_storage_client_impl.dart';
import 'package:stream_feed_dart/src/cloud/cloud_image_storage_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_image_storage_client_impl.dart';
import 'package:stream_feed_dart/src/cloud/cloud_reactions_client.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/index.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

import 'package:stream_feed_dart/src/cloud/cloud_reactions_client_impl.dart';
import 'package:stream_feed_dart/src/cloud/cloud_users_client.dart';
import 'package:stream_feed_dart/src/cloud/cloud_users_client_impl.dart';
import 'package:stream_feed_dart/src/cloud/feed/index.dart';
import 'package:stream_feed_dart/src/cloud/stream_cloud_client.dart';

class StreamCloudClientImpl implements StreamCloudClient {
  StreamCloudClientImpl(
    String apiKey,
    this._token, {
    StreamClientOptions options,
    StreamApi api,
  }) : _api = api ?? StreamApiImpl(apiKey, options: options);

  final String _token;
  final StreamApi _api;

  Token get token => Token(_token);

  @override
  CloudCollectionsClient get collections =>
      CloudCollectionsClientImpl(token, _api.collections);

  @override
  CloudReactionsClient get reactions =>
      CloudReactionsClientImpl(token, _api.reactions);

  @override
  CloudUsersClient get users => CloudUsersClientImpl(token, _api.users);

  @override
  CloudFileStorageClient get files =>
      CloudFileStorageClientImpl(token, _api.files);

  @override
  CloudImageStorageClient get images =>
      CloudImageStorageClientImpl(token, _api.images);

  @override
  CloudAggregatedFeed aggregatedFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return CloudAggregatedFeed(token, id, _api.feed);
  }

  @override
  CloudFlatFeed flatFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return CloudFlatFeed(token, id, _api.feed);
  }

  @override
  CloudNotificationFeed notificationFeed(String slug, String userId) {
    final id = FeedId(slug, userId);
    return CloudNotificationFeed(token, id, _api.feed);
  }

  @override
  Future<OpenGraphData> openGraph(String targetUrl) =>
      _api.openGraph(token, targetUrl);
}
