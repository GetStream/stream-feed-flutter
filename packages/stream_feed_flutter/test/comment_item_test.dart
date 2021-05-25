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
            'text': 'Snowboarding is awesome!', // #snowboarding #winter
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

    richtexts.toList()[2].text.visitChildren((span) {
      children.add(span.toPlainText());
      return true;
    });
    expect(
        children, ['Snowboarding is awesome!', ' #snowboarding', ' #winter']);
  });

  test('TagDetector', () {
    final detector = TagDetector();
    final result = detector
        .parseText('Snowboarding is awesome! #snowboarding #winter @sacha');

    expect(result, [
      {'hashtag': null, 'mention': null, 'normalText': 'Snowboarding'},
      {'hashtag': null, 'mention': null, 'normalText': 'is'},
      {'hashtag': null, 'mention': null, 'normalText': 'awesome'},
      {'hashtag': ' #snowboarding', 'mention': null, 'normalText': null},
      {'hashtag': ' #winter', 'mention': null, 'normalText': null},
      {'hashtag': null, 'mention': ' @sacha', 'normalText': null}
    ]);
  });
}

enum Tag { hashtag, mention, normalText }

extension TagX on Tag {
  String toRegEx() => <Tag, String>{
        Tag.hashtag: r'(?<hashtag>(^|\s)(#[a-z\d-]+))',
        Tag.mention: r'(?<mention>(^|\s)(@[a-z\d-]+))',
        Tag.normalText: r'(?<normalText>([$a-zA-Zａ-ｚＡ-Ｚ]+))'
      }[this]!;
}

class TaggedText {
  final Tag tag;
  final String text;

  TaggedText({required this.tag, required this.text});
}

class TagDetector {
  final RegExp regExp =
      RegExp(Tag.values.map((tag) => tag.toRegEx()).join('|'));
  TagDetector();

  List<Map<String, String?>> parseText(String text) {
    final tags = regExp.allMatches(text).toList();
    final result = tags
        .map((tag) => {
              'hashtag': tag.namedGroup(tag.groupNames.toList()[0]),
              'mention': tag.namedGroup(tag.groupNames.toList()[1]),
              'normalText': tag.namedGroup(tag.groupNames.toList()[2]),
            })
        .toList();
    return result;
  }
}
