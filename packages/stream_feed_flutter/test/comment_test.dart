// ignore_for_file: cascade_invocations

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/comment/item.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mock.dart';

void main() {
  testWidgets('CommentItem', (tester) async {
    await mockNetworkImages(() async {
      final pressedHashtags = <String?>[];
      final pressedMentions = <String?>[];

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Scaffold(
            body: CommentItem(
              activity: EnrichedActivity(),
              user: const User(data: {
                'name': 'Rosemary',
                'subtitle': 'likes playing fresbee in the park',
                'profile_image':
                    'https://randomuser.me/api/portraits/women/20.jpg',
              }),
              reaction: Reaction(
                createdAt: DateTime.now(),
                kind: 'comment',
                data: const {
                  'text':
                      'Snowboarding is awesome! #snowboarding #winter @sacha',
                },
              ),
              onMentionTap: pressedMentions.add,
              onHashtagTap: pressedHashtags.add,
            ),
          ),
        ),
      );

      final avatar = find.byType(Avatar);

      expect(avatar, findsOneWidget);
      final richtexts = tester.widgetList<Text>(find.byType(Text));

      expect(richtexts.toList().map((e) => e.data), [
        'Rosemary',
        'a moment ago',
        'Snowboarding ',
        'is ',
        'awesome! ',
        ' #snowboarding',
        ' #winter',
        ' @sacha',
      ]);
      expect(richtexts.toList().map((e) => e.style), [
        const TextStyle(
          color: Color(0xff0ba8e0),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        const TextStyle(
          color: Color(0xff7a8287),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        const TextStyle(
          color: Color(0xff000000),
          fontSize: 14,
        ),
        const TextStyle(
          color: Color(0xff000000),
          fontSize: 14,
        ),
        const TextStyle(
          color: Color(0xff000000),
          fontSize: 14,
        ),
        const TextStyle(
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        const TextStyle(
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        const TextStyle(
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
      ]);

      await tester.tap(find.widgetWithText(InkWell, ' #winter').first);
      await tester.tap(find.widgetWithText(InkWell, ' @sacha').first);
      expect(pressedHashtags, ['winter']);
      expect(pressedMentions, ['sacha']);
    });
  });
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
    const activity = EnrichedActivity(
      id: activityId,
      foreignId: foreignId,
    );
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

    await tester.pumpWidget(
      StreamFeedApp(
        bloc:
            FeedBloc(analyticsClient: mockStreamAnalytics, client: mockClient),
        home: Scaffold(
          body: CommentField(
            key: key,
            feedGroup: feedGroup,
            activity: activity,
            textEditingController: textEditingController,
          ),
        ),
      ),
    );

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

  testWidgets('TextArea', (WidgetTester tester) async {
    final textController = TextEditingController();
    final focusNode = FocusNode();
    final hintStyle = TextStyle(
      inherit: false,
      color: Colors.pink[500],
      fontSize: 10,
    );
    final inputTextStyle = TextStyle(
      inherit: false,
      color: Colors.green[500],
      fontSize: 12,
      textBaseline: TextBaseline.alphabetic,
    );
    var _value = '';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TextArea(
          textEditingController: textController,
          focusNode: focusNode,
          hintText: 'Placeholder',
          hintTextStyle: hintStyle,
          inputTextStyle: inputTextStyle,
          onSubmitted: (String value) {
            _value = value;
          },
        ),
      ),
    ));

    final textFieldWidget = find.byType(TextField);
    await tester.enterText(textFieldWidget, 'Soup');
    expect(focusNode.hasPrimaryFocus, isTrue);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(_value, 'Soup');
    final inputText = tester.widget<EditableText>(find.text('Soup'));
    expect(inputText.style, inputTextStyle);
    expect(focusNode.hasPrimaryFocus, isFalse);
    final hintText = tester.widget<Text>(find.text('Placeholder'));
    expect(hintText.style, hintStyle);
  });

  test('Default CommentField debugFillProperties', () {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    final commentField = CommentField(
      feedGroup: 'whatever:300',
      textEditingController: TextEditingController(),
      activity: EnrichedActivity(
        time: now,
        actor: const User(
          data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing frisbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          },
        ),
        extraData: const {
          'image':
              'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
        },
      ),
    );

    commentField.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'],
        'EnrichedActivity<dynamic, dynamic, dynamic, dynamic>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, null, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
  });

  test('Default CommentItem debugFillProperties', () {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    final commentItem = CommentItem(
      activity: EnrichedActivity(),
      reaction: Reaction(
        createdAt: now,
        kind: 'comment',
        data: const {
          'text': 'this is a piece of text',
        },
      ),
    );

    commentItem.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], 'null');
  });
}
