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
  late Map<AttachmentFile, BehaviorSubject<UploadState>> stateMap = {};

  Stream<List<FileUploadState>> get uploadsStream => _combineStateMap();

  Stream<List<FileUploadState>> _combineStateMap() {
    return CombineLatestStream(
        stateMap.entries
            .map((entry) => entry.value.map((v) => MapEntry(entry.key, v))),
        (List<MapEntry<AttachmentFile, UploadState>> values) =>
            List<FileUploadState>.from(
                values.map((entry) => FileUploadState.fromEntry(entry))));
  }

  void close() {
    stateMap.forEach((key, value) {
      value.close();
    });
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
    final _stateController = _getController(attachmentFile);
    try {
      final url = await client.files
          .upload(attachmentFile, cancelToken: cancelMap[attachmentFile],
              onSendProgress: (sentBytes, totalBytes) {
        _stateController
            .add(UploadProgress(sentBytes: sentBytes, totalBytes: totalBytes));
      });

      _stateController.add(UploadSuccess(url!)); //TODO: deal url null
    } catch (e) {
      if (e is SocketException) _stateController.add(UploadFailed(e));
      if (e is DioError && CancelToken.isCancel(e)) {
        _stateController.add(UploadCancelled());
      }
    }
  }

  BehaviorSubject<UploadState> _getController(
    AttachmentFile attachmentFile,
  ) =>
      stateMap[attachmentFile]!;

  void _initController(AttachmentFile attachmentFile,
      [CancelToken? cancelToken]) {
    stateMap[attachmentFile] = BehaviorSubject<UploadState>();
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
  }

  /// Remove upload from controller
  void removeUpload(AttachmentFile file) {
    final _stateController = _getController(file);
    stateMap.removeWhere((key, value) => key == file);
    _stateController.add(UploadRemoved());
  }

  /// Get urls
  List<String> getUrls() {
    final successes = stateMap.values
        .map((state) => state.value)
        .toList()
        .whereType<UploadSuccess>();
    final urls = successes.map((success) => success.url).toList();
    return urls;
  }
}
