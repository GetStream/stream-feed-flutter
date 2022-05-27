import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/reactions_list_core.dart';

import 'mocks.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockReactions mockReactions;
  late MockStreamAnalytics mockStreamAnalytics;
  late LookupAttribute lookupAttr;
  late String lookupValue;
  late Filter filter;
  late String kind;
  late int limit;
  late String activityId;
  late String userId;
  late List<FeedId> targetFeeds;
  late Map<String, String> data;
  late List<Reaction> reactions;

  setUp(() {
    mockClient = MockStreamFeedClient();
    mockReactions = MockReactions();
    mockStreamAnalytics = MockStreamAnalytics();
    when(() => mockClient.reactions).thenReturn(mockReactions);
    lookupAttr = LookupAttribute.activityId;
    lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    filter = Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
    kind = 'like';
    limit = 5;
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
    when(() => mockReactions.filter(
          lookupAttr,
          lookupValue,
          filter: filter,
          limit: limit,
          kind: kind,
        )).thenAnswer((_) async => reactions);
    when(() => mockReactions.paginatedFilter(
          lookupAttr,
          lookupValue,
          filter: filter,
          limit: limit,
          kind: kind,
        )).thenAnswer((_) async => PaginatedReactions(
          results: reactions,
        ));
  });

  testWidgets('ReactionListCore', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => GenericFeedProvider(
          bloc: GenericFeedBloc(
            client: mockClient,
            analyticsClient: mockStreamAnalytics,
          ),
          child: child!,
        ),
        home: Scaffold(
          body: GenericReactionListCore(
            reactionsBuilder: (context, reactions) => const SizedBox(),
            emptyBuilder: (BuildContext context) => const SizedBox(),
            errorBuilder: (BuildContext context, Object error) =>
                const SizedBox(),
            loadingBuilder: (BuildContext context) => const SizedBox(),
            lookupValue: lookupValue,
            filter: filter,
            limit: limit,
            kind: kind,
          ),
        ),
      ),
    );
    verify(() => mockReactions.paginatedFilter(lookupAttr, lookupValue,
        filter: filter, limit: limit, kind: kind)).called(1);
  });

  // test('Default ReactionListCore debugFillProperties', () {
  //   final builder = DiagnosticPropertiesBuilder();
  //   final reactionListCore = ReactionListCore(
  //     reactionsBuilder: (context, reactions, idx) => const Offstage(),
  //     lookupValue: lookupValue,
  //     filter: filter,
  //     limit: limit,
  //     kind: kind,
  //   );

  //   reactionListCore.debugFillProperties(builder);

  //   final description = builder.properties
  //       .where((node) => !node.isFiltered(DiagnosticLevel.info))
  //       .map((node) => node.toDescription())
  //       .toList();

  //   expect(description, [
  //     'has reactionsBuilder',
  //     'activityId',
  //     '"ed2837a6-0a3b-4679-adc1-778a1704852d"',
  //     '{_Filter.idGreaterThan: e561de8f-00f1-11e4-b400-0cc47a024be0}',
  //     'null',
  //     '5',
  //     '"like"'
  //   ]);
  // });
}
