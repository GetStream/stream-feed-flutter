import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';

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
      await screenMatchesGolden(tester, 'repost_icon');
    });

    testGoldens('reply', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.reply()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'reply_icon');
    });

    testGoldens('share', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.share()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'share_icon');
    });

    testGoldens('post', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.post()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'post_icon');
    });

    testGoldens('categories', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.categories()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'categories_icon');
    });

    testGoldens('gear', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.gear()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'gear_icon');
    });

    testGoldens('avatar', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.avatar()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'avatar_icon');
    });

    testGoldens('close', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Container(color: Colors.black, child: StreamSvgIcon.close()),
        ),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'close');
    });
  });
}
