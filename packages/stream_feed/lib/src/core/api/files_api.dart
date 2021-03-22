import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

import 'package:stream_feed_dart/src/core/api/files_api.dart';

//TODO: stream_feed_dart/src/core/core.dart
class FilesApi {
  const FilesApi(this.client);

  final HttpClient client;

  Future<String?> upload(Token token, MultipartFile file) async {
    checkNotNull(file, 'No data to upload');
    final result = await client.postFile<Map>(
      Routes.filesUrl,
      file,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  Future<Response> delete(Token token, String targetUrl) {
    checkNotNull(targetUrl, 'No file to delete');
    return client.delete(
      Routes.filesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
  }
}
