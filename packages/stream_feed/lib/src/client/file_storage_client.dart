import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class FileStorageClient {
  const FileStorageClient(this.files, {this.userToken, this.secret});
  final String? secret;
  final Token? userToken;
  final FilesApi files;

  Future<String?> upload(MultipartFile file) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.write);
    return files.upload(token, file);
  }

  Future<void> delete(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.delete);
    return files.delete(token, url);
  }
}
