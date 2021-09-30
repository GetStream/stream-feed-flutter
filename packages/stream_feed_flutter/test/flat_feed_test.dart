import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/pages/flat_activity_list.dart';
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
            actor: const User(
              id: 'user-id',
              data: {
                'name': 'Rosemary',
                'handle': '@rosemary',
                'subtitle': 'likes playing frisbee in the park',
                'profile_image':
                    'https://randomuser.me/api/portraits/women/20.jpg',
              },
            ),
          ),
          EnrichedActivity(
            time: DateTime.now(),
            actor: const User(
              id: 'user-id',
              data: {
                'name': 'Rosemary',
                'handle': '@rosemary',
                'subtitle': 'likes playing frisbee in the park',
                'profile_image':
                    'https://randomuser.me/api/portraits/women/20.jpg',
              },
            ),
          ),
        ];

        final mockClient = MockStreamFeedClient();
        final mockFeed = MockFeedAPI();
        final mockStreamAnalytics = MockStreamAnalytics();
        when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
        when(mockFeed.getEnrichedActivities)
            .thenAnswer((_) async => activities);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StreamFeedCore(
                analyticsClient: mockStreamAnalytics,
                client: mockClient,
                child: const FlatActivityListPage(),
              ),
            ),
          ),
        );

        verify(() => mockClient.flatFeed('user')).called(1);
        verify(mockFeed.getEnrichedActivities).called(1);
        await tester.pump();
        // expect(find.byType(FlatFeedInner), findsOneWidget);TODO:fix me
      });
    });

    testWidgets('Default FlatActivityListPage debugFillProperties',
        (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const FlatActivityListPage().debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '"user"');
    });
  });
}
