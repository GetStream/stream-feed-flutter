import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:meta/meta.dart';
import '../mocks.dart';

main() {
  group('FeedBloc', () {
    late MockStreamFeedClient mockClient;
    late MockFeedAPI mockFeed;
    late MockStreamAnalytics mockStreamAnalytics;
    late DateTime now;
    late List<EnrichedActivity> activities;
    late EnrichedActivity reactedActivity;
    late Reaction reaction;
    late Reaction updatedReactionWithChild;
    late List<EnrichedActivity> expectedResult;
    late FeedBloc bloc;
    late MockReactions mockReactions;

    setUp(() {
      mockClient = MockStreamFeedClient();
      mockFeed = MockFeedAPI();
      mockStreamAnalytics = MockStreamAnalytics();
      now = DateTime.now();
      activities = [
        EnrichedActivity(
          id: "id",
          time: now,
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
          id: "id2",
          time: now,
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
      reactedActivity = activities.first;
      reaction =
          Reaction(id: 'id', kind: 'like', activityId: reactedActivity.id);
      updatedReactionWithChild = Reaction(
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
      expectedResult = [
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
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
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
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            }).toJson(),
          ),
        ),
      ];
      bloc = FeedBloc(client: mockClient);
      mockReactions = MockReactions();
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
      when(() => mockReactions.addChild(
            'like',
            'id',
          )).thenAnswer((_) async => updatedReactionWithChild);
    });

    Future<void> testQueryEnrichedActivities(
        List<EnrichedActivity> activities) async {
      await bloc.queryEnrichedActivities(feedGroup: 'user');
      await expectLater(bloc.activitiesStream, emits(activities));

      verify(() => mockClient.flatFeed('user')).called(1);
      verify(() => mockFeed.getEnrichedActivities()).called(1);
    }

    test('onAddReaction', () async {
      await testQueryEnrichedActivities(activities);

      await bloc.onAddReaction(
          kind: 'like', activity: reactedActivity, feedGroup: 'user');

      verify(() => mockClient.reactions.add(
            'like',
            'id',
          )).called(1);
      await expectLater(
          bloc.reactionsStreamFor(reactedActivity.id!), emits([reaction]));
      await expectLater(bloc.activitiesStream, emits(expectedResult));
    });
    test('onRemoveReaction', () async {
      await testQueryEnrichedActivities(activities);
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
      await testQueryEnrichedActivities(activities);

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
              latestChildren: {'like': []},
              ownChildren: {'like': []},
            )
          ]));
    });
    //TODO: teardown

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
