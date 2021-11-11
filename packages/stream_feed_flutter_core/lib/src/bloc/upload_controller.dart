import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

class UploadState extends Object with EquatableMixin {
  const UploadState();
  @override
  List<Object> get props => [];
}

class UploadEmptyState extends UploadState {
  const UploadEmptyState();
}

class UploadFailed extends UploadState {
  const UploadFailed(this.error);
  final Object error;
  @override
  List<Object> get props => [error];
}

class UploadProgress extends UploadState {
  const UploadProgress({this.sentBytes = 0, this.totalBytes = 0});

  final int sentBytes;
  final int totalBytes;

  @override
  List<Object> get props => [sentBytes, totalBytes];
}

class UploadCancelled extends UploadState {}

class UploadSuccess extends UploadState {
  const UploadSuccess(this.url);
  final String? url;
}

class UploadController {
  UploadController(this.client);
  late Map<AttachmentFile, CancelToken> cancelMap = {};
  final StreamFeedClient client;

  @visibleForTesting
  late Map<AttachmentFile, BehaviorSubject<UploadState>> stateMap = {};

  Stream<UploadState> getUploadStateStream(AttachmentFile attachmentFile) =>
      stateMap[attachmentFile]!.stream;

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

      _stateController.add(UploadSuccess(url));
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
