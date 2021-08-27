import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';

part 'constants.dart';

/// TODO: document me
extension ListTaggedTextX on List<TaggedText> {
  /// TODO: document me
  List<TextSpan> spans() =>
      map((e) => TextSpan(text: e.text, style: e.tag.style())).toList();
}

/// TODO: document me
extension TagX on Tag {
  // TODO: Improve all regex
  // eg -> @#sahil (Detects as normal text)
  //       %sahil (does not includes "%" in the normal text)
  /// TODO: document me
  String toRegEx() => <Tag, String>{
        Tag.hashtag: r'(?<hashtag>(^|\s)(#[a-z\d-]+))', //TODO: handle uppercase
        Tag.mention: r'(?<mention>(^|\s)(@[a-z\d-]+))',
        Tag.normalText: '(?<normalText>([$_text]+))'
      }[this]!;

  /// TODO: document me
  String str() => <Tag, String>{
        Tag.hashtag: 'hashtag',
        Tag.mention: 'mention',
        Tag.normalText: 'normalText',
      }[this]!;

  /// TODO: document me
  TextStyle style() => <Tag, TextStyle>{
        Tag.hashtag: const TextStyle(
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        Tag.mention: const TextStyle(
          color: Color(0xff0076ff),
          fontSize: 14,
        ),
        Tag.normalText: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      }[this]!;
}
