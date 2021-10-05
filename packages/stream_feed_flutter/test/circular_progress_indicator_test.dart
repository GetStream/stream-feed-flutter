import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/circular_progress_indicator.dart';

void main() {
  group('CircularProgressIndicator tests', () {
    testWidgets('When no loading progress is given, show the child',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: StreamCircularProgressIndicator(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('Show CircularProgressIndicator on image load', (tester) async {
      const imageChunkEvent = ImageChunkEvent(
        cumulativeBytesLoaded: 50,
        expectedTotalBytes: 100,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(
            child: StreamCircularProgressIndicator(
              loadingProgress: imageChunkEvent,
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const StreamCircularProgressIndicator(
        child: SizedBox.shrink(),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });
  });
}
