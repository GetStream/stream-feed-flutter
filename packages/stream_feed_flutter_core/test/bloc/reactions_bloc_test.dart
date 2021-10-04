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
  late MockReactionControllers mockReactionControllers;
  late String feedGroup;

  setUp(() {
    mockReactions = MockReactions();
    mockReactionControllers = MockReactionControllers();
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
    // bloc.reactionsControllers = mockReactionControllers;
  });

  // test('hey', () {
  //   expect(bloc.reactionsControllers[lookupValue]!.value, <Reaction>[]);
  // });

  // when(() => mockReactionControllers[lookupValue])
  //     .thenAnswer((_) => BehaviorSubject.seeded(reactions));
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
      await expectLater(bloc.reactionsStreamFor(lookupValue), emits(reactions));
    });

    test('onAddReaction', () async {
      bloc.reactionsControllers = mockReactionControllers;
      when(() => mockReactionControllers[activityId])
          .thenAnswer((_) => BehaviorSubject.seeded(reactions));
      expect(bloc.reactionsControllers[activityId]!.value, reactions);
      when(() => mockReactions.add(
            kind,
            activityId,
          )).thenAnswer((_) async => Reaction());

      await bloc.onAddReaction(
          activity: EnrichedActivity(id: activityId),
          feedGroup: feedGroup,
          kind: kind);
      verify(() => mockReactions.add(
            kind,
            activityId,
          )).called(1);
    });
  });
}
