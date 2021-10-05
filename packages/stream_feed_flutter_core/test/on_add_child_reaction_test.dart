import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

// ignore_for_file: diagnostic_describe_all_properties

class OnAddChildReactionWidget extends StatefulWidget {
  const OnAddChildReactionWidget(
      {Key? key,
      required this.reaction,
      required this.kind,
      required this.activity})
      : super(key: key);

  final Reaction reaction;
  final String kind;
  final DefaultEnrichedActivity activity;

  @override
  _OnAddChildReactionWidgetState createState() =>
      _OnAddChildReactionWidgetState();
}

class _OnAddChildReactionWidgetState extends State<OnAddChildReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await DefaultFeedBlocProvider.of(context).bloc.onAddChildReaction(
              activity: widget.activity,
              reaction: widget.reaction,
              kind: widget.kind,
            );
      },
    );
  }
}

void main() {
  const kind = 'like';
  const foreignId = 'like:300';
  const activityId = 'activityId';
  const feedGroup = 'timeline:300';
  const activity =
      DefaultEnrichedActivity(id: activityId, foreignId: foreignId);
  const reaction = Reaction(id: 'id', kind: kind, activityId: activityId);

  testWidgets('OnAddChildReaction', (tester) async {
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
      body: DefaultFeedBlocProvider(
        bloc: DefaultFeedBloc(
          analyticsClient: mockStreamAnalytics,
          client: mockClient,
        ),
        child: OnAddChildReactionWidget(
          activity: activity,
          reaction: reaction,
          kind: kind,
        ),
      ),
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
