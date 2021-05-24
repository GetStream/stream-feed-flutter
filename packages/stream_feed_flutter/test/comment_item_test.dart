import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/comment_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

main() {
  testWidgets('CommentItem', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: CommentItem(),
    )));

    final avatar = find.byType(Avatar);

    final username = find.text('Rosemary');
    expect(avatar, findsOneWidget);
    expect(username, findsOneWidget);
  });
}
