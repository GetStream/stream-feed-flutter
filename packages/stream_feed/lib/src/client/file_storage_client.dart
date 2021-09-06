import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/http/typedefs.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template files}
/// This API endpoint allows the uploading of files to, and deleting files
/// from, a Stream-provided CDN.
/// {@endtemplate}
class FileStorageClient {
  /// Initializes a FileStorageClient object
  ///
  /// {@macro files}
  const FileStorageClient(
    this._files, {
    this.userToken,
    this.secret,
  }) : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  /// Your API secret
  final String? secret;

  /// Your user token obtain via the dashboard.
  /// Required if you are using the sdk client side
  final Token? userToken;
  final FilesAPI _files;

  /// - Upload a File instance or a readable stream of data
  /// Usage:
  /// ```dart
  /// await files.upload(AttachmentFile(path: 'yourfilepath'));
  /// ```
  /// - To cancel the upload, call `token.cancel('cancelled)`. For example
  /// ```dart
  ///  var token = CancelToken();
  ///   // In one minute, we cancel!
  ///   Timer(Duration(milliseconds: 500), () {
  ///     token.cancel('cancelled');
  ///   });
  ///   await files.upload(AttachmentFile(path: 'yourfilepath'), token);
  /// ```
  /// - To get upload progress:
  /// ```dart
  ///  await files.upload(AttachmentFile(path: 'yourfilepath'), onSendProgress:(sentBytes,totalBytes){
  ///    if (totalBytes != -1) {
  ///       print((sentBytes / total * 100).toStringAsFixed(0) + '%');
  ///     }
  ///  });
  /// ```
  ///
  /// API docs: [upload](https://getstream.io/activity-feeds/docs/flutter-dart/files_introduction/?language=dart#upload)
  Future<String?> upload(
    AttachmentFile file, {
    OnSendProgress? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.write);
    return _files.upload(
      token,
      file,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Delete a file using the url returned by the APIs
  /// Usage:
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

  /// {@template filesRefreshUrl}
  /// Explicitly refresh CDN urls for uploaded images on the Stream CDN
  /// (only needed for files on the Stream CDN).
  ///
  /// Note that Stream CDN is not enabled by default, if in doubt please
  /// contact us.
  /// {@endtemplate}
  Future<String?> refreshUrl(String targetUrl) {
    final token =
        userToken ?? TokenHelper.buildFilesToken(secret!, TokenAction.read);
    return _files.refreshUrl(token, targetUrl);
  }
}
