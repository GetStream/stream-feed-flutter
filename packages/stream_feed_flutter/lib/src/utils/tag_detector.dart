import 'package:equatable/equatable.dart';
import 'package:stream_feed/stream_feed.dart' show MapX;
import 'package:stream_feed_flutter/src/utils/extensions.dart';

enum Tag {
  hashtag,

  mention,

  normalText,
} //TODO: url

class TaggedText extends Equatable {
  /// Builds a [TaggedText].
  const TaggedText({
    required this.tag,
    required this.text,
  });

  factory TaggedText.fromMapEntry(MapEntry<Tag, String> entry) =>
      TaggedText(tag: entry.key, text: entry.value);

  final Tag tag;

  final String text;

  @override
  List<Object?> get props => [tag, text];
}

class TagDetector {
  /// Builds a [TagDetector].
  TagDetector();

  final RegExp regExp = RegExp(buildRegex());

  static String buildRegex() =>
      Tag.values.map((tag) => tag.toRegEx()).join('|');

  List<TaggedText> parseText(String text) {
    final tags = regExp.allMatches(text).toList();
    final result = tags.map((tag) {
      final entry = {
        Tag.hashtag: tag.namedGroup(Tag.hashtag.str()),
        Tag.mention: tag.namedGroup(Tag.mention.str()),
        Tag.normalText: tag.namedGroup(Tag.normalText.str()),
      }.nullProtected.entries.first;
      return TaggedText.fromMapEntry(entry);
    }).toList(growable: false);

    return result;
  }
}
