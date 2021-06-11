import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/card.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

main() {
  testWidgets('Card', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: StreamFeedCard(
          og: OpenGraphData(
              url: 'dummyurl', images: [OgImage(secureUrl: 'dummyurl')]),
        ),
      )));

      final inkwell = find.byType(InkWell);
      expect(inkwell, findsOneWidget);

      final card = find.byType(Card);
      expect(card, findsOneWidget);

      final image = find.byType(Image);
      expect(image, findsOneWidget);
    });
  });
}
