import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import '../mocks.dart';
import '../utils.dart';

void main() {
  group('bloc', () {
    late MockClient mockClient;
    late MockImages mockImages;
    late MockFiles mockFiles;
    late File file;
    late File audioFile;
    late File audioFile2;
    late AttachmentFile attachment;
    late AttachmentFile audioAttachment;
    late AttachmentFile audioAttachment2;
    late File file2;
    late AttachmentFile attachment2;
    late MockCancelToken mockCancelToken;
    late String cdnUrl;
    late String cdnUrl2;
    late String audioCdnUrl;
    late String audioCdnUrl2;
    setUp(() {
      mockClient = MockClient();
      mockImages = MockImages();
      mockFiles = MockFiles();
      mockCancelToken = MockCancelToken();
      file = assetFile('test_image.jpeg');
      file2 = assetFile('test_image2.png');
      audioFile = assetFile('cavalier.mp3');
      audioFile2 = assetFile('penserais.mp3');

      audioAttachment = AttachmentFile(
        path: audioFile.path,
        bytes: audioFile.readAsBytesSync(),
      );

      audioAttachment2 = AttachmentFile(
        path: audioFile2.path,
        bytes: audioFile2.readAsBytesSync(),
      );

      attachment = AttachmentFile(
        path: file.path,
        bytes: file.readAsBytesSync(),
      );

      attachment2 = AttachmentFile(
        path: file2.path,
        bytes: file2.readAsBytesSync(),
      );
      audioCdnUrl = 'https://us-east.stream-io-cdn.com/something.mp3';
      audioCdnUrl2 = 'https://us-east.stream-io-cdn.com/something.mp3';
      cdnUrl = 'https://us-east.stream-io-cdn.com/something.png';
      cdnUrl2 = 'https://us-east.stream-io-cdn.com/something.jpeg';
      when(() => mockClient.images).thenReturn(mockImages);
      when(() => mockClient.files).thenReturn(mockFiles);
    });
    group('files', () {
      test('cancel', () async {
        when(() => mockFiles.upload(audioAttachment,
            cancelToken: mockCancelToken,
            onSendProgress: any(named: 'onSendProgress'))).thenThrow(DioError(
          requestOptions: RequestOptions(path: ''),
          type: DioErrorType.cancel,
        ));
        final bloc = UploadController(mockClient)
          ..cancelMap = {audioAttachment: mockCancelToken};

        await bloc.uploadFile(
            audioAttachment, MediaType.audio, mockCancelToken);
        bloc.cancelUpload(audioAttachment);

        verify(() => mockCancelToken.cancel('cancelled')).called(1);

        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment: UploadCancelled(mediaType: MediaType.audio)
            }));
      });

      test('remove', () async {
        when(() => mockFiles.upload(audioAttachment,
                cancelToken: mockCancelToken,
                onSendProgress: any(named: 'onSendProgress')))
            .thenAnswer((_) async => audioCdnUrl);
        when(() => mockFiles.upload(audioAttachment2,
                cancelToken: mockCancelToken,
                onSendProgress: any(named: 'onSendProgress')))
            .thenAnswer((_) async => audioCdnUrl2);
        when(() => mockFiles.delete(audioCdnUrl))
            .thenAnswer((_) async => Future.value());

        final bloc = UploadController(mockClient);
        await bloc.uploadFile(
          audioAttachment,
          MediaType.audio,
          mockCancelToken,
        );

        await bloc.uploadFile(
          audioAttachment2,
          MediaType.audio,
          mockCancelToken,
        );
        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(audioCdnUrl)!)),
              audioAttachment2: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(audioCdnUrl2)!))
            }));

        bloc.removeUpload(audioAttachment);

        verify(() => mockFiles.delete(audioCdnUrl));
        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment2: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(audioCdnUrl2)!))
            }));
      });

      test('success', () async {
        when(() => mockFiles.upload(audioAttachment,
                cancelToken: mockCancelToken,
                onSendProgress: any(named: 'onSendProgress')))
            .thenAnswer((_) async => audioCdnUrl);

        final bloc = UploadController(mockClient);

        await bloc.uploadFile(
          audioAttachment,
          MediaType.audio,
          mockCancelToken,
        );

        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(audioCdnUrl)!))
            }));

        expect(
            bloc.getMediaUris(), [MediaUri(uri: Uri.tryParse(audioCdnUrl)!)]);
      });

      test('progress', () async {
        final bloc = UploadController(mockClient);
        void mockOnSendProgress(int sentBytes, int totalBytes) {
          bloc.stateMap.add({
            audioAttachment: UploadProgress(
                sentBytes: sentBytes,
                totalBytes: totalBytes,
                mediaType: MediaType.audio)
          });
        }

        when(() => mockFiles.upload(
              audioAttachment,
              onSendProgress: mockOnSendProgress,
              cancelToken: mockCancelToken,
            )).thenAnswer((_) async => audioCdnUrl);

        await bloc.uploadFile(
            audioAttachment, MediaType.audio, mockCancelToken);
        mockOnSendProgress(0, 50);
        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment: const UploadProgress(
                  totalBytes: 50, mediaType: MediaType.audio)
            }));
      });

      test('fail', () async {
        const exception = SocketException('exception');
        when(() => mockFiles.upload(audioAttachment,
            cancelToken: mockCancelToken,
            onSendProgress: any(named: 'onSendProgress'))).thenThrow(exception);
        final bloc = UploadController(mockClient);

        await bloc.uploadFile(
          audioAttachment,
          MediaType.audio,
          mockCancelToken,
        );
        await expectLater(
            bloc.uploadsStream,
            emits({
              audioAttachment:
                  const UploadFailed(exception, mediaType: MediaType.audio)
            }));
      });
    });
    group('images', () {
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

        await expectLater(bloc.uploadsStream,
            emits({attachment: UploadCancelled(mediaType: MediaType.image)}));
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
        when(() => mockImages.delete(cdnUrl))
            .thenAnswer((_) async => Future.value());

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
              attachment: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl)!)),
              attachment2: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl2)!))
            }));

        bloc.removeUpload(attachment);
        verify(() => mockImages.delete(cdnUrl));
        await expectLater(
            bloc.uploadsStream,
            emits({
              attachment2: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl2)!))
            }));
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
            bloc.uploadsStream,
            emits({
              attachment: UploadSuccess.media(
                  mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl)!))
            }));

        expect(bloc.getMediaUris(), [MediaUri(uri: Uri.tryParse(cdnUrl)!)]);
      });

      test('progress', () async {
        final bloc = UploadController(mockClient);
        void mockOnSendProgress(int sentBytes, int totalBytes) {
          bloc.stateMap.add({
            attachment: UploadProgress(
                sentBytes: sentBytes,
                totalBytes: totalBytes,
                mediaType: MediaType.image)
          });
        }

        when(() => mockImages.upload(
              attachment,
              onSendProgress: mockOnSendProgress,
              cancelToken: mockCancelToken,
            )).thenAnswer((_) async => cdnUrl);

        await bloc.uploadImage(attachment, mockCancelToken);
        mockOnSendProgress(0, 50);
        await expectLater(
            bloc.uploadsStream,
            emits({
              attachment: const UploadProgress(
                  totalBytes: 50, mediaType: MediaType.image)
            }));
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
            bloc.uploadsStream,
            emits({
              attachment:
                  const UploadFailed(exception, mediaType: MediaType.image)
            }));
      });
    });
  });
}
