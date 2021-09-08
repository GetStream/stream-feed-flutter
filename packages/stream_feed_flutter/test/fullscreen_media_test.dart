import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  testWidgets('fullscreen media', (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: child!,
        ),
        home: FullscreenMedia(
          media: [
            Media(
              url:
                  'https://i.picsum.photos/id/785/200/200.jpg?hmac=vvHnS4TgoGTRqwI2soaIhbOxE7Q-hhoZTTDe75h_fz4',
            ),
          ],
        ),
      ),
    );

    expect(find.byType(GalleryHeader), findsOneWidget);
  });
}
