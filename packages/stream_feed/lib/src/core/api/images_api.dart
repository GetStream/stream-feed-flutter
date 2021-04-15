import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

/// The http layer api for CRUD operations on Images
class ImagesApi {
  /// [ImagesApi] constructor
  const ImagesApi(this._client);

  final StreamHttpClient _client;

  /// Uploading an image
  Future<String?> upload(Token token, MultipartFile image) async {
    final result = await _client.postFile<Map>(
      Routes.imagesUrl,
      image,
      headers: {'Authorization': '$token'},
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
}
