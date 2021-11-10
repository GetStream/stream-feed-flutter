// abstract class _Event with EquatableMixin {
//   @override
//   List<Object> get props => [];
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';

abstract class _State with EquatableMixin {
  @override
  List<Object> get props => [];
}

// class UploadEvent extends _Event {}

class UploadState extends _State {}

// class UploadFile extends UploadEvent {
//   UploadFile({required this.file, required this.url});

//   final AttachmentFile file;
//   final String url;
//   @override
//   List<Object> get props => [file, url];
// }

// class CancelUpload extends UploadEvent {}

// class RemoveFile extends Event {
//   RemoveFile({required this.file});

//   final AttachmentFile file;

//   // @override
//   // List<Object> get props => [file];
// }

class UploadEmptyState extends UploadState {}

class UploadFailed extends UploadState {
  UploadFailed(this.error);
  final Object error;
  @override
  List<Object> get props => [error];
}

class UploadProgress extends UploadState {
  UploadProgress({this.bytesSent = 0, this.bytesTotal = 0});

  final int bytesSent;
  final int bytesTotal;

  @override
  List<Object> get props => [bytesSent, bytesTotal];
}

class UploadCancelled extends UploadState {}

class UploadSuccess extends UploadState {
  UploadSuccess(this.url);
  final String? url;
}

class UploadController {
  UploadController(this.client);
  late Map<AttachmentFile, CancelToken> cancelMap = {};
  final StreamFeedClient client;

  // final _eventController = BehaviorSubject<UploadEvent>();

  @visibleForTesting
  final stateController =
      BehaviorSubject<UploadState>.seeded(UploadEmptyState());

  // Stream<UploadEvent> get eventsStream => _eventController.stream;
  Stream<UploadState> get stateStream => stateController.stream;
  Stream<UploadProgress>? get progressStream =>
      stateController.whereType<UploadProgress>();

  void close() {
    // _eventController.close();
    stateController.close();
  }

  void cancelUpload(AttachmentFile attachmentFile, [CancelToken? cancelToken]) {
    cancelMap[attachmentFile] = cancelToken ?? CancelToken();
    final token = cancelMap[attachmentFile];
    token!.cancel('cancelled');
  }

  Future<void> uploadFile(
    AttachmentFile attachmentFile,
  ) async {
    try {
      final url = await client.files
          .upload(attachmentFile, cancelToken: cancelMap[attachmentFile],
              onSendProgress: (sentBytes, totalBytes) {
        stateController
            .add(UploadProgress(bytesSent: sentBytes, bytesTotal: totalBytes));
      });

      stateController.add(UploadSuccess(url));
    } catch (e) {
      if (e is SocketException) stateController.add(UploadFailed(e));
      if (e is DioError && CancelToken.isCancel(e)) {
        stateController.add(UploadCancelled());
      }
    }
  }
}
