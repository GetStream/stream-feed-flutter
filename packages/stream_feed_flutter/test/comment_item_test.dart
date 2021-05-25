import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/comment_item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';

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
      TaggedText(tag: Tag.normalText, text: 'Snowboarding'),
      TaggedText(tag: Tag.normalText, text: 'is'),
      TaggedText(tag: Tag.normalText, text: 'awesome'),
      TaggedText(tag: Tag.hashtag, text: ' #snowboarding'),
      TaggedText(tag: Tag.hashtag, text: ' #winter'),
      TaggedText(tag: Tag.mention, text: ' @sacha')
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

class TaggedText extends Equatable {
  final Tag tag;
  final String? text;

  TaggedText({required this.tag, required this.text});

  factory TaggedText.fromMap(Map<Tag, String?> map) {
    final entry = map.entries.first;
    return TaggedText(tag: entry.key, text: entry.value);
  }

  @override
  List<Object?> get props => [tag, text];
}

class TagDetector {
  final RegExp regExp =
      RegExp(Tag.values.map((tag) => tag.toRegEx()).join('|'));
  TagDetector();

  List<TaggedText> parseText(String text) {
    final tags = regExp.allMatches(text).toList();
    final result = tags
        .map((tag) => TaggedText.fromMap({
              Tag.hashtag: tag.namedGroup(tag.groupNames.toList()[0]),
              Tag.mention: tag.namedGroup(tag.groupNames.toList()[1]),
              Tag.normalText: tag.namedGroup(tag.groupNames.toList()[2]),
            }..removeWhere((key, value) => value == null)))
        .toList();
    return result;
  }
}
