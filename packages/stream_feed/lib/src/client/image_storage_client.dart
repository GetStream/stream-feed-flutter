import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/index.dart';

abstract class ImageStorageClient {
  Future<String> upload(MultipartFile image);

  Future<void> delete(String url);

  Future<String> get(String url);

  Future<String> getCropped(String url, Crop crop);

  Future<String> getResized(String url, Resize resize);
}
