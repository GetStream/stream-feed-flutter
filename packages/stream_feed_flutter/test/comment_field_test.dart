import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/comment_field.dart';
import 'package:stream_feed_flutter/src/textarea.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

main() {
  testWidgets('CommentField', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: CommentField(),
    )));
    final avatar = find.byType(Avatar);
    final textArea = find.byType(TextArea);
    final button = find.byType(Button);
    expect(avatar, findsOneWidget);
    expect(textArea, findsOneWidget);
    expect(button, findsOneWidget);
  });
}
