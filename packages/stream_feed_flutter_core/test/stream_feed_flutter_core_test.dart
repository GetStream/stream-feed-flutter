import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OnAddReactionWidget extends StatefulWidget {
  const OnAddReactionWidget(
      {Key? key,
      required this.activity,
      required this.feedGroup,
      required this.kind})
      : super(key: key);

  final EnrichedActivity activity;
  final String feedGroup;
  final String kind;

  @override
  _OnAddReactionWidgetState createState() => _OnAddReactionWidgetState();
}

class _OnAddReactionWidgetState extends State<OnAddReactionWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await StreamFeedCore.of(context).onAddReaction(
          activity: widget.activity,
          feedGroup: widget.feedGroup,
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
  final activity = EnrichedActivity(id: activityId, foreignId: foreignId);
  const reaction = Reaction(id: 'id', kind: kind, activityId: activityId);
  testWidgets(
    'should render StreamFeedCore if both client and child is provided',
    (tester) async {
      final mockClient = MockClient();
      const streamFeedCoreKey = Key('streamFeedCore');
      final childKey = GlobalKey();
      final streamFeedCore = StreamFeedCore(
        key: streamFeedCoreKey,
        client: mockClient,
        child: TestWidget(key: childKey),
      );

      await tester.pumpWidget(streamFeedCore);

      expect(find.byKey(streamFeedCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
      expect(
          StreamFeedCore.of(childKey.currentState!.context).client, isNotNull);
    },
  );
  testWidgets(
    'throw an error if StreamFeedCore is not in the tree',
    (tester) async {
      final childKey = GlobalKey();

      await tester.pumpWidget(TestWidget(key: childKey));

      expect(
          () => StreamFeedCore.of(childKey.currentState!.context),
          throwsA(predicate<AssertionError>((e) =>
              e.message ==
              'You must have a StreamFeed widget at the top of your widget tree')));
      // expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets('OnAddReaction', (tester) async {
    final mockClient = MockStreamFeedClient();
    final mockReactions = MockReactions();
    final mockStreamAnalytics = MockStreamAnalytics();
    when(() => mockClient.reactions).thenReturn(mockReactions);

    const label = kind;
    final engagement = Engagement(
        content: Content(foreignId: FeedId.fromId(activity.foreignId)),
        label: label,
        feedId: FeedId.fromId(feedGroup));

    when(() => mockReactions.add(
          kind,
          activityId,
        )).thenAnswer((_) async => reaction);

    when(() => mockStreamAnalytics.trackEngagement(engagement))
        .thenAnswer((_) async => Future.value());

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: StreamFeedCore(
          analyticsClient: mockStreamAnalytics,
          client: mockClient,
          child: OnAddReactionWidget(
              activity: activity, feedGroup: feedGroup, kind: kind)),
    )));
    final reactionIcon = find.byType(InkWell);
    expect(reactionIcon, findsOneWidget);
    await tester.tap(reactionIcon);
    verify(() => mockClient.reactions.add(
          kind,
          activityId,
        )).called(1);
    verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
  });
}
