import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';

class CloudFileStorageClient {
  const CloudFileStorageClient(this.token, this.files);
  final Token token;
  final FilesApi files;

  
  Future<String?> upload(MultipartFile file) => files.upload(token, file);

  
  Future<void> delete(String url) => files.delete(token, url);
}
