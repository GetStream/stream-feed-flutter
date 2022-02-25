import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockFlatFeed timelineFeed;
  late MockFlatFeed timelineFeed2;
  late MockFlatFeed userFeed;
  late MockStreamUser mockUser;
  late MockFeedBloc mockFeedBloc;
  late String id;
  setUp(() {
    mockClient = MockStreamFeedClient();
    mockFeedBloc = MockFeedBloc();

    timelineFeed = MockFlatFeed();
    timelineFeed2 = MockFlatFeed();
    userFeed = MockFlatFeed();
    mockUser = MockStreamUser();
    id = 'sacha';
    when(() => mockFeedBloc.client).thenReturn(mockClient);
    when(() => mockClient.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn(id);
    when(() => mockFeedBloc.isFollowingFeed(followerId: '2'))
        .thenAnswer((_) async => false);
    when(() => mockClient.flatFeed('timeline')).thenReturn(timelineFeed);
    when(() => mockClient.flatFeed('timeline', id)).thenReturn(timelineFeed2);
    when(() => mockClient.flatFeed('user', id)).thenReturn(userFeed);
    when(() => mockFeedBloc.followersUsers()).thenAnswer((_) async => [
          User(id: 'nash', data: {
            'handle': '@Nash',
            'name': 'Nash',
            'profile_image': 'https://randomuser.me/api/portraits/women/1.jpg',
          }),
          User(id: 'reuben', data: {
            'handle': '@GroovinChip',
            'name': 'Reuben',
            'profile_image': 'https://randomuser.me/api/portraits/women/1.jpg',
          })
        ]);
    when(() => mockFeedBloc.followingUsers()).thenAnswer((_) async => [
          User(id: 'nash', data: {
            'handle': '@Nash',
            'name': 'Nash',
            'profile_image': 'https://randomuser.me/api/portraits/women/1.jpg',
          }),
          User(id: 'reuben', data: {
            'handle': '@GroovinChip',
            'name': 'Reuben',
            'profile_image': 'https://randomuser.me/api/portraits/women/1.jpg',
          })
        ]);
    when(() => userFeed.followers()).thenAnswer((_) async => [
          Follow(
              feedId: "user:nash",
              targetId: "user:sacha",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
          Follow(
              feedId: "user:reuben",
              targetId: "user:sacha",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now())
        ]);
    when(() => timelineFeed2.following()).thenAnswer((_) async => [
          Follow(
              feedId:
                  "user:reuben", //TODO(sacha):hmm weird in my mind targetId and feedId are reversed
              targetId: "user:sacha",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()),
          Follow(
              feedId: "user:nash",
              targetId: "user:sacha",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now())
        ]);
    when(() => timelineFeed.following(
          limit: 1,
          offset: 0,
          filter: [
            FeedId.id('user:2'),
          ],
        )).thenAnswer((_) async => <Follow>[]);
  });

  testWidgets('FollowingListView', (tester) async {
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: mockFeedBloc,
            child: child!,
          );
        },
        home: Scaffold(
            body: FollowingListView(
                builder: (user) => Text("${user.data!['name']}")))));
    await tester.pumpAndSettle();
    // verify(() => timelineFeed2.following()).called(1);
    expect(find.text('Reuben'), findsOneWidget);
    expect(find.text('Nash'), findsOneWidget);
  });

  testWidgets('FollowersListView', (tester) async {
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: mockFeedBloc,
            child: child!,
          );
        },
        home: Scaffold(
            body: FollowersListView(
                builder: (user) => Text("${user.data!['name']}")))));
    await tester.pumpAndSettle();
    // verify(() => userFeed.followers()).called(1);
    expect(find.text('Reuben'), findsOneWidget);
    expect(find.text('Nash'), findsOneWidget);
  });

  testWidgets('FollowStatsWidget', (tester) async {
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: mockFeedBloc,
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
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) {
          return StreamFeed(
            bloc: mockFeedBloc,
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
    // verify(() => mockClient.flatFeed('timeline')).called(1);
    // verify(() => timelineFeed.following(
    //       limit: 1,
    //       offset: 0,
    //       filter: [
    //         FeedId.id('user:2'),
    //       ],
    //     )).called(1);
  });
}
