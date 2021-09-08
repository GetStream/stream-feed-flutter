import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';

main() {
  test('ActivitiesBloc', () async {
    final mockClient = MockStreamFeedClient();
    final mockFeed = MockFeedAPI();
    final mockStreamAnalytics = MockStreamAnalytics();
    final activities = [
      EnrichedActivity(
        id: "id",
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
        id: "id2",
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

    final bloc = ActivitiesBloc(client: mockClient);
    final mockReactions = MockReactions();
    final reactedActivity = activities.first;
    final reaction =
        Reaction(id: 'id', kind: 'like', activityId: reactedActivity.id);
    when(() => mockClient.reactions).thenReturn(mockReactions);

    when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
    when(() => mockFeed.getEnrichedActivities())
        .thenAnswer((_) async => activities);
    when(() => mockReactions.add(
          'like',
          'id',
        )).thenAnswer((_) async => reaction);

    await bloc.queryEnrichedActivities(feedGroup: 'user');
    await expectLater(bloc.activitiesStream, emits(activities));

    verify(() => mockClient.flatFeed('user')).called(1);
    verify(() => mockFeed.getEnrichedActivities()).called(1);

    await bloc.onAddReaction(
        kind: 'like', activity: reactedActivity, feedGroup: 'user');

    verify(() => mockClient.reactions.add(
          'like',
         'id',
        )).called(1);
    //TODO: teardown
  });
}
