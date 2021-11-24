import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/footer.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter/src/widgets/stream_feed_app.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mock.dart';

void main() {
  late FeedBloc bloc;
  late MockStreamFeedClient mockClient;
  late MockStreamUser mockUser;
  late GenericEnrichedActivity<User, String, String, String> enrichedActivity;

  setUpAll(() {
    mockClient = MockStreamFeedClient();
    mockUser = MockStreamUser();
    const id = '@GroovinChip';
    const handle = '@GroovinChip';
    const fullName = 'Reuben Turner';
    enrichedActivity = GenericEnrichedActivity(
      id: '1',
      time: DateTime.now(),
      actor: const User(
        data: {
          'name': fullName,
          'handle': handle,
          'subtitle': 'likes developing Flutter apps',
          'profile_image':
              'https://avatars.githubusercontent.com/u/4250470?v=4',
        },
      ),
    );
    when(() => mockClient.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn(id);
    when(() => mockUser.data).thenReturn({
      'handle': handle,
      'name': fullName,
    });
    bloc = FeedBloc(client: mockClient);
  });

  testWidgets('ActivityHeader', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeed(
              bloc: bloc,
              themeData: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Scaffold(
            body: ActivityHeader(
              feedGroup: 'timeline',
              activity: enrichedActivity,
            ),
          ),
        ),
      );

      final userBar = find.byType(UserBar);
      expect(userBar, findsOneWidget);
    });
  });

  testWidgets('ActivityContent', (tester) async {
    await mockNetworkImages(() async {
      const title =
          """'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'""";
      const description =
          '''Why choose one when you can wear both? These energizing pairings stand out from the crowd''';

      final pressedHashtags = <String?>[];
      final pressedMentions = <String?>[];
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Scaffold(
            body: ActivityContent(
              activity: GenericEnrichedActivity(
                id: '1',
                extraData: {
                  'attachments': const OpenGraphData(
                      title: title,
                      url:
                          'https://www.rollingstone.com/music/music-news/nicki-minaj-cancels-north-american-tour-with-future-714315/',
                      description: description,
                      images: [
                        OgImage(
                          image:
                              'https://www.rollingstone.com/wp-content/uploads/2018/08/GettyImages-1020376858.jpg',
                        )
                      ]).toJson(),
                },
                actor: const User(
                  data: {
                    'name': 'Nora Ferguson',
                    'profile_image':
                        'https://randomuser.me/api/portraits/women/72.jpg',
                  },
                ),
                object: 'I just missed my train 😤 #angry @sahil',
              ),
              onMentionTap: pressedMentions.add,
              onHashtagTap: pressedHashtags.add,
            ),
          ),
        ),
      );
      final card = find.byType(ActivityCard);

      expect(card, findsOneWidget);
      final richtexts = tester.widgetList<Text>(find.byType(Text));

      expect(richtexts.toList().map((e) => e.data), [
        'I ',
        'just ',
        'missed ',
        'my ',
        'train ',
        ' #angry',
        ' @sahil',
        title,
        description
      ]);

      await tester.tap(find.widgetWithText(InkWell, ' #angry'));
      await tester.tap(find.widgetWithText(InkWell, ' @sahil'));
      expect(pressedHashtags, ['angry']);
      expect(pressedMentions, ['sahil']);
    });
  });

  testWidgets('Activity', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeed(
              bloc: bloc,
              themeData: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Scaffold(
            body: ActivityWidget(activity: enrichedActivity),
          ),
        ),
      );
      expect(find.byType(ActivityHeader), findsOneWidget);
      expect(find.byType(ActivityContent), findsOneWidget);
      expect(find.byType(ActivityFooter), findsOneWidget);
    });
  });

  testGoldens('ActivityFooter', (tester) async {
    await tester.pumpWidgetBuilder(
      StreamFeedTheme(
        data: StreamFeedThemeData.light(),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ActivityFooter(
              activity: GenericEnrichedActivity(
                id: '1',
                reactionCounts: {
                  'like': 139,
                  'repost': 23,
                },
                ownReactions: {
                  'like': [
                    Reaction(
                      kind: 'like',
                    )
                  ]
                },
              ),
            ),
          ),
        ),
      ),
      surfaceSize: const Size(200, 200),
    );
    await screenMatchesGolden(tester, 'activity_footer');
  });

  group('debugFillProperties tests', () {
    test('Default ActivityWidget debugFillProperties', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final activityWidget = ActivityWidget(
        activity: GenericEnrichedActivity(
          id: '1',
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

      // ignore: cascade_invocations
      activityWidget.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'GenericEnrichedActivity<User, String, String, String>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, 1, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
    });

    test('Default ActivityContent debugFillProperties', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final activityContent = ActivityContent(
        activity: GenericEnrichedActivity(
          id: '1',
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

      // ignore: cascade_invocations
      activityContent.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'GenericEnrichedActivity<User, String, String, String>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, 1, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
    });

    test('Default ActivityFooter debugFillProperties', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final activityFooter = ActivityFooter(
        activity: GenericEnrichedActivity(
          id: '1',
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

      // ignore: cascade_invocations
      activityFooter.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'GenericEnrichedActivity<User, String, String, String>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, 1, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
    });

    test('Default ActivityHeader debugFillProperties', () {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      final activityHeader = ActivityHeader(
        feedGroup: 'timeline',
        activity: GenericEnrichedActivity(
          id: '1',
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

      // ignore: cascade_invocations
      activityHeader.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'GenericEnrichedActivity<User, String, String, String>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, 1, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
    });
  });
}
