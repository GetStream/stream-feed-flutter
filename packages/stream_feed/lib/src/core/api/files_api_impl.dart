import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

import 'files_api.dart';

class FilesApiImpl implements FilesApi {
  final HttpClient client;

  const FilesApiImpl(this.client);

  @override
  Future<String> upload(Token token, MultipartFile file) async {
    checkNotNull(file, 'No data to upload');
    final result = await client.postFile<Map>(
      Routes.filesUrl,
      file,
      headers: {'Authorization': '$token'},
    );
    return result.data['file'];
  }

  @override
  Future<Response> delete(Token token, String targetUrl) {
    checkNotNull(targetUrl, 'No file to delete');
    return client.delete(
      Routes.filesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
  }
}
