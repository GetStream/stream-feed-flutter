import 'package:stream_feed_dart/src/client/stream_client_options.dart';
import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/batch_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/reaction_api.dart';
import 'package:stream_feed_dart/src/core/api/reaction_api_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class StreamApiImpl implements StreamApi {
  final HttpClient _client;

  StreamApiImpl(
    String apiKey, {
    StreamClientOptions options,
    HttpClient client,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  @override
  BatchApi get batch => BatchApiImpl(_client);

  @override
  ReactionsApi get reaction => ReactionsApiImpl(_client);

  @override
  UsersApi get users => UsersApiImpl(_client);

  @override
  CollectionsApi get collections => CollectionsApiImpl(_client);

  @override
  FeedApi get feed => FeedApiImpl(_client);

  @override
  Future<OpenGraphData> openGraph(Token token, String targetUrl) async {
    final result = await _client.get(
      Routes.openGraphURL,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
    print(result);
  }
}
