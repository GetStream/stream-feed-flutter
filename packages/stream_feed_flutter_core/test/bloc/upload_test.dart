import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/upload_controller.dart';
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

      expectLater(bloc.stateStream,
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
          emitsInOrder(
              <UploadState>[UploadEmptyState(), UploadFailed(exception)]));
      await bloc.uploadFile(attachment);
    });
  });
}
