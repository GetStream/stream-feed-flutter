import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
// import 'package:test/test.dart';

void main() {
  group('Button', () {
    testGoldens('button', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Button(
            label: 'Follow',
            onPressed: () {},
          ),
        ),
        surfaceSize: const Size(100, 75),
      );
      await screenMatchesGolden(tester, 'button');
    });
  });
}
