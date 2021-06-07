import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
// import 'package:test/test.dart';

void main() {
  group('ReactionIcon', () {
    testGoldens('repost', (tester) async {
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
  });
}
