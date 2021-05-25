
import 'package:equatable/equatable.dart';

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