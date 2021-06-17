import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/card.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  final logs = <String>[];
  const channel = MethodChannel('plugins.flutter.io/url_launcher');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'canLaunch') {
        logs.add('canLaunch');
        return true;
      }

      if (methodCall.method == 'launch') {
        logs.add('launch');
        return true;
      }
    });
  });
  testWidgets('Card', (tester) async {
    await mockNetworkImages(() async {
      final _url = 'http://example.com/';
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: StreamFeedCard(
          og: OpenGraphData(
              title:
                  "'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'",
              url:
                  'https://www.rollingstone.com/music/music-news/nicki-minaj-cancels-north-american-tour-with-future-714315/',
              description:
                  'Why choose one when you can wear both? These energizing pairings stand out from the crowd',
              images: [
                OgImage(
                  image:
                      'https://www.rollingstone.com/wp-content/uploads/2018/08/GettyImages-1020376858.jpg',
                )
              ]),
        ),
      )));

      final inkwell = find.byType(InkWell);
      expect(inkwell, findsOneWidget);

      final card = find.byType(Card);
      expect(card, findsOneWidget);

      final image = find.byType(Image);
      expect(image, findsOneWidget);

      await tester.tap(inkwell);
      expect(logs, [
        'canLaunch',
        'launch'
      ]); //TODO: hmm there might be a better way to do this
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
