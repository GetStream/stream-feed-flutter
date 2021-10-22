import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

void main() {
  testWidgets('FlatFeedCore', (tester) async {
    final mockClient = MockStreamFeedClient();
    final mockFeed = MockFeedAPI();
    final mockStreamAnalytics = MockStreamAnalytics();
    final activities = [
      GenericEnrichedActivity(
        // reactionCounts: {
        //   'like': 139,
        //   'repost': 23,
        // },
        time: DateTime.now(),
        actor: const User(
          data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          },
        ),
      ),
      GenericEnrichedActivity(
        time: DateTime.now(),
        actor: const User(
          data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          },
        ),
      ),
    ];
    when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
    when(mockFeed.getEnrichedActivities).thenAnswer((_) async => activities);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FlatFeedCore(
          feedGroup: 'user',
          feedBuilder: (BuildContext context, activities, int idx) {
            return Column(
              children: [
                Text("${activities[idx].reactionCounts?['like']}") //counts
              ],
            );
          },
        ),
      ),
    ));

    verify(() => mockClient.flatFeed('user')).called(1);
    verify(mockFeed.getEnrichedActivities).called(1);
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

  //   // ignore: cascade_invocations
  //   flatFeedCore.debugFillProperties(builder);

  //   final description = builder.properties
  //       .where((node) => !node.isFiltered(DiagnosticLevel.info))
  //       .map((node) => node.toDescription())
  //       .toList();

  //   expect(description, ['has feedBuilder', '"user"']);
  // });
}
