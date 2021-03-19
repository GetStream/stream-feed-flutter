import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class ImagesApi {
  const ImagesApi(this.client);

  final HttpClient client;

  @override
  Future<String?> upload(Token token, MultipartFile image) async {
    checkNotNull(image, 'No image to upload');
    final result = await client.postFile<Map>(
      Routes.imagesUrl,
      image,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  @override
  Future<Response> delete(Token token, String targetUrl) {
    checkNotNull(targetUrl, 'No image to delete');
    return client.delete(
      Routes.imagesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
  }

  @override
  Future<String?> get(
    Token token,
    String targetUrl, {
    Map<String, Object?>? options,
  }) async {
    checkNotNull(targetUrl, 'No image to process');
    final result = await client.get(
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
