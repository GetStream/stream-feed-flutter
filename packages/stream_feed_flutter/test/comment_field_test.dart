import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/comment_field.dart';
import 'package:stream_feed_flutter/src/textarea.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:mocktail/mocktail.dart';
import 'mock.dart';

void main() {
  testWidgets('CommentField', (WidgetTester tester) async {
    final key = GlobalKey();
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    when(() => mockClient.reactions).thenReturn(mockReactions);
    const activityId = 'activityId';
    const kind = 'comment';
    const textInput = 'Soup';
    const reaction = Reaction(
      kind: kind,
      activityId: activityId,
      data: {'text': textInput},
    );

    when(() => mockReactions.add(
          kind,
          activityId,
          data: {'text': textInput},
        )).thenAnswer((_) async => reaction);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: StreamFeedCore(
        client: mockClient,
        child: CommentField(
          key: key,
          feedGroup: 'whatever',
          activity: EnrichedActivity(id: activityId),
        ),
      ),
    )));

    final avatar = find.byType(Avatar);
    final textArea = find.byType(TextArea);
    final button = find.byType(Button);
    expect(avatar, findsOneWidget);
    expect(textArea, findsOneWidget);
    expect(button, findsOneWidget);
    await tester.enterText(textArea, textInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    tester.widget<EditableText>(find.text(textInput));

    final commentFieldState = key.currentState! as CommentFieldState;
    expect(commentFieldState.text, textInput);

    await tester.tap(button);
    verify(() => mockClient.reactions.add(kind, activityId)).called(1);
  });
}
