import 'package:flutter/material.dart';

import 'tag_detector.dart';

part 'constants.dart';

extension ListTaggedTextX on List<TaggedText> {
  List<TextSpan> spans() =>
      map((e) => TextSpan(text: e.text, style: e.tag.style())).toList();
}

extension TagX on Tag {
  // TODO: Improve all regex
  // eg -> @#sahil (Detects as normal text)
  //       %sahil (does not includes "%" in the normal text)
  String toRegEx() => <Tag, String>{
        Tag.hashtag: r'(?<hashtag>(^|\s)(#[a-z\d-]+))', //TODO: handle uppercase
        Tag.mention: r'(?<mention>(^|\s)(@[a-z\d-]+))',
        Tag.normalText: '(?<normalText>([$_text]+))'
      }[this]!;

  String str() => <Tag, String>{
        Tag.hashtag: 'hashtag',
        Tag.mention: 'mention',
        Tag.normalText: 'normalText',
      }[this]!;

  TextStyle style() => <Tag, TextStyle>{
        Tag.hashtag: TextStyle(
          inherit: true,
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        Tag.mention: TextStyle(
          inherit: true,
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        Tag.normalText: TextStyle(
          inherit: true,
          color: Colors.black,
          fontSize: 14,
        ),
      }[this]!;
}
