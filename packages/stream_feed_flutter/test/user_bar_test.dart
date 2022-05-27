import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockStreamUser mockUser;

  setUpAll(() {
    mockClient = MockStreamFeedClient();
    mockUser = MockStreamUser();
    when(() => mockClient.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('test');
  });

  testWidgets('UserBar', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeed(
              bloc: FeedBloc(
                client: mockClient,
              ),
              child: child!,
            );
          },
          home: Scaffold(
            body: UserBar(
              feedGroup: 'timeline',
              showReactedBy: true,
              activityId: '1',
              kind: 'like',
              timestamp: DateTime.now(),
              user: const User(
                data: {
                  'name': 'Rosemary',
                  'handle': '@rosemary',
                  'subtitle': 'likes playing fresbee in the park',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/20.jpg',
                },
              ),
            ),
          ),
        ),
      );

      final avatar = find.byType(Avatar);
      expect(avatar, findsOneWidget);

      final username = find.text('Rosemary').first;
      expect(username, findsOneWidget);

      final timeago = find.text('a moment ago').first;
      expect(timeago, findsOneWidget);

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);

      final by = find.text('by ').first;
      expect(by, findsOneWidget);
      final handle = find.text('@rosemary').first;
      expect(handle, findsOneWidget);
    });
  });

  testWidgets('Default UserBar debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    final userBar = UserBar(
      activityId: '1',
      feedGroup: 'timeline',
      kind: 'like',
      timestamp: now,
      user: const User(
        data: {
          'name': 'Rosemary',
          'handle': '@rosemary',
          'subtitle': 'likes playing fresbee in the park',
          'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
        },
      ),
    );

    userBar.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], '1');
  });

  testWidgets('Default ReactedBy debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const reactedBy = ReactedBy(
      handleOrUsername: 'groovin',
      icon: Icon(Icons.person),
    );

    reactedBy.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], '"groovin"');
  });

  testWidgets('Default ReactedByIcon debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const reactionByIcon = ReactionByIcon(
      kind: 'test',
    );

    reactionByIcon.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], '"test"');
  });
}
