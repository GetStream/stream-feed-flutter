import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/http/typedefs.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Images
class ImagesAPI {
  /// [ImagesAPI] constructor
  const ImagesAPI(this._client);

  final StreamHttpClient _client;

  /// Uploading an image
  Future<String?> upload(
    Token token,
    AttachmentFile image, {
    OnSendProgress? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final multiPartFile = await image.toMultipartFile();
    final result = await _client.postFile<Map>(
      Routes.imagesUrl,
      multiPartFile,
      headers: {'Authorization': '$token'},
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
    return result.data!['file'];
  }

  /// Images can be deleted using their URL.
  Future<Response> delete(Token token, String targetUrl) => _client.delete(
        Routes.imagesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      );

  /// Images can be obtained using their URL.
  Future<String?> get(
    Token token,
    String targetUrl, {
    Map<String, Object?>? options,
  }) async {
    final result = await _client.get(
      Routes.imagesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {
        'url': targetUrl,
        if (options != null) ...options,
      },
    );
    return result.data['file'];
  }

  Future<String?> refreshUrl(Token token, String targetUrl) async {
    final result = await _client.post(Routes.imagesUrl,
        headers: {'Authorization': '$token'}, data: {'url': targetUrl});
    return result.data['url'];
  }
}
