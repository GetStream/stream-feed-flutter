import 'package:equatable/equatable.dart';
import 'package:stream_feed/stream_feed.dart' show MapX;
import 'package:stream_feed_flutter/src/utils/extensions.dart';

/// TODO: document me
enum Tag {
  /// TODO: document me
  hashtag,

  /// TODO: document me
  mention,

  /// TODO: document me
  normalText,
} //TODO: url

/// TODO: document me
class TaggedText extends Equatable {
  /// Builds a [TaggedText].
  const TaggedText({
    required this.tag,
    required this.text,
  });

  /// TODO: document me
  factory TaggedText.fromMapEntry(MapEntry<Tag, String> entry) =>
      TaggedText(tag: entry.key, text: entry.value);

  /// TODO: document me
  final Tag tag;

  /// TODO: document me
  final String text;

  @override
  List<Object?> get props => [tag, text];
}

/// TODO: document me
class TagDetector {
  /// Builds a [TagDetector].
  TagDetector();

  /// TODO: document me
  final RegExp regExp = RegExp(buildRegex());

  /// TODO: document me
  static String buildRegex() =>
      Tag.values.map((tag) => tag.toRegEx()).join('|');

  /// TODO: document me
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
