import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class ImagesApi {
  const ImagesApi(this.client);

  final HttpClient client;

  Future<String?> upload(Token token, MultipartFile image) async {
    final result = await client.postFile<Map>(
      Routes.imagesUrl,
      image,
      headers: {'Authorization': '$token'},
    );
    return result.data!['file'];
  }

  Future<Response> delete(Token token, String targetUrl) {
    return client.delete(
      Routes.imagesUrl,
      headers: {'Authorization': '$token'},
      queryParameters: {'url': targetUrl},
    );
  }

  Future<String?> get(
    Token token,
    String targetUrl, {
    Map<String, Object?>? options,
  }) async {
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
