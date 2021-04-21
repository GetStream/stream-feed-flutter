import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/open_graph_data.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

import 'package:stream_feed/src/core/api/batch_api.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';

class StreamApiImpl implements StreamAPI {
  /// [StreamApiImpl] constructor
  StreamApiImpl(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  final StreamHttpClient _client;

  @override
  BatchAPI get batch => BatchAPI(_client);

  @override
  ReactionsAPI get reactions => ReactionsAPI(_client);

  @override
  UsersAPI get users => UsersAPI(_client);

  @override
  CollectionsAPI get collections => CollectionsAPI(_client);

  @override
  FeedAPI get feed => FeedAPI(_client);

  @override
  FilesAPI get files => FilesAPI(_client);

  @override
  ImagesAPI get images => ImagesAPI(_client);

  @override
  PersonalizationAPI get personalization => PersonalizationAPI(_client);

  @override
  Future<OpenGraphData> openGraph(Token token, String targetUrl) async {
    checkArgument(targetUrl.isNotEmpty, "TargetUrl can't be empty");
    final result = await _client.get(
      Routes.openGraphUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
    //TODO: I have no idea if this works just pleasing null safe warnings
    return OpenGraphData.fromJson(result.data as Map<String, dynamic>);
  }
}
