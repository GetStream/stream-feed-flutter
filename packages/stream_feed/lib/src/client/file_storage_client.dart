import 'package:dio/dio.dart';

abstract class FileStorageClient {
  Future<String> upload(MultipartFile file);

  Future<void> delete(String url);
}
