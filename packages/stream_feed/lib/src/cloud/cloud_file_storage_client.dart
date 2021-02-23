import 'package:dio/dio.dart';

abstract class CloudFileStorageClient {
  Future<String> upload(MultipartFile file);

  Future<void> delete(String url);
}
