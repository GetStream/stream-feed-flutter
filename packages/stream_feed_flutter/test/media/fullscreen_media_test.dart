import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:photo_view/photo_view.dart';
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
              MediaUri(
                uri:
                    Uri.tryParse('https://i.picsum.photos/id/785/200/200.jpg?hmac=vvHnS4TgoGTRqwI2soaIhbOxE7Q-hhoZTTDe75h_fz4')!,
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
              MediaUri(
                uri:
                    Uri.tryParse('https://i.picsum.photos/id/785/200/200.jpg?hmac=vvHnS4TgoGTRqwI2soaIhbOxE7Q-hhoZTTDe75h_fz4')!,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('1 of 1'), findsOneWidget);
    });

    testWidgets('Returns container when passed unknown media', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamFeedTheme(
            data: StreamFeedThemeData.light(),
            child: child!,
          ),
          home: FullscreenMedia(
            media: [
              MediaUri(
                uri: Uri.tryParse('dsfgsdfgsdfg')!,
              ),
            ],
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
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
              MediaUri(
                uri:
                    Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/57e0d6444351a914f1dc8460962e33791c3ad6e04e50744172287ad19245c6_640.jpg')!,
              ),
              MediaUri(
                uri:
                    Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/57e0d6444351a914f1dc8460962e33791c3ad6e04e50744172287ad19245c6_640.jpg')!,
              ),
              MediaUri(
                uri:
                    Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/52e8dd474e56a814f1dc8460962e33791c3ad6e04e507441722978d6904ec2_640.jpg')!,
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

    testWidgets('trigger PhotoView onTapUp', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
            home: FullscreenMedia(
              media: [
                MediaUri(
                  uri:
                      Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/57e0d6444351a914f1dc8460962e33791c3ad6e04e50744172287ad19245c6_640.jpg')!,
                ),
                MediaUri(
                  uri:
                       Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/57e0d6444351a914f1dc8460962e33791c3ad6e04e50744172287ad19245c6_640.jpg')!,
                ),
                MediaUri(
                  uri:
                      Uri.tryParse('https://randomwordgenerator.com/img/picture-generator/52e8dd474e56a814f1dc8460962e33791c3ad6e04e507441722978d6904ec2_640.jpg')!,
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
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamFeedTheme(
            data: StreamFeedThemeData.light(),
            child: child!,
          ),
          home: FullscreenMedia(
            media: [
              MediaUri(
                uri:
                     Uri.tryParse('https://i.picsum.photos/id/485/200/300.jpg?hmac=Kv8DZbgB5jppYcdfZdMVu2LM3XAIt-3fvR8VcmrLYhw')!,
              ),
              MediaUri(
                uri:
                     Uri.tryParse('https://i.picsum.photos/id/11/200/300.jpg?hmac=n9AzdbWCOaV1wXkmrRfw5OulrzXJc0PgSFj4st8d6ys')!,
              ),
              MediaUri(
                uri:
                     Uri.tryParse('https://i.picsum.photos/id/373/200/300.jpg?hmac=GXSHLvl-WsHouC5yVXzXVLNnpn21lCdp5rjUE_wyK-8')!,
              ),
            ],
          ),
        ),
      );

      final backButton = find.byType(StreamSvgIcon);
      expect(backButton, findsOneWidget);

      expect(() => tester.tap(backButton), returnsNormally);
    });

    testWidgets('FullscreenMedia debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const FullscreenMedia(media: []).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        [
          'media: []',
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
