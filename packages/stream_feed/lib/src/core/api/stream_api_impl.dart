import 'package:logging/logging.dart';
import 'package:stream_feed/src/core/api/batch_api.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/open_graph_data.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

class StreamApiImpl implements StreamAPI {
  /// [StreamApiImpl] constructor
  StreamApiImpl(
    String apiKey, {
    Logger? logger,
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
  }) : _client = client ??
            StreamHttpClient(
              apiKey,
              logger: logger,
              options: options,
            );

  final StreamHttpClient _client;

  BatchAPI? _batchAPI;

  @override
  BatchAPI get batch => _batchAPI ??= BatchAPI(_client);

  ReactionsAPI? _reactionsAPI;

  @override
  ReactionsAPI get reactions => _reactionsAPI ??= ReactionsAPI(_client);

  UsersAPI? _usersAPI;

  @override
  UsersAPI get users => _usersAPI ??= UsersAPI(_client);

  CollectionsAPI? _collectionsAPI;

  @override
  CollectionsAPI get collections => _collectionsAPI ??= CollectionsAPI(_client);

  FeedAPI? _feedAPI;

  @override
  FeedAPI get feed => _feedAPI ??= FeedAPI(_client);

  FilesAPI? _filesAPI;

  @override
  FilesAPI get files => _filesAPI ??= FilesAPI(_client);

  ImagesAPI? _imagesAPI;

  @override
  ImagesAPI get images => _imagesAPI ??= ImagesAPI(_client);

  PersonalizationAPI? _personalizationAPI;

  @override
  PersonalizationAPI get personalization =>
      _personalizationAPI ??= PersonalizationAPI(_client);

  @override
  Future<OpenGraphData> openGraph(Token token, String targetUrl) async {
    checkArgument(targetUrl.isNotEmpty, "TargetUrl can't be empty");
    final result = await _client.get(
      Routes.openGraphUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
    return OpenGraphData.fromJson(result.data);
  }
}
