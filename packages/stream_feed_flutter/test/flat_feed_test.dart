import 'package:flutter/material.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/activity.dart';
import 'package:stream_feed_flutter/src/flat_feed.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart' hide FlatFeed;
import 'package:mocktail/mocktail.dart';
import 'mock.dart';

void main() {
  group('FlatFeed', () {
    testWidgets('FlatFeed', (tester) async {
      await mockNetworkImages(() async {
        final activities = [
          EnrichedActivity(
            time: DateTime.now(),
            actor: EnrichableField(
              User(data: {
                'name': 'Rosemary',
                'handle': '@rosemary',
                'subtitle': 'likes playing fresbee in the park',
                'profile_image':
                    'https://randomuser.me/api/portraits/women/20.jpg',
              }).toJson(),
            ),
          ),
          EnrichedActivity(
            time: DateTime.now(),
            actor: EnrichableField(
              User(data: {
                'name': 'Rosemary',
                'handle': '@rosemary',
                'subtitle': 'likes playing fresbee in the park',
                'profile_image':
                    'https://randomuser.me/api/portraits/women/20.jpg',
              }).toJson(),
            ),
          ),
        ];

        final mockClient = MockStreamFeedClient();
        final mockFeed = MockFeedAPI();
        final mockStreamAnalytics = MockStreamAnalytics();
        when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
        when(() => mockFeed.getEnrichedActivities())
            .thenAnswer((_) async => activities);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StreamFeedCore(
                analyticsClient: mockStreamAnalytics,
                client: mockClient,
                child: FlatFeed(
                  feedGroup: 'user',
                ),
              ),
            ),
          ),
        );

        verify(() => mockClient.flatFeed('user')).called(1);
        verify(() => mockFeed.getEnrichedActivities()).called(1);
        await tester.pump();
        expect(find.byType(FlatFeedInner), findsOneWidget);
      });
    });

    testWidgets('Inner', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FlatFeedInner(activities: [
                EnrichedActivity(
                  time: DateTime.now(),
                  actor: EnrichableField(
                    User(data: {
                      'name': 'Rosemary',
                      'handle': '@rosemary',
                      'subtitle': 'likes playing fresbee in the park',
                      'profile_image':
                          'https://randomuser.me/api/portraits/women/20.jpg',
                    }),
                  ),
                ),
                EnrichedActivity(
                  time: DateTime.now(),
                  actor: EnrichableField(
                    User(data: {
                      'name': 'Rosemary',
                      'handle': '@rosemary',
                      'subtitle': 'likes playing fresbee in the park',
                      'profile_image':
                          'https://randomuser.me/api/portraits/women/20.jpg',
                    }),
                  ),
                ),
              ]),
            ),
          ),
        );
        expect(find.byType(StreamFeedActivity), findsNWidgets(2));
      });
    });
  });
}
