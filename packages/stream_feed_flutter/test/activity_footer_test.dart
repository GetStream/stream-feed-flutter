import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

main() {
  testGoldens('repost golden', (tester) async {
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
      surfaceSize: const Size(150, 150),
    );
    await screenMatchesGolden(tester, 'activity_footer');
  });
}
