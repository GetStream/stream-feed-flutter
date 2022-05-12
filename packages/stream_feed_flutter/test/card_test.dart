import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
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

      final galleryPreview = find.byType(GalleryPreview);
      expect(galleryPreview, findsOneWidget);
    });
  });

  test('Default ActivityCard debugFillProperties', () {
    final builder = DiagnosticPropertiesBuilder();
    const activityCard = ActivityCard();

    activityCard.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], 'null');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
