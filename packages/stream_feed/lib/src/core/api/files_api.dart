import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/http/typedefs.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Files
class FilesAPI {
  /// Builds a [FilesAPI].
  const FilesAPI(this._client);

  final StreamHttpClient _client;

  /// Upload a File instance or a readable stream of data
  Future<String?> upload(Token token, AttachmentFile file,
      {OnSendProgress? onSendProgress, CancelToken? cancelToken}) async {
    final multiPartFile = await file.toMultipartFile();
    final result = await _client.postFile<Map>(
      Routes.filesUrl,
      multiPartFile,
      headers: {'Authorization': '$token'},
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
    return result.data!['file'];
  }

  /// Delete a file using the url returned by the APIs
  Future<Response> delete(Token token, String targetUrl) => _client.delete(
        Routes.filesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      );

  /// {@macro filesRefreshUrl}
  Future<String?> refreshUrl(Token token, String targetUrl) async {
    final result = await _client.post(Routes.filesUrl,
        headers: {'Authorization': '$token'}, data: {'url': targetUrl});
    return result.data['url'];
  }
}
