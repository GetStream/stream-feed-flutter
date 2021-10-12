import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/subjects.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';

main() {
  late MockStreamFeedClient mockClient;
  late MockReactions mockReactions;
  late MockStreamAnalytics mockStreamAnalytics;
  late LookupAttribute lookupAttr;
  late String lookupValue;
  late Filter filter;
  late int limit;
  late String kind;
  late List<Reaction> reactions;
  late String activityId;
  late String userId;
  late List<FeedId> targetFeeds;
  late Map<String, String> data;
  late FeedBloc bloc;
  late MockReactionsControllers mockReactionControllers;
  late String feedGroup;

  tearDown(() => bloc.dispose());

  setUp(() {
    mockReactions = MockReactions();
    mockReactionControllers = MockReactionsControllers();
    mockStreamAnalytics = MockStreamAnalytics();
    mockClient = MockStreamFeedClient();
    lookupAttr = LookupAttribute.activityId;
    lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    filter = Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');

    limit = 5;
    kind = 'like';
    activityId = 'activityId';
    userId = 'john-doe';
    targetFeeds = <FeedId>[];
    data = {'text': 'awesome post!'};
    feedGroup = 'user';
    reactions = [
      Reaction(
        id: 'id',
        kind: 'like',
        activityId: activityId,
        childrenCounts: {
          'like': 0,
        },
        latestChildren: {'like': []},
        ownChildren: {'like': []},
      )
    ];
    when(() => mockClient.reactions).thenReturn(mockReactions);

    bloc = FeedBloc(client: mockClient);
  });

  group('ReactionBloc', () {
    test('queryReactions', () async {
      when(() => mockReactions.filter(
            lookupAttr,
            lookupValue,
            filter: filter,
            limit: limit,
            kind: kind,
          )).thenAnswer((_) async => reactions);
      await bloc.queryReactions(
        lookupAttr,
        lookupValue,
        filter: filter,
        limit: limit,
        kind: kind,
      );
      verify(() => mockReactions.filter(lookupAttr, lookupValue,
          filter: filter, limit: limit, kind: kind)).called(1);
      await expectLater(bloc.getReactionsStream(lookupValue), emits(reactions));
    });

    test('onAddReaction', () async {
      final addedReaction = Reaction();
      bloc.reactionsControllers = mockReactionControllers;
      when(() => mockReactionControllers.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsControllers.getReactions(activityId), reactions);
      when(() => mockReactions.add(
            kind,
            activityId,
          )).thenAnswer((_) async => addedReaction);

      await bloc.onAddReaction(
          activity: EnrichedActivity(id: activityId),
          feedGroup: feedGroup,
          kind: kind);
      verify(() => mockReactions.add(
            kind,
            activityId,
          )).called(1);
      await expectLater(
          bloc.activitiesStream,
          emits([
            EnrichedActivity(id: activityId, reactionCounts: {
              'like': 1
            }, ownReactions: {
              'like': [addedReaction]
            }, latestReactions: {
              'like': [addedReaction]
            })
          ]));

      //TODO: test reaction Stream
    });
    test('onRemoveReaction', () async {
      const reactionId = 'reactionId';
      final reaction = Reaction(id: reactionId);
      bloc.reactionsControllers = mockReactionControllers;
      when(() => mockReactionControllers.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsControllers.getReactions(activityId), reactions);
      when(() => mockReactions.delete(reactionId))
          .thenAnswer((invocation) => Future.value());

      await bloc.onRemoveReaction(
        activity: EnrichedActivity(id: activityId, reactionCounts: {
          'like': 1
        }, ownReactions: {
          'like': [reaction]
        }, latestReactions: {
          'like': [reaction]
        }),
        feedGroup: feedGroup,
        kind: kind,
        reaction: reaction,
      );
      verify(() => mockReactions.delete(reactionId)).called(1);
      await expectLater(
          bloc.activitiesStream,
          emits([
            EnrichedActivity(
                id: activityId,
                reactionCounts: {'like': 0},
                ownReactions: {'like': []},
                latestReactions: {'like': []})
          ]));

      //TODO: test reaction Stream
    });

    test('onAddChildReaction', () async {
      final now = DateTime.now();
      final reactedActivity = EnrichedActivity(
        id: "id",
        time: now,
        actor: User(data: {
          'name': 'Rosemary',
          'handle': '@rosemary',
          'subtitle': 'likes playing fresbee in the park',
          'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
        }),
      );
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
      when(() => mockReactions.addChild(
            'like',
            'id',
          )).thenAnswer((_) async => updatedReactionWithChild);
      await bloc.onAddChildReaction(
          kind: 'like', activity: reactedActivity, reaction: reaction);

      verify(() => mockClient.reactions.addChild(
            'like',
            'id',
          )).called(1);
      // await expectLater(
      //     bloc.reactionsStreamFor(reactedActivity.id!),
      //     emits([
      //       Reaction(
      //         id: 'id',
      //         kind: 'like',
      //         activityId: reactedActivity.id,
      //         childrenCounts: {
      //           'like': 1,
      //         },
      //         latestChildren: {
      //           'like': [reaction]
      //         },
      //         ownChildren: {
      //           'like': [reaction]
      //         },
      //       )
      //     ]));

      //TODO: test reaction Stream
    });
  });
}
