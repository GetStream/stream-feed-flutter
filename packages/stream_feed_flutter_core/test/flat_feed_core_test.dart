import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

void main() {
  testWidgets('FlatFeedCore', (tester) async {
    final mockClient = MockStreamFeedClient();
    final mockFeed = MockFlatFeed();
    final mockStreamAnalytics = MockStreamAnalytics();
    const feedGroup = 'user';
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
    when(mockFeed.getPaginatedEnrichedActivities)
        .thenAnswer((_) async => const PaginatedActivities(
              next: nextParamsString,
              results: enrichedActivitiesFirstResult,
            ));
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) =>
            GenericFeedProvider<Object?, Object?, Object?, Object?>(
          bloc: GenericFeedBloc<Object?, Object?, Object?, Object?>(
            client: mockClient,
            analyticsClient: mockStreamAnalytics,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: GenericFlatFeedCore(
            feedGroup: feedGroup,
            errorBuilder: (context, error) => const Text('error'),
            loadingBuilder: (context) => const CircularProgressIndicator(),
            emptyBuilder: (context) => const Text('empty'),
            feedBuilder: (
              BuildContext context,
              activities,
            ) {
              return const Text('activities');
            },
          ),
        ),
      ),
    );

    verify(() =>
            mockClient.flatFeed(feedGroup).getPaginatedEnrichedActivities())
        .called(1);
  });

  // test('Default FlatFeedCore debugFillProperties', () {
  //   final builder = DiagnosticPropertiesBuilder();
  //   final flatFeedCore = FlatFeedCore(
  //     feedGroup: 'user',
  //     feedBuilder: (BuildContext context,
  //         List<EnrichedActivity<User, String, String, String>> activities,
  //         int idx) {
  //       return Column(
  //         children: [
  //           Text("${activities[idx].reactionCounts?['like']}") //counts
  //         ],
  //       );
  //     },
  //   );

  //   flatFeedCore.debugFillProperties(builder);

  //   final description = builder.properties
  //       .where((node) => !node.isFiltered(DiagnosticLevel.info))
  //       .map((node) => node.toDescription())
  //       .toList();

  //   expect(description, ['has feedBuilder', '"user"']);
  // });
}
