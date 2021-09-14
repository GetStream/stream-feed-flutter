import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  setUp(() {
    mockReactions = MockReactions();
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
    reactions = [
      Reaction(
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeeds,
      )
    ];
    when(() => mockClient.reactions).thenReturn(mockReactions);
    when(() => mockReactions.filter(
          lookupAttr,
          lookupValue,
          filter: filter,
          limit: limit,
          kind: kind,
        )).thenAnswer((_) async => reactions);
    bloc = FeedBloc(client: mockClient);
  });
  test('ReactionBloc', () async {
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
}
