import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/text.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
// import 'package:test/test.dart';

void main() {
  group('Button', () {
    testGoldens('button', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 0.5)
        ..addScenario(
            'Button primary',
            StyledTextButton(
              label: 'Follow',
              onPressed: () {},
              type: ButtonType.primary,
            ))
        ..addScenario(
            'Button faded',
            StyledTextButton(
              label: 'Following',
              onPressed: () {},
              type: ButtonType.faded,
            ));

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(200, 150),
      );
      await screenMatchesGolden(tester, 'buttons_grid');
    });
  });
}
