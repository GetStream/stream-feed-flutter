import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/pages/flat_feed_list_view.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide FlatFeed;

import 'mock.dart';

void main() {
  group('FlatActivityListPage', () {
    testWidgets('widget', (tester) async {
      await mockNetworkImages(() async {
        const feedGroup = 'user';
        final mockClient = MockStreamFeedClient();
        final mockFeed = MockFlatFeed();
        final mockStreamAnalytics = MockStreamAnalytics();

        const keyField = 'q29npdvqjr99';
        const idLtField = 'f168f547-b59f-11ec-85ff-0a2d86f21f5d';
        const limitField = '10';
        const nextParamsString =
            '/api/v1.0/enrich/feed/user/gordon/?api_key=$keyField&id_lt=$idLtField&limit=$limitField';

        // FIRST RESULT

        const enrichedActivitiesFirstResult = [
          EnrichedActivity(id: '1'),
          EnrichedActivity(id: '2')
        ];
        when(() => mockClient.flatFeed(feedGroup)).thenReturn(mockFeed);
        when(mockFeed.getPaginatedEnrichedActivities).thenAnswer(
          (_) {
            return Future.value(
              const PaginatedActivities(
                next: nextParamsString,
                results: enrichedActivitiesFirstResult,
              ),
            );
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FeedProvider(
                bloc: FeedBloc(
                  analyticsClient: mockStreamAnalytics,
                  client: mockClient,
                ),
                child: const FlatFeedListView(),
              ),
            ),
          ),
        );

        verify(() =>
                mockClient.flatFeed(feedGroup).getPaginatedEnrichedActivities())
            .called(1);
        await tester.pump();
        // expect(find.byType(FlatFeedInner), findsOneWidget);TODO:fix me
      });
    });

    // testWidgets('Default FlatActivityListPage debugFillProperties',
    //     (tester) async {
    //   final builder = DiagnosticPropertiesBuilder();
    //   const FlatActivityListPage().debugFillProperties(builder);

    //   final description = builder.properties
    //       .where((node) => !node.isFiltered(DiagnosticLevel.info))
    //       .map((node) =>
    //           node.toJsonMap(const DiagnosticsSerializationDelegate()))
    //       .toList();

    //   expect(description[0]['description'], '"user"');
    // });
  });
}
