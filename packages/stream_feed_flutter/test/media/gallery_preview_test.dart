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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
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
            home: const Center(
              child: GalleryPreview(
                attachments: [
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                  Attachment(
                    url:
                        'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                    mediaType: MediaType.image,
                  ),
                ],
              ),
            ),
          ),
        );

        final plusOneButton = find.text('+ 1');
        expect(plusOneButton, findsOneWidget);

        await tester.tap(plusOneButton);
        await tester.pump();
        await tester.pump();

        final backButton = find.byType(StreamSvgIcon);
        expect(backButton, findsOneWidget);

        expect(() => tester.tap(backButton), returnsNormally);
      });
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const GalleryPreview(attachments: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'attachments: []',
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
                          attachments: const [
                            Attachment(
                              url:
                                  'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                              mediaType: MediaType.image,
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
                          attachments: const [
                            Attachment(
                              url:
                                  'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                              mediaType: MediaType.image,
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
      const FlexibleImage(attachments: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'flexFit: tight',
          'index: 0',
          'attachments: []',
        ],
      );
    });
  });
}
