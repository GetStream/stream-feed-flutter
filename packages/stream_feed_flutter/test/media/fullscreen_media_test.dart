import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('fullscreen media', () {
    testWidgets('find one GalleryHeader', (tester) async {
      await tester.pumpWidget(
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

    testWidgets('find GalleryHeader text', (tester) async {
      await tester.pumpWidget(
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

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('1 of 1'), findsOneWidget);
    });

    testWidgets('test dragging through image pages', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamFeedTheme(
            data: StreamFeedThemeData.light(),
            child: child!,
          ),
          home: FullscreenMedia(
            media: [
              Media(
                url:
                    'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/11/200/300.jpg?hmac=n9AzdbWCOaV1wXkmrRfw5OulrzXJc0PgSFj4st8d6ys',
              ),
              Media(
                url:
                    'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8',
              ),
            ],
          ),
        ),
      );

      expect(find.text('1 of 3'), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-401, 0));
      await tester.pumpAndSettle();
      expect(find.text('2 of 3'), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-401, 0));
      await tester.pumpAndSettle();
      expect(find.text('3 of 3'), findsOneWidget);
    });
  });
}
