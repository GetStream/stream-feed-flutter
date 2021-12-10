import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  late MockUploadController mockController;
  late File file;
  late AttachmentFile attachment;
  late String cdnUrl;
  setUp(() {
    cdnUrl = 'https://us-east.stream-io-cdn.com/something.jpeg';
    mockController = MockUploadController();
    file = assetFile('test_image.jpeg');

    attachment = AttachmentFile(
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
  });

  group('FileUploadStateWidget', () {
    testWidgets('UploadProgress', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileUploadStateWidget(
              fileState: FileUploadState(
                state: const UploadProgress(
                    totalBytes: 50, mediaType: MediaType.image),
                file: attachment,
              ),
              onCancelUpload: (file) {
                mockController.cancelUpload(file);
              },
              onRemoveUpload: (_) {},
              onRetryUpload: (_) {},
            ),
          ),
        ),
      );
      final uploadProgressWidget = find.byType(UploadProgressWidget);
      expect(uploadProgressWidget, findsOneWidget);

      final progress = find.byType(CircularProgressIndicator);
      expect(progress, findsOneWidget);

      // final closeButton = find.byIcon(Icons.close);
      // expect(closeButton, findsOneWidget);
      // await tester.tap(closeButton);
      // await tester.pumpAndSettle();
      // verify(() => mockController.cancelUpload(attachment)).called(1);
    });

    testWidgets('UploadSuccess', (tester) async {
      when(() => mockController.removeUpload(attachment))
          .thenAnswer((_) async => Future.value());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileUploadStateWidget(
              fileState: FileUploadState(
                state: UploadSuccess.media(
                    mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl)!)),
                file: attachment,
              ),
              onCancelUpload: (_) {},
              onRemoveUpload: (file) {
                mockController.removeUpload(file);
              },
              onRetryUpload: (_) {},
            ),
          ),
        ),
      );
      final uploadProgressWidget = find.byType(UploadSuccessWidget);
      expect(uploadProgressWidget, findsOneWidget);

      final closeButton = find.byIcon(Icons.close);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
      verify(() => mockController.removeUpload(attachment)).called(1);
    });

    testWidgets('UploadFailed', (tester) async {
      const exception = SocketException('exception');
      when(() => mockController.uploadImage(attachment))
          .thenAnswer((_) async => Future.value());
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileUploadStateWidget(
              fileState: FileUploadState(
                state:
                    const UploadFailed(exception, mediaType: MediaType.image),
                file: attachment,
              ),
              onCancelUpload: (_) {},
              onRemoveUpload: (_) {},
              onRetryUpload: (file) {
                mockController.uploadImage(file);
              },
            ),
          ),
        ),
      );
      final uploadProgressWidget = find.byType(UploadFailedWidget);
      expect(uploadProgressWidget, findsOneWidget);

      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle();
      verify(() => mockController.uploadImage(attachment)).called(1);
    });
  });
}
