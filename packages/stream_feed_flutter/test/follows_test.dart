import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  // test('FollowingListView', () {

  // });

  // test('FollowersListView', () {

  // });

  testWidgets('FollowStatsWidget', (tester) async {
    final mockClient = MockStreamFeedClient();
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: FeedBloc(client: mockClient),
            child: child!,
          );
        },
        home: const Scaffold(
          body: FollowStatsWidget(
            user: User(followersCount: 1, followingCount: 3),
          ),
        )));
    final followersCount = find.text('1');
    final followingCount = find.text('3');
    expect(followersCount, findsOneWidget);
    expect(followingCount, findsOneWidget);
  });
  // test('FollowButton', () {

  // });
}
