import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

class OnAddChildReactionWidget extends StatefulWidget {
  const OnAddChildReactionWidget(
      {Key? key, required this.reaction, required this.kind})
      : super(key: key);

  final Reaction reaction;
  final String kind;

  @override
  _OnAddChildReactionWidgetState createState() =>
      _OnAddChildReactionWidgetState();
}

class _OnAddChildReactionWidgetState extends State<OnAddChildReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await StreamFeedProvider.of(context).onAddChildReaction(//TODO: get rid of mutations in StreamFeedProvider 
          reaction: widget.reaction,
          kind: widget.kind,
        );
      },
    );
  }
}

main() {
  const kind = 'like';
  const foreignId = 'like:300';
  const activityId = 'activityId';
  const feedGroup = 'timeline:300';
  final activity = EnrichedActivity(id: activityId, foreignId: foreignId);
  const reaction = Reaction(id: 'id', kind: kind, activityId: activityId);

  testWidgets('OnAddReaction', (tester) async {
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    final mockStreamAnalytics = MockStreamAnalytics();
    when(() => mockClient.reactions).thenReturn(mockReactions);

    const label = kind;
    //TODO analytics?
    // final engagement = Engagement(
    //     content: Content(foreignId: FeedId.fromId(activity.foreignId)),
    //     label: label,
    //     feedId: FeedId.fromId(feedGroup));

    when(() => mockReactions.addChild(
          kind,
          reaction.id!,
        )).thenAnswer((_) async => reaction);

    // when(() => mockStreamAnalytics.trackEngagement(engagement))
    //     .thenAnswer((_) async => Future.value());

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: StreamFeedProvider(
          analyticsClient: mockStreamAnalytics,
          client: mockClient,
          child: OnAddChildReactionWidget(reaction: reaction, kind: kind)),
    )));
    final reactionIcon = find.byType(InkWell);
    expect(reactionIcon, findsOneWidget);
    await tester.tap(reactionIcon);
    verify(() => mockClient.reactions.add(
          kind,
          reaction.id!,
        )).called(1);
    // verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
  });
}
