import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Files
class FilesApi {
  /// [FilesApi] constructor
  const FilesApi(this._client);

  final StreamHttpClient _client;

  /// Upload a File instance or a readable stream of data
  Future<String?> upload(Token token, MultipartFile file) async {
    final result = await _client.postFile<Map>(
      Routes.filesUrl,
      file,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  /// Delete a file using the url returned by the APIs
  Future<Response> delete(Token token, String targetUrl) => _client.delete(
        Routes.filesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      );
}
