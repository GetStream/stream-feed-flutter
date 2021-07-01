import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/pages/notification_list.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide FlatFeed;
import 'mock.dart';

void main() {
  group('NotificationListPage', () {
    testWidgets('NotificationListPage', (tester) async {
      final activities = [
        NotificationGroup<EnrichedActivity>(
          activities: [
            EnrichedActivity(
              time: DateTime.parse(
                '2021-04-11T07:40:37.975Z',
              ),
              verb: 'follow',
              actor: EnrichableField(
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }).toJson(),
              ),
            ),
            EnrichedActivity(
              time: DateTime.parse(
                '2021-04-11T07:40:37.975Z',
              ),
              actor: EnrichableField(
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                }).toJson(),
              ),
              verb: 'follow',
            ),
            EnrichedActivity(
              time: DateTime.parse(
                '2021-04-11T07:40:37.975Z',
              ),
              actor: EnrichableField(
                User(data: {
                  'name': 'Jared Fault',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/7.jpg'
                }).toJson(),
              ),
              verb: 'follow',
            ),
          ],
        )
      ];

      final mockClient = MockStreamFeedClient();
      final mockFeed = MockNotificationFeed();
      final mockStreamAnalytics = MockStreamAnalytics();
      when(() => mockClient.notificationFeed('user')).thenReturn(mockFeed);
      when(() => mockFeed.getEnrichedActivities())
          .thenAnswer((_) async => activities);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StreamFeedCore(
              analyticsClient: mockStreamAnalytics,
              client: mockClient,
              child: NotificationListPage(
                feedGroup: 'user',
                onNotification: (BuildContext context,
                        NotificationGroup<EnrichedActivity> notification) =>
                    Text("${notification.activities?.length}"),
              ),
            ),
          ),
        ),
      );

      verify(() => mockClient.notificationFeed('user')).called(1);
      verify(() => mockFeed.getEnrichedActivities()).called(1);
      await tester.pump();
      // expect(find.byType(FlatFeedInner), findsOneWidget);TODO:fix me
    });
  });
}
