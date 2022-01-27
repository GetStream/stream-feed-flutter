import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/pages/compose_view.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockStreamUser mockStreamUser;
  late String kind;
  late String activityId;
  late MockReactions mockReactions;
  late Reaction reaction;
  late MockUploadController mockUpload;

  setUpAll(() {
    mockClient = MockStreamFeedClient();
    mockStreamUser = MockStreamUser();
    mockUpload = MockUploadController();
    when(() => mockClient.currentUser).thenReturn(mockStreamUser);
    when(() => mockStreamUser.id).thenReturn('test');
    kind = 'comment';
    activityId = 'test';
    mockReactions = MockReactions();

    when(() => mockClient.reactions).thenReturn(mockReactions);
  });
  group('ComposeView', () {
    testWidgets('Reply', (tester) async {
      when(() => mockUpload.uploadsStream).thenAnswer(
        (_) => Stream.value({}),
      );
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeed(
              bloc: FeedBloc(client: mockClient, uploadController: mockUpload),
              child: child!,
            );
          },
          home: ComposeView(
            textEditingController: TextEditingController(),
            feedGroup: 'user',
            parentActivity: GenericEnrichedActivity(
              id: activityId,
              object: 'test',
              verb: 'post',
              time: DateTime.now(),
              actor: const User(
                id: 'test',
                data: {
                  'full_name': 'John Doe',
                },
              ),
            ),
          ),
        ),
      );

      final elevatedButton = find.byType(ElevatedButton);
      expect(elevatedButton, findsOneWidget);
      final replyText = find.text('Reply').first;
      expect(replyText, findsOneWidget);
      final activityWidget = find.byType(ActivityWidget);
      expect(activityWidget, findsOneWidget);
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      // Enter more text.
      const testValueAddition = 'hello';
      await tester.enterText(textField, testValueAddition);
      await tester.pumpAndSettle();

      reaction = Reaction(
        kind: kind,
        activityId: activityId,
        data: {'text': testValueAddition.trim()},
      );
      when(() => mockReactions.add(
            kind,
            activityId,
            data: {'text': testValueAddition.trim()},
          )).thenAnswer((_) async => reaction);
      await tester.tap(elevatedButton);
      verify(() => mockReactions.add(
            kind,
            activityId,
            data: {'text': testValueAddition.trim()},
          ));
    });
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    ComposeView(
      textEditingController: TextEditingController(),
      parentActivity: GenericEnrichedActivity(
        id: '1',
        object: 'test',
        verb: 'post',
        time: now,
        actor: const User(
          id: 'test',
          data: {
            'full_name': 'John Doe',
          },
        ),
      ),
      feedGroup: 'user',
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'],
        '''GenericEnrichedActivity<User, String, String, String>(User(test, {full_name: John Doe}, null, null, null, null), test, post, null, null, null, 1, $now, null, null, null, null, null, null, null, null)''');
  });
}
