import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

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

    testWidgets('onTap', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ReactionIcon(
          icon: StreamSvgIcon.repost(),
          count: 23,
          onTap: () => tapped++,
        ),
      )));

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      final count = find.text('23');
      expect(count, findsOneWidget);
      expect(activeIcon.assetName, StreamSvgIcon.repost().assetName);

      await tester.tap(find.byType(InkWell));
      expect(tapped, 1);
    });
  });
}
