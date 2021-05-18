import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('Icons', () {
    testGoldens('loveActive', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.loveActive()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'love_active_icon');
    });

    testGoldens('loveInactive', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.loveInactive()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'love_inactive_icon');
    });

    testGoldens('repost', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.repost()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'repost');
    });

    testGoldens('reply', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.reply()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'reply');
    });

    testGoldens('share', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.share()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'share');
    });
  });
}
