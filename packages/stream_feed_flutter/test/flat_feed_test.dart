import 'package:flutter/material.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/pages/flat_activity_list.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide FlatFeed;
import 'mock.dart';

void main() {
  group('ActivityListPage', () {
    testWidgets('ActivityListPage', (tester) async {
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
              body: StreamFeedProvider(
                analyticsClient: mockStreamAnalytics,
                client: mockClient,
                child: ActivitiesProvider(
                  bloc: ActivitiesBloc(
                    client: mockClient,
                  ),
                  child: FlatActivityListPage(
                    feedGroup: 'user',
                  ),
                ),
              ),
            ),
          ),
        );

        verify(() => mockClient.flatFeed('user')).called(1);
        verify(() => mockFeed.getEnrichedActivities()).called(1);
        await tester.pump();
        // expect(find.byType(FlatFeedInner), findsOneWidget);TODO:fix me
      });
    });
  });
}
