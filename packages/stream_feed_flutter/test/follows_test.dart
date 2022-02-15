import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'mock.dart';

void main() {
  late MockStreamFeedClient mockClient;
  setUp(() {
    mockClient = MockStreamFeedClient();
  });

  // test('FollowingListView', () {

  // });

  // test('FollowersListView', () {

  // });

  testWidgets('FollowStatsWidget', (tester) async {
    mockClient = MockStreamFeedClient();
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
    final followers = find.text('Followers');
    final following = find.text('Following');

    expect(followers, findsOneWidget);
    expect(following, findsOneWidget);
  });
  testWidgets('FollowButton', (tester) async {
    final mockFeed = MockFlatFeed();
    when(() => mockClient.flatFeed('timeline')).thenReturn(mockFeed);
    when(() => mockFeed.following(
          limit: 1,
          offset: 0,
          filter: [
            FeedId.id('user:2'),
          ],
        )).thenAnswer((_) async => <Follow>[]);

    // final isFollowing = await bloc.isFollowingFeed(followerId: '2');
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: FeedBloc(client: mockClient),
            child: child!,
          );
        },
        home: const Scaffold(
            body: FollowButton(
          user: User(id: '2', followersCount: 1, followingCount: 3),
        ))));
 
    await tester.pumpAndSettle();
    expect(find.byType(OutlinedButton), findsOneWidget);
       expect(find.text('Follow'), findsOneWidget);
  });
}
