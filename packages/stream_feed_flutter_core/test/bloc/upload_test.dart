import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/subjects.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import '../mocks.dart';
import '../utils.dart';

main() {
  group('bloc', () {
    late MockClient mockClient;
    late MockFiles mockFiles;
    late File file;
    late AttachmentFile attachment;
    late String cdnUrl;
    setUp(() {
      mockClient = MockClient();
      mockFiles = MockFiles();
      file = assetFile('test_image.jpeg');

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
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};

      expectLater(bloc.getUploadStateStream(attachment),
          emitsInOrder(<UploadState>[UploadEmptyState(), UploadCancelled()]));

      await bloc.uploadFile(attachment);
      bloc.cancelUpload(attachment, mockCancelToken);

      verify(() => mockCancelToken.cancel('cancelled')).called(1);
    });

    test('success', () async {
      when(() => mockFiles.upload(attachment,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl);

      final bloc = UploadController(mockClient);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};

      expectLater(
          bloc.getUploadStateStream(attachment),
          emitsInOrder(
              <UploadState>[UploadEmptyState(), UploadSuccess(cdnUrl)]));
      await bloc.uploadFile(attachment);

      // print(bloc.stateMap[attachment].);
    });

    test('progress', () async {
      final bloc = UploadController(mockClient);
      void mockOnSendProgress(int sentBytes, int totalBytes) {
        bloc.stateMap[attachment]!
            .add(UploadProgress(sentBytes: sentBytes, totalBytes: totalBytes));
      }

      when(() =>
              mockFiles.upload(attachment, onSendProgress: mockOnSendProgress))
          .thenAnswer((_) async => cdnUrl);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};
      expectLater(
          bloc.getUploadStateStream(attachment),
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            UploadProgress(sentBytes: 0, totalBytes: 50)
          ]));
      await bloc.uploadFile(attachment);
      mockOnSendProgress(0, 50);
    });

    test('fail', () async {
      const exception = SocketException('exception');
      when(() => mockFiles.upload(attachment,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(exception);
      final bloc = UploadController(mockClient);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};
      expectLater(
          bloc.getUploadStateStream(attachment),
          emitsInOrder(
              <UploadState>[UploadEmptyState(), UploadFailed(exception)]));
      await bloc.uploadFile(attachment);
    });
  });
}
