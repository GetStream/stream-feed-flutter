import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart' show AttachmentFile;
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';
import 'package:stream_feed_flutter_core/src/upload_core.dart';

import 'mocks.dart';
import 'utils.dart';

void main() {
  late MockUploadController mockkUploadController;
  late File file;
  late File file2;
  late AttachmentFile attachment;
  late AttachmentFile attachment2;
  setUp(() {
    mockkUploadController = MockUploadController();
    file = assetFile('test_image.jpeg');

    attachment = AttachmentFile(
      path: file.path,
      bytes: file.readAsBytesSync(),
    );
    file2 = assetFile('test_image2.png');

    attachment2 = AttachmentFile(
      path: file2.path,
      bytes: file2.readAsBytesSync(),
    );
  });
  testWidgets('UploadListCore', (tester) async {
    when(() => mockkUploadController.uploadsStream)
        .thenAnswer((_) => Stream.value([
              FileUploadState(file: attachment, state: UploadSuccess('cdnUrl')),
              FileUploadState(
                  file: attachment2, state: UploadSuccess('cdnUrl2'))
            ]));
    await tester.pumpWidget(MaterialApp(
      home: UploadListCore(
        files: [attachment, attachment2],
        uploadController: mockkUploadController,
      ),
    ));

    verify(() => mockkUploadController.uploadsStream).called(1);

    await tester.pumpAndSettle();

    expect(find.byType(FileUploadStateWidget), findsNWidgets(2));
  });
}
