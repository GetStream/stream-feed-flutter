import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/status_update_controller.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

main() {
  testWidgets('MediasAction', (tester) async {
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

  testWidgets('PostCommentButton', (tester) async {
    final controller = MockStatusUpdateFormController();
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    final mockfiles = MockFiles();
    const kind = 'comment';
    const activityId = 'activityId';
    const foreignId = 'like:300';
    const lastPickedImage = 'dummyPath';
    const uploadedImageUrl = 'dummyImageUrl';
    final data = {
      'text': 'Soup',
      'attachments': OpenGraphData(images: [
        OgImage(
          image: uploadedImageUrl,
        )
      ]).toJson(),
    };
    final reaction =
        Reaction(id: 'id', kind: kind, activityId: activityId, data: data);
    final activity = EnrichedActivity(id: activityId, foreignId: foreignId);

    // when(() => mockClient.reactions).thenReturn(mockReactions);
    when(() => mockClient.files).thenReturn(mockfiles);
    when(() => controller.lastPickedImage).thenReturn(lastPickedImage);
    when(() => mockfiles.upload(AttachmentFile(path: lastPickedImage)))
        .thenAnswer((_) async => uploadedImageUrl);
    when(() => mockReactions.add(kind, activityId, data: data))
        .thenAnswer((_) async => reaction);
    var textEditingController = TextEditingController(text: 'Soup');
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: StreamFeedCore(
        client: mockClient,
        child: PostCommentButton(
          activity: activity,
          statusUpdateFormController: controller,
          textEditingController: textEditingController,
        ),
      ),
    )));
    // final textFieldWidget = find.byType(TextField);
    // await tester.enterText(textFieldWidget, 'Soup');
    // await tester.testTextInput.receiveAction(TextInputAction.done);

    expect(textEditingController.value.text, 'Soup');
    final postCommentButton = find.text('Respond');
    expect(postCommentButton, findsOneWidget);
    final button = find.byType(ReactiveElevatedButton);
    expect(button, findsOneWidget);
        await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();
    // verify(()=>controller.lastPickedImage).called(1);
    // verify(() => mockfiles.upload(AttachmentFile(path: lastPickedImage)))
    //     .called(1);
    // verify(() => mockReactions.add(kind, activityId, data: data)).called(1);
  });
}
