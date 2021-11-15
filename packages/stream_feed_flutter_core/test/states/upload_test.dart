import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';

import '../mocks.dart';
import '../utils.dart';

main() {
  testWidgets('FileUploadStateWidget', (tester) async {
    final mockController = MockUploadController();
    final file = assetFile('test_image.jpeg');

    final attachment = AttachmentFile(
      path: file.path,
      bytes: file.readAsBytesSync(),
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: FileUploadStateWidget(
        fileState: FileUploadState(
          state: UploadProgress(sentBytes: 0, totalBytes: 50),
          file: attachment,
        ),
        onCancelUpload: (AttachmentFile attachment) {
          mockController.cancelUpload(attachment);
        },
        onRemoveUpload: (AttachmentFile attachment) {
          print("hey");
        },
        onRetryUpload: (AttachmentFile attachment) {
          print("hey");
        },
      ),
    )));
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
}
