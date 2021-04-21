import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// This API endpoint allows you to upload files
/// and to process your images (eg. create image thumbnails).
class FileStorageClient {
  /// Initialize a FileStorageClient object
  FileStorageClient(this._files, {this.userToken, this.secret})
      : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  /// Your API secret
  final String? secret;

  /// Your user token obtain via the dashboard.
  /// Required if you are using the sdk client side
  final Token? userToken;
  final FilesAPI _files;

  /// Upload a File instance or a readable stream of data
  /// Usage:
  /// ```dart
  ///   final file = File('yourfilepath');
  /// var multipartFile = await MultipartFile.fromFile(
  ///   file.path,
  ///   filename: 'my-file'
  /// );
  /// await files.upload(multipartFile);
  /// ```
  /// API docs: [upload](https://getstream.io/activity-feeds/docs/flutter-dart/files_introduction/?language=dart#upload)
  Future<String?> upload(MultipartFile file) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.write);
    return _files.upload(token, file);
  }

  /// Delete a file using the url returned by the APIs
  /// /// Usage:
  /// ```dart
  ///   await files.delete('fileUrl');
  /// ```
  ///
  /// Parameters:
  /// - [url] : the url of the file you want to delete
  /// API docs: [delete](https://getstream.io/activity-feeds/docs/flutter-dart/files_introduction/?language=dart#delete)
  Future<void> delete(String url) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.delete);
    return _files.delete(token, url);
  }
}
