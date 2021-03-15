import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/batch_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/files_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';

class StreamApiImpl implements StreamApi {
  StreamApiImpl(
    String apiKey, {
    StreamClientOptions? options,
    HttpClient? client,
  }) : _client = client ??
            StreamHttpClient(apiKey, options: options ?? StreamClientOptions());

  final HttpClient _client;

  @override
  BatchApi get batch => BatchApiImpl(_client);

  @override
  ReactionsApi get reactions => ReactionsApiImpl(_client);

  @override
  UsersApi get users => UsersApiImpl(_client);

  @override
  CollectionsApi get collections => CollectionsApiImpl(_client);

  @override
  FeedApi get feed => FeedApiImpl(_client);

  @override
  FilesApi get files => FilesApiImpl(_client);

  @override
  ImagesApi get images => ImagesApiImpl(_client);

  @override
  Future<OpenGraphData> openGraph(Token token, String targetUrl) async {
    checkNotNull(targetUrl, "TargetUrl can't be null");
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
