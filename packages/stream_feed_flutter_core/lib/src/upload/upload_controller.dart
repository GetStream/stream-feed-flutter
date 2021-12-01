import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';

class UploadController {
  UploadController(this.client);
  late Map<AttachmentFile, CancelToken> cancelMap = {};
  final StreamFeedClient client;

  @visibleForTesting
  late BehaviorSubject<Map<AttachmentFile, UploadState>> stateMap =
      BehaviorSubject.seeded({});

  Stream<Map<AttachmentFile, UploadState>> get uploadsStream => stateMap.stream;

  // Stream<List<FileUploadState>> _combineStateMap() {
  //   return CombineLatestStream(
  //       stateMap.entries
  //           .map((entry) => entry.value.map((v) => MapEntry(entry.key, v))),
  //       (List<MapEntry<AttachmentFile, UploadState>> values) =>
  //           List<FileUploadState>.from(
  //               values.map((entry) => FileUploadState.fromEntry(entry))));
  // }

  void close() {
    stateMap.close();
  }

  void cancelUpload(AttachmentFile attachmentFile) {
    final token = cancelMap[attachmentFile];
    token!.cancel('cancelled');
  }

  Future<void> uploadFiles(List<AttachmentFile> attachmentFiles) async {
    await Future.wait(attachmentFiles.map(uploadFile));
  }

  Future<void> uploadFile(AttachmentFile attachmentFile,
      [CancelToken? cancelToken]) async {
    _initController(attachmentFile, cancelToken);
    var _stateController = _getController(attachmentFile);
    try {
      final url = await client.files
          .upload(attachmentFile, cancelToken: cancelMap[attachmentFile],
              onSendProgress: (sentBytes, totalBytes) {
        _stateController =
            UploadProgress(sentBytes: sentBytes, totalBytes: totalBytes);
      });

      _stateController = UploadSuccess(url!); //TODO: deal url null
    } catch (e) {
      if (e is SocketException) _stateController = UploadFailed(e);
      if (e is DioError && CancelToken.isCancel(e)) {
        _stateController = UploadCancelled();
      }
    }
  }

  UploadState _getController(
    AttachmentFile attachmentFile,
  ) =>
      stateMap.value[attachmentFile]!;

  void _initController(AttachmentFile attachmentFile,
      [CancelToken? cancelToken]) {
    stateMap.value = {attachmentFile: UploadEmptyState()};
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
  }

  /// Remove upload from controller
  void removeUpload(AttachmentFile file) {
    // final _stateController = _getController(file);
    stateMap.value.removeWhere((key, value) => key == file);
    // _stateController.add(UploadRemoved());
  }

  /// Get urls
  List<String> getUrls() {
    final successes = stateMap.value.values
        .map((state) => state)
        .toList()
        .whereType<UploadSuccess>();
    final urls = successes.map((success) => success.url).toList();
    return urls;
  }
}
