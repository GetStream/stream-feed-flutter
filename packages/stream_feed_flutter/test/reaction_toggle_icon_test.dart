import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;
// import 'package:test/test.dart';

void main() {
  group('ReactionToggleIcon', () {
    testGoldens('reaction toggle icon', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 0.5)
        ..addScenario(
            'without own reactions',
            ReactionToggleIcon(
              activity: EnrichedActivity(),//TODO: put actual fields in this, notes: look into checks in llc reactions
        // .add and .delete
                kind: 'like',
                count: 1300,
                inactiveIcon: StreamSvgIcon.loveInactive(),
                activeIcon: StreamSvgIcon.loveInactive()))
        ..addScenario(
            'with own reactions',
            ReactionToggleIcon(
              activity: EnrichedActivity(),//TODO: put actual fields in this, notes: look into checks in llc reactions
        // .add and .delete
                kind: 'like',
                count: 1300,
                ownReactions: [Reaction(kind: 'like')],
                inactiveIcon: StreamSvgIcon.loveInactive(),
                activeIcon: StreamSvgIcon.loveActive()));
      await tester.pumpWidgetBuilder(builder.build());
      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(250, 100),
      );
      await screenMatchesGolden(tester, 'reaction_toggle_icon_grid');
    });
  });
}
