import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('GalleryPreview tests', () {
    testWidgets('find one FlexibleImage', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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
                ],
              ),
            ),
          ),
        );

        expect(find.byType(FlexibleImage), findsOneWidget);
      });
    });

    testWidgets('find two FlexibleImages', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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

    testWidgets('find three FlexibleImages', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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

    testWidgets('find four FlexibleImages', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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

    testWidgets('find + 1 text', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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

    testWidgets('Open and dismiss image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
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

        final plusOneButton = find.text('+ 1');
        expect(plusOneButton, findsOneWidget);

        await tester.tap(plusOneButton);
        await tester.pumpAndSettle();

        final backButton = find.byType(StreamSvgIcon);
        expect(backButton, findsOneWidget);

        expect(() => tester.tap(backButton), returnsNormally);
      });
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const GalleryPreview(media: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'media: []',
        ],
      );
    });
  });

  group('FlexibleImage tests', () {
    testWidgets('find one GestureDetector and one Image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Flex(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      direction: Axis.horizontal,
                      children: [
                        FlexibleImage(
                          media: [
                            Media(
                              url:
                                  'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw',
                            ),
                          ],
                          child: Image.network(
                            'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(GestureDetector), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('tap on image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: Center(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Flex(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      direction: Axis.horizontal,
                      children: [
                        FlexibleImage(
                          media: [
                            Media(
                              url:
                                  'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw',
                            ),
                          ],
                          child: Image.network(
                            'https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final gestureDetector = find.byType(GestureDetector);
        expect(gestureDetector, findsOneWidget);

        await tester.tap(gestureDetector);
        await tester.pump();
        await tester.pump();

        final backButton = find.byType(StreamSvgIcon);
        expect(backButton, findsOneWidget);

        expect(() => tester.tap(backButton), returnsNormally);
      });
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const FlexibleImage(media: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'flexFit: tight',
          'index: 0',
          'media: []',
        ],
      );
    });
  });
}
