import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';

import '../utils.dart';

main() {
  testWidgets('FileUploadStateWidget', (tester) async {
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
        onCancelUpload: (AttachmentFile file) {
          print("hey");
        },
        onRemoveUpload: (AttachmentFile file) {
          print("hey");
        },
        onRetryUpload: (AttachmentFile file) {
          print("hey");
        },
      ),
    )));
    final uploadProgressWidget = find.byType(UploadProgressWidget);
    expect(uploadProgressWidget, findsOneWidget);
  });
}
