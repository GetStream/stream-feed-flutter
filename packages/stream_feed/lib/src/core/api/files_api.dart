import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

//TODO: stream_feed_dart/src/core/core.dart
class FilesApi {
  const FilesApi(this.client);

  final StreamHttpClient client;

  /// Upload a File instance or a readable stream of data
  Future<String?> upload(Token token, MultipartFile file) async {
    final result = await client.postFile<Map>(
      Routes.filesUrl,
      file,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  /// Delete a file using the url returned by the APIs
  Future<Response> delete(Token token, String targetUrl) => client.delete(
        Routes.filesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      );
}
