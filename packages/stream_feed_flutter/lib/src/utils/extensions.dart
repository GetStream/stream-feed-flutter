import 'package:flutter/material.dart';

import 'tag_detector.dart';
part 'constants.dart';

extension ListTaggedTextX on List<TaggedText> {
  List<TextSpan> spans() =>
      map((e) => TextSpan(text: e.text, style: e.tag.style())).toList();
}

extension TagX on Tag {
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

  TextStyle? style() => <Tag, TextStyle>{
        Tag.hashtag: TextStyle(
            inherit: true,
            color: Color(0xff7a8287),
            fontSize: 14,
            fontWeight: FontWeight.w600),
        Tag.mention: TextStyle(
            inherit: true,
            color: Color(0xff095482),
            fontSize: 14,
            fontWeight: FontWeight.w600),
        Tag.normalText: TextStyle(
            inherit: true,
            color: Color(0xff095482),
            fontSize: 14,
            fontWeight: FontWeight.w600),
      }[this];
}
