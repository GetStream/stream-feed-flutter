import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';

abstract class FilesApi {
  Future<String?> upload(Token token, MultipartFile file);

  Future<Response> delete(Token token, String targetUrl);
}
