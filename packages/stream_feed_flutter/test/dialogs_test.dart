import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';

main() {
  group('Actions', () {
    testWidgets('Right', (tester) async {
      await tester.pumpWidget(Material(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: RightActions(
          feedGroup: 'user',
          textEditingController: TextEditingController(),
        ),
      )));

      final postCommentButton = find.byType(PostCommentButton);
      expect(postCommentButton, findsOneWidget);
    });
  });
}
