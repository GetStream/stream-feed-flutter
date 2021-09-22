import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/buttons.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/child_reaction.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/pages/reaction_list.dart';
import 'package:stream_feed_flutter/src/widgets/stream_feed_app.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

import 'mock.dart';

// ignore_for_file: cascade_invocations

void main() {
  testWidgets('ReactionListPage', (tester) async {
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
    await tester.pumpWidget(StreamFeedApp(
        bloc: FeedBloc(
          client: mockClient,
          analyticsClient: mockStreamAnalytics,
        ),
        home: Scaffold(
            body: ReactionListPage(
          activity: EnrichedActivity(id: 'id'),
          reactionBuilder: (context, reaction) => const Offstage(),
          lookupValue: lookupValue,
          filter: filter,
          limit: limit,
          kind: kind,
        ))));
    verify(() => mockReactions.filter(lookupAttr, lookupValue,
        filter: filter, limit: limit, kind: kind)).called(1);
  });

  testWidgets('LikeButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return StreamFeedTheme(
            data: StreamFeedThemeData.light(),
            child: child!,
          );
        },
        home: const Scaffold(
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
        ),
      ),
    );

    final icon = find.byType(StreamSvgIcon);
    final activeIcon = tester.widget<StreamSvgIcon>(icon);
    final count = find.text('3');
    expect(count, findsOneWidget);
    expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);
  });

  testWidgets('RepostButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return StreamFeedTheme(
            data: StreamFeedThemeData.light(),
            child: child!,
          );
        },
        home: const Scaffold(
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
        ),
      ),
    );

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
      activity: EnrichedActivity(),
      hoverColor: Colors.lightBlue,
      reaction: reaction,
      kind: kind,
      count: count,
      inactiveIcon: inactiveIcon,
      activeIcon: activeIcon,
    );
    final withOwnReactions = ChildReactionToggleIcon(
      activity: EnrichedActivity(),
      hoverColor: Colors.lightBlue,
      reaction: reaction,
      kind: kind,
      count: count,
      ownReactions: const [reaction],
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

        await tester.pumpWidget(StreamFeedApp(
            bloc: FeedBloc(
              analyticsClient: mockStreamAnalytics,
              client: mockClient,
            ),
            home: Scaffold(
              body: withoutOwnReactions,
            )));
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
          body: FeedBlocProvider(
            bloc: FeedBloc(
              client: mockClient,
              analyticsClient: mockStreamAnalytics,
            ),
            child: withOwnReactions,
          ),
        )));
        final reactionIcon = find.byType(ReactionIcon);
        expect(reactionIcon, findsOneWidget);

        final count = find.text('1300');
        expect(count, findsOneWidget);

        // await tester.tap(reactionIcon);
        // await tester.pumpAndSettle();
        // final newCount = find.text('1299');
        // expect(newCount, findsOneWidget);
        // verify(() => mockClient.reactions.delete(reaction.id!)).called(1);//TODO: fix me
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
      ownReactions: const [reaction],
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
              body: FeedBlocProvider(
                  bloc: FeedBloc(
                    client: mockClient,
                    analyticsClient: mockStreamAnalytics,
                  ),
                  child: withoutOwnReactions)),
        ));
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
            body: FeedBlocProvider(
              bloc: FeedBloc(
                client: mockClient,
                analyticsClient: mockStreamAnalytics,
              ),
              child: withOwnReactions,
            ),
          ),
        ));
        final reactionIcon = find.byType(ReactionToggleIcon);
        expect(reactionIcon, findsOneWidget);

        final count = find.text('1300');
        expect(count, findsOneWidget);

        await tester.tap(reactionIcon);
        await tester.pumpAndSettle();
        // final newCount = find.text('1299');
        // expect(newCount, findsOneWidget); TODO: fix me
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

  group('debugFillProperties tests', () {
    test('ChildReactionButton', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final childReactionButton = ChildReactionButton(
        activity: EnrichedActivity(),
        reaction: Reaction(
          createdAt: now,
          kind: 'comment',
          data: const {
            'text': 'this is a piece of text',
          },
        ),
        kind: 'comment',
        activeIcon: const Icon(Icons.favorite),
        inactiveIcon: const Icon(Icons.favorite_border),
      );

      childReactionButton.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'Reaction(null, comment, null, null, null, ${now.toString()}, null, null, null, null, {text: this is a piece of text}, null, null, null)');
    });

    test('ChildReactionToggleIcon', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final childReactionToggleIcon = ChildReactionToggleIcon(
        count: 1,
        activity: EnrichedActivity(),
        reaction: Reaction(
          createdAt: now,
          kind: 'comment',
          data: const {
            'text': 'this is a piece of text',
          },
        ),
        kind: 'comment',
        activeIcon: const Icon(Icons.favorite),
        inactiveIcon: const Icon(Icons.favorite_border),
      );

      childReactionToggleIcon.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    test('Like button', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final likeButton = LikeButton(
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
      );

      likeButton.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    test('ReactionButton', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final reactionButton = ReactionButton(
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
        kind: 'comment',
        activeIcon: const Icon(Icons.favorite),
        inactiveIcon: const Icon(Icons.favorite_border),
      );

      reactionButton.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    test('ReactionToggleIcon', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final reactionToggleIcon = ReactionToggleIcon(
        count: 1,
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
        kind: 'comment',
        activeIcon: const Icon(Icons.favorite),
        inactiveIcon: const Icon(Icons.favorite_border),
      );

      reactionToggleIcon.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    test('ReactionIcon', () {
      final builder = DiagnosticPropertiesBuilder();
      const reactionIcon = ReactionIcon(
        icon: Icon(Icons.favorite),
      );

      reactionIcon.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    test('ReplyButton', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final replyButton = ReplyButton(
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
      );

      replyButton.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '"handle"');
    });

    test('RepostButton', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final repostButton = RepostButton(
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
      );

      repostButton.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });
  });
}
