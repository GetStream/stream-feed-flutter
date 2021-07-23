import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

main() {
  testWidgets('PostCommentButton', (tester) async {
    final imagePicker = MockImagePicker();
    when(() => imagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) async => XFile("dummyPath"));
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MediasAction(
          statusUpdateFormController: StatusUpdateFormController(imagePicker),
        ),
      ),
    ));
    final postCommentButton = find.byType(IconButton);
    await tester.tap(postCommentButton);
    verify(() => imagePicker.pickImage(source: ImageSource.gallery)).called(1);
  });
}
