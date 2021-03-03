import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';

abstract class ImagesApi {
  Future<String> upload(Token token, MultipartFile image);

  Future<Response> delete(Token token, String targetUrl);

  Future<String> get(
    Token token,
    String targetUrl, {
    Map<String, Object> options,
  });
}
