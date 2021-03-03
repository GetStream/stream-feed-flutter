import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/cloud/cloud_file_storage_client.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';

class CloudFileStorageClientImpl implements CloudFileStorageClient {
  const CloudFileStorageClientImpl(this.token, this.files);
  final Token token;
  final FilesApi files;

  @override
  Future<String> upload(MultipartFile file) => files.upload(token, file);

  @override
  Future<void> delete(String url) => files.delete(token, url);
}
