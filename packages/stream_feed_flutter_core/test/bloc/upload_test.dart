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
    late File file2;
    late AttachmentFile attachment2;
    late MockCancelToken mockCancelToken;
    late String cdnUrl;
    late String cdnUrl2;
    setUp(() {
      mockClient = MockClient();
      mockFiles = MockFiles();
      mockCancelToken = MockCancelToken();
      file = assetFile('test_image.jpeg');
      file2 = assetFile('test_image2.jpeg');

      attachment = AttachmentFile(
        path: file.path,
        bytes: file.readAsBytesSync(),
      );

      attachment2 = AttachmentFile(
        path: file2.path,
        bytes: file2.readAsBytesSync(),
      );
      cdnUrl = 'url';
      cdnUrl2 = 'url2';
      when(() => mockClient.files).thenReturn(mockFiles);
    });

    test('cancel', () async {
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

      await bloc.uploadFile(attachment, mockCancelToken);
      bloc.cancelUpload(attachment);

      verify(() => mockCancelToken.cancel('cancelled')).called(1);
    });

    test('success', () async {
      when(() => mockFiles.upload(attachment,
              cancelToken: mockCancelToken,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl);

      final bloc = UploadController(mockClient);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};

      expectLater(
          bloc.uploadsStream,
          emitsInOrder([
            [FileUploadState(file: attachment, state: UploadEmptyState())],
            [FileUploadState(file: attachment, state: UploadSuccess(cdnUrl))]
          ]));
      await bloc.uploadFile(
        attachment,
        mockCancelToken,
      );
      // expectLater(
      //     bloc.uploadsStream,
      //     emitsInOrder(<FileUploadState>[
      //       FileUploadState(file: attachment2, state: state2)
      //     ]));

      // print(bloc.stateMap[attachment].);
    });

    test('progress', () async {
      final bloc = UploadController(mockClient);
      void mockOnSendProgress(int sentBytes, int totalBytes) {
        bloc.stateMap[attachment]!
            .add(UploadProgress(sentBytes: sentBytes, totalBytes: totalBytes));
      }

      when(() => mockFiles.upload(
            attachment,
            onSendProgress: mockOnSendProgress,
            cancelToken: mockCancelToken,
          )).thenAnswer((_) async => cdnUrl);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};
      expectLater(
          bloc.getUploadStateStream(attachment),
          emitsInOrder(<UploadState>[
            UploadEmptyState(),
            UploadProgress(sentBytes: 0, totalBytes: 50)
          ]));
      await bloc.uploadFile(attachment, mockCancelToken);
      mockOnSendProgress(0, 50);
    });

    test('fail', () async {
      const exception = SocketException('exception');
      when(() => mockFiles.upload(attachment,
          cancelToken: mockCancelToken,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(exception);
      final bloc = UploadController(mockClient);
      bloc.stateMap = {attachment: BehaviorSubject<UploadState>()};
      expectLater(
          bloc.getUploadStateStream(attachment),
          emitsInOrder(
              <UploadState>[UploadEmptyState(), UploadFailed(exception)]));
      await bloc.uploadFile(
        attachment,
        mockCancelToken,
      );
    });
  });
}
