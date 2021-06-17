import 'package:flutter/material.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/activity_content.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/card.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
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
            actor: EnrichableField(
              User(
                data: {
                  'name': 'Nora Ferguson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg',
                },
              ),
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
      final card = find.byType(StreamFeedCard);
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
}
