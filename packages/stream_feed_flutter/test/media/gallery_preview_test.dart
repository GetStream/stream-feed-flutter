import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('GalleryPreview tests', () {
    testWidgets('find one FlexibleImage', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: GalleryPreview(
                media: [
                  Media(
                      url:
                          'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw'),
                  /*Media(
                    url:
                        'https://i.picsum.photos/id/11/200/300.jpg?hmac=n9AzdbWCOaV1wXkmrRfw5OulrzXJc0PgSFj4st8d6ys'),*/
                ],
              ),
            ),
          ),
        );

        expect(find.byType(FlexibleImage), findsOneWidget);
      });
    });

    testWidgets('find two FlexibleImages', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: GalleryPreview(
                media: [
                  Media(
                      url:
                          'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw'),
                  Media(
                      url:
                          'https://i.picsum.photos/id/11/200/300.jpg?hmac=n9AzdbWCOaV1wXkmrRfw5OulrzXJc0PgSFj4st8d6ys'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(FlexibleImage), findsNWidgets(2));
      });
    });

    testWidgets('find three FlexibleImages', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: GalleryPreview(
                media: [
                  Media(
                      url:
                          'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw'),
                  Media(
                      url:
                          'https://i.picsum.photos/id/11/200/300.jpg?hmac=n9AzdbWCOaV1wXkmrRfw5OulrzXJc0PgSFj4st8d6ys'),
                  Media(
                      url:
                          'https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8'),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(FlexibleImage), findsNWidgets(3));
      });
    });

    testWidgets('find four FlexibleImages', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: GalleryPreview(
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
                  Media(
                    url:
                        'https://i.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(FlexibleImage), findsNWidgets(4));
      });
    });

    testWidgets('find + 1 text', (widgetTester) async {
      await mockNetworkImages(() async {
        await widgetTester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: GalleryPreview(
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
                  Media(
                    url:
                        'https://i.picsum.photos/id/584/200/300.jpg?hmac=sBfls3kxMp0j0qH3R-K2qM8Wyak1FlpOIgtcd7cEg68',
                  ),
                  Media(
                    url:
                        'https://i.picsum.photos/id/779/200/300.jpg?hmac=DmFN06G0c1N5TAbj2O9YljZ0Vr8VWOZ4lPjLG8oAf8o',
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('+ 1'), findsOneWidget);
      });
    });
  });
}
