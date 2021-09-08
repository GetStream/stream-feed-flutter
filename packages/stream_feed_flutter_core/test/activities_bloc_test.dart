import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

main() {
  test('ActivitiesBloc', () async {
    final mockClient = MockStreamFeedClient();
    final mockFeed = MockFeedAPI();
    final mockStreamAnalytics = MockStreamAnalytics();
    final activities = [
      EnrichedActivity(
        // reactionCounts: {
        //   'like': 139,
        //   'repost': 23,
        // },
        time: DateTime.now(),
        actor: EnrichableField(
          User(data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
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
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          }).toJson(),
        ),
      ),
    ];
    when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
    when(() => mockFeed.getEnrichedActivities())
        .thenAnswer((_) async => activities);

    final bloc = ActivitiesBloc(client: mockClient);
    await bloc.queryEnrichedActivities(feedGroup: 'user');

    verify(() => mockClient.flatFeed('user')).called(1);
    verify(() => mockFeed.getEnrichedActivities()).called(1);
  });
}
