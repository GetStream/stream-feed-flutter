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
      var pressedHashtags = <String?>[];
      var pressedMentions = <String?>[];
      final _url = 'http://example.com/';
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ActivityContent(
          og: OpenGraphData(url: _url, images: [OgImage(secureUrl: _url)]),
          activity: EnrichedActivity(
            actor: EnrichableField(
              User(
                data: {
                  'name': 'Nora Ferguson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg',
                },
              ),
            ),
            object: EnrichableField(
                {'text': 'I just missed my train 😤 #angry @sahil'}),
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

      expect(richtexts.toList().map((e) => e.data),
          ['I ', 'just ', 'missed ', 'my ', 'train ', ' #angry', ' @sahil']);

      await tester.tap(find.widgetWithText(InkWell, ' #angry'));
      await tester.tap(find.widgetWithText(InkWell, ' @sahil'));
      expect(pressedHashtags, ['angry']);
      expect(pressedMentions, ['sahil']);
    });
  });
}
