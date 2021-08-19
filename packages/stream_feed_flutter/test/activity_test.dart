import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/footer.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
  testWidgets('ActivityHeader', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActivityHeader(
              activityKind: 'like',
              activity: EnrichedActivity(
                time: DateTime.now(),
                actor: const User(
                  data: {
                    'name': 'Rosemary',
                    'handle': '@rosemary',
                    'subtitle': 'likes playing frisbee in the park',
                    'profile_image':
                        'https://randomuser.me/api/portraits/women/20.jpg',
                  },
                ),
              ),
            ),
          ),
        ),
      );

      final avatar = find.byType(Avatar);
      expect(avatar, findsOneWidget);

      final username = find.text('Rosemary').first;
      expect(username, findsOneWidget);

      final timeago = find.text('a moment ago').first;
      expect(timeago, findsOneWidget);

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);

      final by = find.text('by').first;
      expect(by, findsOneWidget);
      final handle = find.text('@rosemary').first;
      expect(handle, findsOneWidget);
    });
  });

  testWidgets('ActivityContent', (tester) async {
    await mockNetworkImages(() async {
      final title =
          "'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'";
      final description =
          'Why choose one when you can wear both? These energizing pairings stand out from the crowd';

      var pressedHashtags = <String?>[];
      var pressedMentions = <String?>[];
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ActivityContent(
          activity: EnrichedActivity(
            extraData: {
              'attachments': OpenGraphData(
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
            actor: User(
              data: {
                'name': 'Nora Ferguson',
                'profile_image':
                'https://randomuser.me/api/portraits/women/72.jpg',
              },
            ),
            object: EnrichableField('I just missed my train 😤 #angry @sahil'),
          ),
          onMentionTap: (String? mention) {
            pressedMentions.add(mention);
          },
          onHashtagTap: (String? hashtag) {
            pressedHashtags.add(hashtag);
          },
        ),
      )));
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
          home: Scaffold(
            body: ActivityWidget(
              activity: EnrichedActivity(
                  time: DateTime.now(),
                  actor: User(data: {
                    'name': 'Rosemary',
                    'handle': '@rosemary',
                    'subtitle': 'likes playing fresbee in the park',
                    'profile_image':
                        'https://randomuser.me/api/portraits/women/20.jpg',
                  }),
                  extraData: {
                    'image':
                        'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
                  }),
            ),
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
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityFooter(
            activity: EnrichedActivity(reactionCounts: {
              'like': 139,
              'repost': 23,
            }, ownReactions: {
              'like': [
                Reaction(
                  kind: 'like',
                )
              ]
            }),
          ),
        ),
      ),
      surfaceSize: const Size(200, 200),
    );
    await screenMatchesGolden(tester, 'activity_footer');
  });
}
