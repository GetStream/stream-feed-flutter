import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart' show AttachmentFile;
import 'package:stream_feed_flutter_core/src/media.dart';
import 'package:stream_feed_flutter_core/src/upload/states.dart';
import 'package:stream_feed_flutter_core/src/upload/widgets.dart';
import 'package:stream_feed_flutter_core/src/upload_list_core.dart';

import 'mocks.dart';
import 'utils.dart';

void main() {
  late MockUploadController mockUploadController;
  late File file;
  late File file2;
  late AttachmentFile attachment;
  late AttachmentFile attachment2;
  late String cdnUrl;
  late String cdnUrl2;

  setUp(() {
    cdnUrl = 'https://us-east.stream-io-cdn.com/something.png';
    cdnUrl2 = 'https://us-east.stream-io-cdn.com/something.jpeg';
    mockUploadController = MockUploadController();
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
    when(() => mockUploadController.uploadsStream).thenAnswer(
      (_) => Stream.value({
        attachment:
            UploadSuccess.media(mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl)!)),
        attachment2:
            UploadSuccess.media(mediaUri: MediaUri(uri: Uri.tryParse(cdnUrl2)!))
      }),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: UploadListCore(
          uploadController: mockUploadController,
          loadingBuilder: (BuildContext context) => const SizedBox(),
          uploadsErrorBuilder: (Object error) => const SizedBox(),
          uploadsBuilder: (context, uploads) {
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: uploads.length,
                itemBuilder: (context, index) => FileUploadStateWidget(
                  fileState: uploads[index],
                  onCancelUpload: (_) {},
                  onRemoveUpload: (_) {},
                  onRetryUpload: (_) {},
                ),
              ),
            );
          },
        ),
      ),
    );

    verify(() => mockUploadController.uploadsStream).called(1);

    await tester.pumpAndSettle();

    expect(find.byType(FileUploadStateWidget), findsNWidgets(2));
  });
}
