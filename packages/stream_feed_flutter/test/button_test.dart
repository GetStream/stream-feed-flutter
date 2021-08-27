import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/buttons.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/child_reaction.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

void main() {
  //TODO:fix me
  // testWidgets('ReactionList', (tester) async {
  //   await mockNetworkImages(() async {
  //     var pressedHashtags = <String?>[];
  //     var pressedMentions = <String?>[];
  //     var pressedReactions = <Reaction?>[];
  //     var pressedUsers = <User?>[];
  //     final reactions = [
  //       Reaction(
  //         createdAt: DateTime.now(),
  //         kind: 'comment',
  //         data: {
  //           'text':
  //               'Woohoo Snowboarding is awesome! #snowboarding #winter @sacha',
  //         },
  //       ),
  //       Reaction(
  //         createdAt: DateTime.now(),
  //         kind: 'comment',
  //         data: {
  //           'text': 'Ikr! #vacations #winter @sahil',
  //         },
  //       ),
  //     ];
  //     await tester.pumpWidget(MaterialApp(
  //         home: Scaffold(
  //       body: ReactionListInner(
  //           onUserTap: (user) => pressedUsers.add(user),
  //           onReactionTap: (reaction) => pressedReactions.add(reaction),
  //           onMentionTap: (mention) => pressedMentions.add(mention),
  //           onHashtagTap: (hashtag) => pressedHashtags.add(hashtag),
  //           reactions: reactions),
  //     )));

  //     final avatar = find.byType(Avatar);

  //     expect(avatar, findsNWidgets(2));
  //     final richtexts = tester.widgetList<Text>(find.byType(Text));

  //     expect(richtexts.toList().map((e) => e.data), [
  //       'a moment ago',
  //       'Woohoo ',
  //       'Snowboarding ',
  //       'is ',
  //       'awesome! ',
  //       ' #snowboarding',
  //       ' #winter',
  //       ' @sacha',
  //       'a moment ago',
  //       'Ikr! ',
  //       ' #vacations',
  //       ' #winter',
  //       ' @sahil'
  //     ]);

  //     await tester.tap(find.widgetWithText(InkWell, ' #winter').first);
  //     await tester.tap(find.widgetWithText(InkWell, ' @sacha').first);
  //     await tester.tap(find.widgetWithText(InkWell, ' #vacations').first);
  //     await tester.tap(find.widgetWithText(InkWell, ' @sahil').first);
  //     final firstReaction = find.byType(InkWell).first;
  //     final firstReactionUser = find.byType(Avatar).first;
  //     await tester.tap(firstReaction);
  //     await tester.tap(firstReactionUser);
  //     expect(pressedHashtags, ['winter', 'vacations']);
  //     expect(pressedMentions, ['sacha', 'sahil']);
  //     expect(pressedReactions, [reactions.first]);
  //     expect(pressedUsers, [reactions.first.user]);
  //   });
  // });
  testWidgets('LikeButton', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: LikeButton(
        activity:
            EnrichedActivity(), //TODO: put actual fields in this, notes: look into checks in llc reactions
        // .add and .delete
        reaction: Reaction(kind: 'like', childrenCounts: {
          'like': 3
        }, ownChildren: {
          'like': [
            Reaction(
              kind: 'like',
            )
          ]
        }),
      ),
    )));

    final icon = find.byType(StreamSvgIcon);
    final activeIcon = tester.widget<StreamSvgIcon>(icon);
    final count = find.text('3');
    expect(count, findsOneWidget);
    expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);
  });

  testWidgets('RepostButton', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: RepostButton(
        activity:
            EnrichedActivity(), //TODO: put actual fields in this, notes: look into checks in llc reactions
        // .add and .delete
        reaction: Reaction(kind: 'repost', childrenCounts: {
          'repost': 3
        }, ownChildren: {
          'repost': [
            Reaction(
              kind: 'repost',
            )
          ]
        }),
      ),
    )));

    final icon = find.byType(StreamSvgIcon);
    final activeIcon = tester.widget<StreamSvgIcon>(icon);
    final count = find.text('3');
    expect(count, findsOneWidget);
    expect(activeIcon.color, Colors.blue);
  });

  group('ChildReactionToggleIcon', () {
    const kind = 'like';
    const count = 1300;
    final inactiveIcon = StreamSvgIcon.loveInactive();
    final activeIcon = StreamSvgIcon.loveActive();
    const foreignId = 'like:300';
    const activityId = 'activityId';
    const feedGroup = 'timeline:300';
    const activity = EnrichedActivity(
      id: activityId,
      foreignId: foreignId,
    );
    const reaction = Reaction(id: 'id', kind: kind, parent: activityId);
    const userId = 'user:300';
    final withoutOwnReactions = ChildReactionToggleIcon(
      hoverColor: Colors.lightBlue,
      reaction: reaction,
      kind: kind,
      count: count,
      inactiveIcon: inactiveIcon,
      activeIcon: activeIcon,
    );
    final withOwnReactions = ChildReactionToggleIcon(
      hoverColor: Colors.lightBlue,
      reaction: reaction,
      kind: kind,
      count: count,
      ownReactions: [reaction],
      inactiveIcon: inactiveIcon,
      activeIcon: activeIcon,
    );
    group('widget test', () {
      testWidgets('withoutOwnReactions: onAddChildReaction', (tester) async {
        final mockClient = MockStreamFeedClient();
        final mockReactions = MockReactions();
        final mockStreamAnalytics = MockStreamAnalytics();

        const label = kind;
        // final engagement = Engagement(
        //     content: Content(foreignId: FeedId.fromId(activity.foreignId)),
        //     label: label,
        //     feedId: FeedId.fromId(feedGroup));
        when(() => mockClient.reactions).thenReturn(mockReactions);
        when(() => mockReactions.addChild(
              kind,
              reaction.id!,
            )).thenAnswer((_) async => reaction);

        // when(() => mockStreamAnalytics.trackEngagement(engagement))
        //     .thenAnswer((_) async => Future.value());

        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              return StreamFeedTheme(
                data: StreamFeedThemeData(),
                child: child!,
              );
            },
            home: Scaffold(
              body: StreamFeedCore(
                analyticsClient: mockStreamAnalytics,
                client: mockClient,
                child: withoutOwnReactions,
              ),
            ),
          ),
        );
        final reactionIcon = find.byType(ReactionIcon);
        expect(reactionIcon, findsOneWidget);
        await tester.tap(reactionIcon);
        await tester.pumpAndSettle();
        verify(() => mockClient.reactions.addChild(
              kind,
              reaction.id!,
            )).called(1);
        // verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
      });

      testWidgets('withOwnReactions: onRemoveChildReaction', (tester) async {
        final mockClient = MockStreamFeedClient();
        final mockReactions = MockReactions();
        final mockStreamAnalytics = MockStreamAnalytics();
        when(() => mockClient.reactions).thenReturn(mockReactions);

        const label = kind;
        // final engagement = Engagement(
        //     content: Content(foreignId: FeedId.fromId(activity.foreignId)),
        //     label: 'un$label',
        //     feedId: FeedId.fromId(feedGroup));

        when(() => mockReactions.delete(reaction.id!))
            .thenAnswer((_) async => reaction);

        // when(() => mockStreamAnalytics.trackEngagement(engagement))
        //     .thenAnswer((_) async => Future.value());

        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
          body: StreamFeedCore(
              analyticsClient: mockStreamAnalytics,
              client: mockClient,
              child: withOwnReactions),
        )));
        final reactionIcon = find.byType(ReactionIcon);
        expect(reactionIcon, findsOneWidget);

        final count = find.text('1300');
        expect(count, findsOneWidget);

        await tester.tap(reactionIcon);
        await tester.pumpAndSettle();
        final newCount = find.text('1299');
        expect(newCount, findsOneWidget);
        verify(() => mockClient.reactions.delete(reaction.id!)).called(1);
        // verify(() => mockStreamAnalytics.trackEngagement(engagement)).called(1);
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

  group('ReactionToggleIcon', () {
    const kind = 'like';
    const count = 1300;
    final inactiveIcon = StreamSvgIcon.loveInactive();
    final activeIcon = StreamSvgIcon.loveActive();
    const foreignId = 'like:300';
    const activityId = 'activityId';
    const feedGroup = 'timeline:300';
    const activity = EnrichedActivity(
      id: activityId,
      foreignId: foreignId,
    );
    const reaction = Reaction(id: 'id', kind: kind, activityId: activityId);
    const userId = 'user:300';
    final withoutOwnReactions = ReactionToggleIcon(
      activity: activity,
      kind: kind,
      count: count,
      feedGroup: feedGroup,
      inactiveIcon: inactiveIcon,
      activeIcon: activeIcon,
      hoverColor: Colors.lightBlue,
    );
    final withOwnReactions = ReactionToggleIcon(
      activity: activity,
      kind: kind,
      count: count,
      feedGroup: feedGroup,
      ownReactions: [reaction],
      inactiveIcon: inactiveIcon,
      activeIcon: activeIcon,
      hoverColor: Colors.lightBlue,
    );
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
        final reactionIcon = find.byType(ReactionIcon);
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

        final count = find.text('1300');
        expect(count, findsOneWidget);

        await tester.tap(reactionIcon);
        await tester.pumpAndSettle();
        final newCount = find.text('1299');
        expect(newCount, findsOneWidget);
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

  group('ReactionIcon', () {
    testWidgets('onTap', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData(),
              child: child!,
            );
          },
          home: Scaffold(
            body: ReactionIcon(
              icon: StreamSvgIcon.repost(),
              count: 23,
              onTap: () => tapped++,
            ),
          ),
        ),
      );

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      final count = find.text('23');
      expect(count, findsOneWidget);
      expect(activeIcon.assetName, StreamSvgIcon.repost().assetName);

      await tester.tap(find.byType(InkWell));
      expect(tapped, 1);
    });

    testGoldens('repost golden', (tester) async {
      await tester.pumpWidgetBuilder(
        StreamFeedTheme(
          data: StreamFeedThemeData(),
          child: Center(
            child: ReactionIcon(
              icon: StreamSvgIcon.repost(),
              count: 23,
            ),
          ),
        ),
        surfaceSize: const Size(100, 75),
      );
      await screenMatchesGolden(tester, 'repost');
    });
  });
}
