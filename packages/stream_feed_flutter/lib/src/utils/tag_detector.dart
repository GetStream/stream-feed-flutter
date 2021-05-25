import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Tag { hashtag, mention, normalText }

const _letters = 'a-zA-Zａ-ｚＡ-Ｚ';
const _symbols = '\.·・ー_,!\(\)';

const _numbers = '0-9０-９';
const _text = _symbols + _numbers + _letters;

extension ListTagX on List<TaggedText> {
  List<TextSpan> spans() =>
      map((e) => TextSpan(text: e.text, style: e.tag.style())).toList();
}

extension TagX on Tag {
  String toRegEx() => <Tag, String>{
        Tag.hashtag: r'(?<hashtag>(^|\s)(#[a-z\d-]+))',
        Tag.mention: r'(?<mention>(^|\s)(@[a-z\d-]+))',
        Tag.normalText: '(?<normalText>([$_text]+))'
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
