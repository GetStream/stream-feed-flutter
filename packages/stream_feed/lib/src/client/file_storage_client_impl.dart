import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

import 'package:stream_feed_dart/src/client/file_storage_client.dart';

class FileStorageClientImpl implements FileStorageClient {
  const FileStorageClientImpl(this.secret, this.files);
  final String secret;
  final FilesApi files;

  @override
  Future<String> upload(MultipartFile file) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.write);
    return files.upload(token, file);
  }

  @override
  Future<void> delete(String url) {
    final token = TokenHelper.buildFilesToken(secret, TokenAction.delete);
    return files.delete(token, url);
  }
}
