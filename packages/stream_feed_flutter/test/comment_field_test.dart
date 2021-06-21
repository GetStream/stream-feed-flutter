import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/text.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:mocktail/mocktail.dart';
import 'mock.dart';

void main() {
  testWidgets('CommentField', (WidgetTester tester) async {
    final key = GlobalKey();
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    final mockStreamAnalytics = MockStreamAnalytics();
    when(() => mockClient.reactions).thenReturn(mockReactions);
    const foreignId = 'like:300';
    const activityId = 'activityId';
    const feedGroup = 'whatever:300';
    const kind = 'comment';
    const textInput = 'Soup';
    const reaction = Reaction(
      kind: kind,
      activityId: activityId,
      data: {'text': textInput},
    );
    final activity = EnrichedActivity(id: activityId, foreignId: foreignId);
    const label = kind;
    final engagement = Engagement(
        content: Content(foreignId: FeedId.fromId(activity.foreignId)),
        label: label,
        feedId: FeedId.fromId(feedGroup));

    when(() => mockReactions.add(
          kind,
          activityId,
          data: {'text': textInput},
        )).thenAnswer((_) async => reaction);

    when(() => mockStreamAnalytics.trackEngagement(engagement))
        .thenAnswer((_) async => Future.value());
    final textEditingController = TextEditingController();

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: StreamFeedCore(
        analyticsClient: mockStreamAnalytics,
        client: mockClient,
        child: CommentField(
          key: key,
          feedGroup: feedGroup,
          activity: activity,
          textEditingController: textEditingController,
        ),
      ),
    )));

    final avatar = find.byType(Avatar);
    final textArea = find.byType(TextArea);
    final button = find.byType(ElevatedButton);
    expect(avatar, findsOneWidget);
    expect(textArea, findsOneWidget);
    // expect(button, findsOneWidget);
    await tester.enterText(textArea, textInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    tester.widget<EditableText>(find.text(textInput));

    // final commentFieldState = key.currentState! as CommentFieldState;
    expect(textEditingController.value.text, textInput);

    await tester.tap(button);
    verify(() => mockClient.reactions.add(kind, activityId)).called(1);
    verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
  });
}
