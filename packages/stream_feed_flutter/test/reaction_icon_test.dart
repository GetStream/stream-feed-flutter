import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
// import 'package:test/test.dart';

void main() {
  group('ReactionIcon', () {
    testGoldens('repost golden', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: ReactionIcon(
            icon: StreamSvgIcon.repost(),
            count: 23,
          ),
        ),
        surfaceSize: const Size(100, 75),
      );
      await screenMatchesGolden(tester, 'repost');
    });

    testWidgets("repost on tap", (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ReactionIcon(
          icon: StreamSvgIcon.repost(),
          count: 23,
        ),
      )));

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      final count = find.text('23');
      expect(count, findsOneWidget);
      expect(activeIcon.assetName, StreamSvgIcon.repost().assetName);
    });
  });
}
