import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  late MockStreamFeedClient client;
  late MockStreamUser mockStreamUser;

  setUpAll(() {
    client = MockStreamFeedClient();
    mockStreamUser = MockStreamUser();
    when(() => client.currentUser).thenReturn(mockStreamUser);
    when(() => mockStreamUser.id).thenReturn('test');
  });

  testWidgets('ComposeView', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: FeedBloc(client: client),
            child: child!,
          );
        },
        home: ComposeView(
          feedGroup: 'user',
          parentActivity: GenericEnrichedActivity(
            id: '1',
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
    final activityWidget = find.byType(ActivityWidget);
    expect(activityWidget, findsOneWidget);
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
  });

  testWidgets('debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    ComposeView(
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