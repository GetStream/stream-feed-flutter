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

class StreamApiImpl implements StreamApi {
  /// [StreamApiImpl] constructor
  StreamApiImpl(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  final StreamHttpClient _client;

  @override
  BatchApi get batch => BatchApi(_client);

  @override
  ReactionsApi get reactions => ReactionsApi(_client);

  @override
  UsersApi get users => UsersApi(_client);

  @override
  CollectionsApi get collections => CollectionsApi(_client);

  @override
  FeedApi get feed => FeedApi(_client);

  @override
  FilesApi get files => FilesApi(_client);

  @override
  ImagesApi get images => ImagesApi(_client);

  @override
  PersonalizationApi get personalization => PersonalizationApi(_client);

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
