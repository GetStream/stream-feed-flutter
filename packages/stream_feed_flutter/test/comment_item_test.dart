import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/comment_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets('CommentItem', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: CommentItem(
        user: User(data: {
          'name': 'Rosemary',
          'subtitle': 'likes playing fresbee in the park',
          'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
        }),
        reaction: Reaction(
          createdAt: DateTime.now(),
          kind: 'comment',
          data: {
            'text': 'Snowboarding is awesome!',
          },
        ),
      ),
    )));

    final avatar = find.byType(Avatar);

    final username = find.text('Rosemary');
    final momentAgo = find.text('a moment ago');
    expect(momentAgo, findsOneWidget);
    expect(avatar, findsOneWidget);
    expect(username, findsOneWidget);
    final richtexts = tester.widgetList<RichText>(find.byType(RichText));
    var children = <String>[];
    var childrenStyles = <TextStyle?>[];

    richtexts.toList()[2].text.visitChildren((span) {
      children.add(span.toPlainText());
      childrenStyles.add(span.style);
      return true;
    });
    expect(
        children, ['Snowboarding is awesome!', ' #snowboarding', ' #winter']);

    expect(childrenStyles, [
      TextStyle(
          inherit: true,
          color: Color(0xff7a8287),
          fontSize: 14,
          fontWeight: FontWeight.w600),
      TextStyle(
          inherit: true,
          color: Color(0xff095482),
          fontSize: 14,
          fontWeight: FontWeight.w600),
      TextStyle(
          inherit: true,
          color: Color(0xff095482),
          fontSize: 14,
          fontWeight: FontWeight.w600)
    ]);
  });
}
