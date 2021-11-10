import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import '../mocks.dart';
import '../utils.dart';

abstract class _Event with EquatableMixin {
  @override
  List<Object> get props => [];
}

abstract class _State with EquatableMixin {
  @override
  List<Object> get props => [];
}

class UploadEvent extends _Event {}

class UploadState extends _State {}

class UploadFile extends UploadEvent {
  UploadFile({required this.file, required this.url});

  final AttachmentFile file;
  final String url;
  @override
  List<Object> get props => [file, url];
}

class CancelUpload extends UploadEvent {}

// class RemoveFile extends Event {
//   RemoveFile({required this.file});

//   final AttachmentFile file;

//   // @override
//   // List<Object> get props => [file];
// }

class UploadEmptyState extends UploadState {}

class UploadFailed extends UploadState {
  final Object error;
  UploadFailed(this.error);
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
  final String? url;
  UploadSuccess(this.url);
}

class UploadController {
  UploadController(this.client);
  late Map<AttachmentFile, CancelToken> cancelMap = {};
  final StreamFeedClient client;

  final _eventController = BehaviorSubject<UploadEvent>();

  @visibleForTesting
  final stateController =
      BehaviorSubject<UploadState>.seeded(UploadEmptyState());

  Stream<UploadEvent> get eventsStream => _eventController.stream;
  Stream<UploadState> get stateStream => stateController.stream;
  Stream<UploadProgress>? get progressStream =>
      stateController.whereType<UploadProgress>();

  void close() {
    _eventController.close();
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
      if (e is DioError && CancelToken.isCancel(e))
        stateController.add(UploadCancelled());
    }
  }
}

main() {
  group('bloc', () {
    late OnSendProgress onSendProgress;
    late MockClient mockClient;
    late MockFiles mockFiles;
    late File file;
    late AttachmentFile attachment;
    late String cdnUrl;
    setUp(() {
      mockClient = MockClient();
      mockFiles = MockFiles();
      file = assetFile('test_image.jpeg');
      onSendProgress = MockOnSendProgress();

      attachment = AttachmentFile(
        path: file.path,
        bytes: file.readAsBytesSync(),
      );
      cdnUrl = 'url';
      when(() => mockClient.files).thenReturn(mockFiles);
    });

    test('cancel', () async {
      final mockCancelToken = MockCancelToken();

      when(() => mockFiles.upload(attachment,
          cancelToken: mockCancelToken,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
        type: DioErrorType.cancel,
      ));
      final bloc = UploadController(mockClient);
      bloc.cancelMap = {attachment: mockCancelToken};

      expectLater(
          bloc.stateStream,
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            // UploadProgress(bytesTotal: 100),
            UploadCancelled()
          ]));

      await bloc.uploadFile(attachment);
      bloc.cancelUpload(attachment, mockCancelToken);

      verify(() => mockCancelToken.cancel('cancelled')).called(1);
    });

    test('success', () async {
      when(() => mockFiles.upload(attachment,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl);
      final bloc = UploadController(mockClient);

      expect(
          bloc.stateStream,
          emitsInOrder(
              <UploadState>[UploadEmptyState(), UploadSuccess(cdnUrl)]));

      await bloc.uploadFile(attachment);
    });

    test('progress', () async {
      final bloc = UploadController(mockClient);
      void mockOnSendProgress(int sentBytes, int totalBytes) {
        bloc.stateController
            .add(UploadProgress(bytesSent: sentBytes, bytesTotal: totalBytes));
      }

      when(() =>
              mockFiles.upload(attachment, onSendProgress: mockOnSendProgress))
          .thenAnswer((_) async => cdnUrl);
      expectLater(
          bloc.stateStream,
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            UploadProgress(bytesSent: 0, bytesTotal: 50)
          ]));
      await bloc.uploadFile(attachment);
      mockOnSendProgress(0, 50);
    });

    test('fail', () async {
      const exception = SocketException('exception');
      when(() => mockFiles.upload(attachment,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(exception);
      final bloc = UploadController(mockClient);
      expectLater(
          bloc.stateStream,
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            // UploadProgress(bytesTotal: 100),
            UploadFailed(exception)
          ]));
      await bloc.uploadFile(attachment);
    });
  });
}
