import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class FileStorageClient {
  const FileStorageClient(this.secret, this.files);
  final String secret;
  final FilesApi files;

  
  Future<String?> upload(MultipartFile file) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.write);
    return files.upload(token, file);
  }

  
  Future<void> delete(String url) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.delete);
    return files.delete(token, url);
  }
}
