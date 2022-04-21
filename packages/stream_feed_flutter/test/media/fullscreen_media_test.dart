import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('fullscreen media', () {
    testWidgets('find one GalleryHeader', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
              attachments: [
                Attachment(
                  url:
                      'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                  mediaType: MediaType.image,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(GalleryHeader), findsOneWidget);
      });
    });

    testWidgets('find GalleryHeader text', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
              attachments: [
                Attachment(
                  url:
                      'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                  mediaType: MediaType.image,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(Text), findsOneWidget);
        expect(find.text('1 of 1'), findsOneWidget);
      });
    });

    testWidgets('Returns container when passed unknown media', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
              attachments: [
                Attachment(
                  url:
                      'https://pixabay.com/get/ge9a737694489e25ce288c750e5ea25c822297913a45e0a69a5fe1bea9ebe7cb003aa6d4dac6c16b07306fc66af16ad00_1280.jpg',
                  mediaType: MediaType.image,
                ),
              ],
            ),
          ),
        );

        expect(find.byType(Container), findsOneWidget);
      });
    });

    testWidgets('test dragging through image pages', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
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
        );

        expect(find.text('1 of 3'), findsOneWidget);
        await tester.drag(find.byType(PageView), const Offset(-500, 0));
        await tester.pump();
        expect(find.text('2 of 3'), findsOneWidget);
        await tester.drag(find.byType(PageView), const Offset(-1000, 0));
        await tester.pump();
        expect(find.text('3 of 3'), findsOneWidget);
      });
    });

    testWidgets('trigger PhotoView onTapUp', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
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
        );
        final photoView = tester.widget<PhotoView>(
          find.byType(PhotoView),
        );
        photoView.onTapUp?.call(
          FakeBuildContext(),
          FakeTapUpDetails(),
          FakePhotoViewControllerValue(),
        );

        await tester.pump();

        final fullScreenMediaState =
            tester.state<FullscreenMediaState>(find.byType(FullscreenMedia));

        expect(fullScreenMediaState.optionsShown, false);

        photoView.onTapUp?.call(
          FakeBuildContext(),
          FakeTapUpDetails(),
          FakePhotoViewControllerValue(),
        );

        await tester.pump(const Duration(milliseconds: 500));

        final fullScreenMediaState2 =
            tester.state<FullscreenMediaState>(find.byType(FullscreenMedia));

        expect(fullScreenMediaState2.optionsShown, true);
      });
    });

    testWidgets('Tap back button', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: const FullscreenMedia(
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
        );

        final backButton = find.byType(StreamSvgIcon);
        expect(backButton, findsOneWidget);

        expect(() => tester.tap(backButton), returnsNormally);
      });
    });

    testWidgets('FullscreenMedia debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const FullscreenMedia(attachments: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'attachments: []',
          'startIndex: 0',
        ],
      );
    });
  });
}

class FakeBuildContext extends Fake implements BuildContext {}

class FakeTapUpDetails extends Fake implements TapUpDetails {}

class FakePhotoViewControllerValue extends Fake
    implements PhotoViewControllerValue {}
