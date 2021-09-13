import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';

main() {
  group('FeedBloc', () {
    final mockClient = MockStreamFeedClient();
    final mockFeed = MockFeedAPI();
    final mockStreamAnalytics = MockStreamAnalytics();
    final now = DateTime.now();
    final activities = [
      EnrichedActivity(
        id: "id",
        // reactionCounts: {
        //   'like': 139,
        //   'repost': 23,
        // },
        time: now,
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
        time: now,
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

    final reactedActivity = activities.first;
    final reaction =
        Reaction(id: 'id', kind: 'like', activityId: reactedActivity.id);
    final updatedReactionWithChild = Reaction(
      id: 'id',
      kind: 'like',
      activityId: reactedActivity.id,
      childrenCounts: {
        'like': 1,
      },
      latestChildren: {
        'like': [reaction]
      },
      ownChildren: {
        'like': [reaction]
      },
    );

    final expectedResult = [
      EnrichedActivity(
        id: "id",
        reactionCounts: {
          'like': 1,
        },
        latestReactions: {
          'like': [reaction]
        },
        ownReactions: {
          'like': [reaction]
        },
        time: now,
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
        time: now,
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

    test('getEnrichedActivities/onAddReaction/onRemoveReaction', () async {
      final bloc = FeedBloc(client: mockClient);
      final mockReactions = MockReactions();

      when(() => mockClient.reactions).thenReturn(mockReactions);

      when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
      when(() => mockFeed.getEnrichedActivities())
          .thenAnswer((_) async => activities);
      when(() => mockReactions.add(
            'like',
            'id',
          )).thenAnswer((_) async => reaction);
      when(() => mockReactions.delete(
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
      await expectLater(
          bloc.reactionsStreamFor(reactedActivity.id!), emits([reaction]));
      await expectLater(bloc.activitiesStream, emits(expectedResult));
      final newReactedActivity = expectedResult.first;
      await bloc.onRemoveReaction(
        kind: 'like',
        activity: newReactedActivity,
        feedGroup: 'user',
        reaction: reaction,
      );
      verify(() => mockClient.reactions.delete(
            'id',
          )).called(1);
      await expectLater(
          bloc.reactionsStreamFor(newReactedActivity.id!), emits([]));
    });

    test('onAddChildReaction/onRemoveChildReaction', () async {
      final bloc = FeedBloc(client: mockClient);
      final mockReactions = MockReactions();

      when(() => mockClient.reactions).thenReturn(mockReactions);

      when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
      when(() => mockFeed.getEnrichedActivities())
          .thenAnswer((_) async => activities);
      when(() => mockReactions.add(
                'like',
                'id',
              ))
          .thenAnswer(
              (_) async => Reaction(id: 'id', kind: 'like', activityId: "id"));
      when(() => mockReactions.addChild(
            'like',
            'id',
          )).thenAnswer((_) async => updatedReactionWithChild);
      when(() => mockReactions.delete(
                'id',
              ))
          .thenAnswer(
              (_) async => Reaction(id: 'id', kind: 'like', activityId: "id"));

      await bloc.queryEnrichedActivities(feedGroup: 'user');
      await expectLater(bloc.activitiesStream, emits(activities));

      verify(() => mockClient.flatFeed('user')).called(1);
      verify(() => mockFeed.getEnrichedActivities()).called(1);

      final reaction = await bloc.onAddReaction(
          kind: 'like', activity: reactedActivity, feedGroup: 'user');

      verify(() => mockClient.reactions.add(
            'like',
            'id',
          )).called(1);
      await expectLater(
          bloc.reactionsStreamFor(reactedActivity.id!), emits([reaction]));
      await expectLater(bloc.activitiesStream, emits(expectedResult));

      await bloc.onAddChildReaction(
          kind: 'like', activity: reactedActivity, reaction: reaction);

      verify(() => mockClient.reactions.addChild(
            'like',
            'id',
          )).called(1);
      await expectLater(
          bloc.reactionsStreamFor(reactedActivity.id!),
          emits([
            Reaction(
              id: 'id',
              kind: 'like',
              activityId: reactedActivity.id,
              childrenCounts: {
                'like': 1,
              },
              latestChildren: {
                'like': [reaction]
              },
              ownChildren: {
                'like': [reaction]
              },
            )
          ]));

      //DELETE
      await bloc.onRemoveChildReaction(
          kind: 'like', activity: reactedActivity, reaction: reaction);

      verify(() => mockClient.reactions.delete(
            'id',
          )).called(1);

      await expectLater(
          bloc.reactionsStreamFor(reactedActivity.id!),
          emits([
            Reaction(
              id: 'id',
              kind: 'like',
              activityId: reactedActivity.id,
              childrenCounts: {
                'like': 0,
              },
              latestChildren: {
                'like': []
              },
              ownChildren: {
                'like': []
              },
            )
          ]));
    });
    //TODO: teardown

    test('updateIn reaction delete', () {
      final reactionUpdate = Reaction(
        id: 'id',
        kind: 'like',
        activityId: 'id',
        childrenCounts: {
          'like': 0,
        },
        latestChildren: {
          'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
        },
        ownChildren: {
          'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
        },
      );
      final reactions = [
        Reaction(
          id: 'id',
          kind: 'like',
          activityId: 'id',
          childrenCounts: {
            'like': 1,
          },
          latestChildren: {
            'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
          },
          ownChildren: {
            'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
          },
        )
      ];
      expect(reactions.updateIn(reactionUpdate, 0), [reactionUpdate]);
    });
    test('updateIn activities', () async {
      final firstActivity = activities.first;
      final indexPath = activities.indexOf(firstActivity);
      expect(indexPath, 0);
      final updatedActivity = firstActivity.copyWith(reactionCounts: {
        'like': 1
      }, latestReactions: {
        'like': [reaction]
      }, ownReactions: {
        'like': [reaction]
      });
      expect(updatedActivity, expectedResult.first);
      final result = activities.updateIn(updatedActivity, indexPath);
      expect(result, expectedResult);
    });

    test('updateIn reactions', () async {
      final reactions = [
        Reaction(
          id: 'id',
          kind: 'like',
          activityId: 'id',
        )
      ];
      final expectedResultReaction = Reaction(
        id: 'id',
        kind: 'like',
        activityId: 'id',
        childrenCounts: {
          'like': 1,
        },
        latestChildren: {
          'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
        },
        ownChildren: {
          'like': [Reaction(id: 'id', kind: 'like', activityId: 'id')]
        },
      );

      final firstReaction = reactions.first;
      final indexPath = reactions.indexOf(firstReaction);
      expect(indexPath, 0);
      final updatedReaction = firstReaction.copyWith(childrenCounts: {
        'like': 1
      }, latestChildren: {
        'like': [reaction]
      }, ownChildren: {
        'like': [reaction]
      });
      expect(updatedReaction, expectedResultReaction);
      final result = reactions.updateIn(updatedReaction, indexPath);
      expect(result, [expectedResultReaction]);
    });
  });
}
