import 'package:equatable/equatable.dart';
import 'extensions.dart';

enum Tag { hashtag, mention, normalText }

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
  TagDetector();

  final RegExp regExp = RegExp(buildRegex());

  static String buildRegex() =>
      Tag.values.map((tag) => tag.toRegEx()).join('|');

  List<TaggedText?> parseText(String text) {
    final tags = regExp.allMatches(text).toList();
    final result = tags
        .map((tag) => TaggedText.fromMap({
              Tag.hashtag: tag.namedGroup(Tag.hashtag.str()),
              Tag.mention: tag.namedGroup(Tag.mention.str()),
              Tag.normalText: tag.namedGroup(Tag.normalText.str()),
            }..removeWhere((key, value) => value == null)))
        .toList();
    return result;
  }
}
