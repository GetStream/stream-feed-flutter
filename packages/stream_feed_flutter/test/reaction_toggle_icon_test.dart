import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction_button.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

void main() {
  group('ReactionToggleIcon', () {
    const kind = 'like';
    const count = 1300;
    final inactiveIcon = StreamSvgIcon.loveInactive();
    final activeIcon = StreamSvgIcon.loveActive();
    const foreignId = 'like:300';
    const activityId = 'activityId';
    const feedGroup = 'timeline:300';
    final activity = EnrichedActivity(id: activityId, foreignId: foreignId);
    const reaction = Reaction(id: 'id', kind: kind, activityId: activityId);
    const userId = 'user:300';
    final withoutOwnReactions = ReactionToggleIcon(
        activity: activity,
        kind: kind,
        count: count,
        feedGroup: feedGroup,
        inactiveIcon: inactiveIcon,
        activeIcon: activeIcon);
    final withOwnReactions = ReactionToggleIcon(
        activity: activity,
        kind: kind,
        count: count,
        feedGroup: feedGroup,
        ownReactions: [reaction],
        inactiveIcon: inactiveIcon,
        activeIcon: activeIcon);
    group('widget test', () {
      testWidgets('withoutOwnReactions: onAddReaction', (tester) async {
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
              child: withoutOwnReactions),
        )));
        final reactionIcon = find.byType(ReactionToggleIcon);
        expect(reactionIcon, findsOneWidget);
        await tester.tap(reactionIcon);
        verify(() => mockClient.reactions.add(
              kind,
              activityId,
            )).called(1);
        verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
      });

      testWidgets('withOwnReactions: onRemoveReaction', (tester) async {
        final mockClient = MockStreamFeedClient();
        final mockReactions = MockReactions();
        final mockStreamAnalytics = MockStreamAnalytics();
        when(() => mockClient.reactions).thenReturn(mockReactions);

        const label = kind;
        final engagement = Engagement(
            content: Content(foreignId: FeedId.fromId(activity.foreignId)),
            label: 'un$label',
            feedId: FeedId.fromId(feedGroup));

        when(() => mockReactions.delete(reaction.id!))
            .thenAnswer((_) async => reaction);

        when(() => mockStreamAnalytics.trackEngagement(engagement))
            .thenAnswer((_) async => Future.value());

        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
          body: StreamFeedCore(
              analyticsClient: mockStreamAnalytics,
              client: mockClient,
              child: withOwnReactions),
        )));
        final reactionIcon = find.byType(ReactionToggleIcon);
        expect(reactionIcon, findsOneWidget);
        await tester.tap(reactionIcon);
        verify(() => mockClient.reactions.delete(reaction.id!)).called(1);
        verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
      });
    });

    testGoldens('golden', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 0.5)
        ..addScenario('without own reactions', withoutOwnReactions)
        ..addScenario('with own reactions', withOwnReactions);

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(250, 100),
      );
      await screenMatchesGolden(tester, 'reaction_toggle_icon_grid');
    });
  });
}
