import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart' show AttachmentFile;
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload_core.dart';

import 'mocks.dart';
import 'utils.dart';

void main() {
  late MockUploadController mockkUploadController;
  late File file;
  late AttachmentFile attachment;
  setUp(() {
    mockkUploadController = MockUploadController();
    file = assetFile('test_image.jpeg');

    attachment = AttachmentFile(
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
  });
  testWidgets('UploadListCore', (tester) async {
    when(() => mockkUploadController.uploadsStream).thenAnswer((_) =>
        Stream.value([
          FileUploadState(file: attachment, state: UploadSuccess('cdnUrl'))
        ]));
    await tester.pumpWidget(MaterialApp(
      home: UploadListCore(
        files: [attachment],
        uploadController: mockkUploadController,
      ),
    ));

    verify(() => mockkUploadController.uploadsStream).called(1);
  });
}
