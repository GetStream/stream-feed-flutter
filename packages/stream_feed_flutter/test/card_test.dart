import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

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
      const title =
          """'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'""";
      const description =
          '''Why choose one when you can wear both? These energizing pairings stand out from the crowd''';

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: const Scaffold(
            body: ActivityCard(
              og: OpenGraphData(
                title: title,
                url:
                    'https://www.rollingstone.com/music/music-news/nicki-minaj-cancels-north-american-tour-with-future-714315/',
                description: description,
                images: [
                  OgImage(
                    image:
                        'https://www.rollingstone.com/wp-content/uploads/2018/08/GettyImages-1020376858.jpg',
                  )
                ],
              ),
            ),
          ),
        ),
      );

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

      final richtexts = tester.widgetList<Text>(find.byType(Text));
      expect(richtexts.toList().map((e) => e.data), [title, description]);
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
