import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/like_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  testWidgets('LikeButton', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: LikeButton(
        activity:
            EnrichedActivity(), //TODO: put actual fields in this, notes: look into checks in llc reactions
        // .add and .delete
        reaction: Reaction(kind: 'like', childrenCounts: {
          'like': 3
        }, ownChildren: {
          'like': [
            Reaction(
              kind: 'like',
            )
          ]
        }),
      ),
    )));

    final icon = find.byType(StreamSvgIcon);
    final activeIcon = tester.widget<StreamSvgIcon>(icon);
    final count = find.text('3');
    expect(count, findsOneWidget);
    expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);
  });
}
