import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('Icons', () {
    testGoldens('StreamSvgIcon loveActive', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: StreamSvgIcon.loveActive()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'love_active_icon');
    });
  });
}
