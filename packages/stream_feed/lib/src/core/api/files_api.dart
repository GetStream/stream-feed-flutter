import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

//TODO: stream_feed_dart/src/core/core.dart
class FilesApi {
  const FilesApi(this._client);

  final StreamHttpClient _client;

  Future<String?> upload(Token token, MultipartFile file) async {
    final result = await _client.postFile<Map>(
      Routes.filesUrl,
      file,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  Future<Response> delete(Token token, String targetUrl) => _client.delete(
        Routes.filesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      );
}
