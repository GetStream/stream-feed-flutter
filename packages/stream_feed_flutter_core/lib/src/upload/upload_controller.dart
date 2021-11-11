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

  Stream<UploadState> getUploadStateStream(AttachmentFile attachmentFile) =>
      stateMap[attachmentFile]!.stream;

  // Future<List<FileUploadState>> getUploads() async =>
  //     combineStateMap().last;

  //TODO: get urls

  Stream<List<FileUploadState>> get uploadsStream => combineStateMap();

  Stream<List<FileUploadState>> combineStateMap() {
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

  void cancelUpload(AttachmentFile attachmentFile, [CancelToken? cancelToken]) {
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
    final token = cancelMap[attachmentFile];
    token!.cancel('cancelled');
  }

  Future<void> uploadFiles(List<AttachmentFile> attachmentFiles) async {
    await Future.wait(attachmentFiles.map(uploadFile));
  }

  Future<void> uploadFile(
    AttachmentFile attachmentFile,
  ) async {
    initController(attachmentFile);
    final _stateController = getController(attachmentFile);
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

  BehaviorSubject<UploadState> getController(AttachmentFile attachmentFile) =>
      stateMap[attachmentFile]!;

  void initController(AttachmentFile attachmentFile) {
    stateMap[attachmentFile]!.value = UploadEmptyState();
  }
}
