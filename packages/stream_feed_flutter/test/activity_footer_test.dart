import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/widgets/activity/footer.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

main() {
  testGoldens('activity footer', (tester) async {
    await tester.pumpWidgetBuilder(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActivityFooter(
            activity: EnrichedActivity(reactionCounts: {
              'like': 139,
              'repost': 23,
            }, ownReactions: {
              'like': [
                Reaction(
                  kind: 'like',
                )
              ]
            }),
          ),
        ),
      ),
      surfaceSize: const Size(200, 200),
    );
    await screenMatchesGolden(tester, 'activity_footer');
  });
}
