import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/comment_field.dart';

main() {
  testGoldens('CommentField', (tester) async {
    await tester.pumpWidgetBuilder(
      Container(width: 220, child: CommentField()),
      // surfaceSize: const Size(200, 200),
    );
    await screenMatchesGolden(tester, 'comment_field');
  });
}
