import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/src/reactions_list_core.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

main() {
  testWidgets('ReactionListCore', (tester) async {
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    final mockStreamAnalytics = MockStreamAnalytics();
    when(() => mockClient.reactions).thenReturn(mockReactions);
    const lookupAttr = LookupAttribute.activityId;
    const lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    final filter =
        Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
    const kind = 'like';
    const limit = 5;
    const activityId = 'activityId';
    const userId = 'john-doe';
    const targetFeeds = <FeedId>[];
    const data = {'text': 'awesome post!'};
    const reactions = [
      Reaction(
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeeds,
      )
    ];
    when(() => mockReactions.filter(
          lookupAttr,
          lookupValue,
          filter: filter,
          limit: limit,
          kind: kind,
        )).thenAnswer((_) async => reactions);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: StreamFeedCore(
      analyticsClient: mockStreamAnalytics,
      client: mockClient,
      child: ReactionListCore(
        feedGroup: 'user',
        onSuccess: (context, reactions, idx) => Offstage(),
        lookupValue: lookupValue,
        filter: filter,
        limit: limit,
        kind: kind,
      ),
    ))));
    verify(() => mockReactions.filter(lookupAttr, lookupValue,
        filter: filter, limit: limit, kind: kind)).called(1);
  });
}
