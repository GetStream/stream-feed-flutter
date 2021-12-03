import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import '../mocks.dart';
import '../utils.dart';

main() {
  group('bloc', () {
    late MockClient mockClient;
    late MockImages mockImages;
    late File file;
    late AttachmentFile attachment;
    late File file2;
    late AttachmentFile attachment2;
    late MockCancelToken mockCancelToken;
    late String cdnUrl;
    late String cdnUrl2;
    setUp(() {
      mockClient = MockClient();
      mockImages = MockImages();
      mockCancelToken = MockCancelToken();
      file = assetFile('test_image.jpeg');
      file2 = assetFile('test_image2.png');

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
      when(() => mockClient.images).thenReturn(mockImages);
    });

    test('cancel', () async {
      when(() => mockImages.upload(attachment,
          cancelToken: mockCancelToken,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(DioError(
        requestOptions: RequestOptions(path: ''),
        type: DioErrorType.cancel,
      ));
      final bloc = UploadController(mockClient)
        ..cancelMap = {attachment: mockCancelToken};

      await bloc.uploadImage(attachment, mockCancelToken);
      bloc.cancelUpload(attachment);

      verify(() => mockCancelToken.cancel('cancelled')).called(1);

      await expectLater(
          bloc.uploadsStream, emits({attachment: UploadCancelled()}));
    });

    test('remove', () async {
      when(() => mockImages.upload(attachment,
              cancelToken: mockCancelToken,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl);
      when(() => mockImages.upload(attachment2,
              cancelToken: mockCancelToken,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl2);

      final bloc = UploadController(mockClient);
      await bloc.uploadImage(
        attachment,
        mockCancelToken,
      );

      await bloc.uploadImage(
        attachment2,
        mockCancelToken,
      );
      await expectLater(
          bloc.uploadsStream,
          emits({
            attachment: UploadSuccess(cdnUrl),
            attachment2: UploadSuccess(cdnUrl2)
          }));

      bloc.removeUpload(attachment);
      await expectLater(
          bloc.uploadsStream, emits({attachment2: UploadSuccess(cdnUrl2)}));
    });

    test('success', () async {
      when(() => mockImages.upload(attachment,
              cancelToken: mockCancelToken,
              onSendProgress: any(named: 'onSendProgress')))
          .thenAnswer((_) async => cdnUrl);

      final bloc = UploadController(mockClient);

      await bloc.uploadImage(
        attachment,
        mockCancelToken,
      );

      await expectLater(
          bloc.uploadsStream, emits({attachment: UploadSuccess(cdnUrl)}));

      expect(bloc.getUrls(), [cdnUrl]);
    });

    test('progress', () async {
      final bloc = UploadController(mockClient);
      void mockOnSendProgress(int sentBytes, int totalBytes) {
        bloc.stateMap.add({
          attachment:
              UploadProgress(sentBytes: sentBytes, totalBytes: totalBytes)
        });
      }

      when(() => mockImages.upload(
            attachment,
            onSendProgress: mockOnSendProgress,
            cancelToken: mockCancelToken,
          )).thenAnswer((_) async => cdnUrl);

      await bloc.uploadImage(attachment, mockCancelToken);
      mockOnSendProgress(0, 50);
      await expectLater(bloc.uploadsStream,
          emits({attachment: UploadProgress(totalBytes: 50)}));
    });

    test('fail', () async {
      const exception = SocketException('exception');
      when(() => mockImages.upload(attachment,
          cancelToken: mockCancelToken,
          onSendProgress: any(named: 'onSendProgress'))).thenThrow(exception);
      final bloc = UploadController(mockClient);

      await bloc.uploadImage(
        attachment,
        mockCancelToken,
      );
      await expectLater(
          bloc.uploadsStream, emits({attachment: UploadFailed(exception)}));
    });
  });
}
