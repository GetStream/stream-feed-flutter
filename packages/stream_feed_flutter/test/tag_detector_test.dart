import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:test/test.dart';

void main() {
  test('TagDetector', () {
    final detector = TagDetector();
    final result = detector
        .parseText('Snowboarding is awesome! #snowboarding #winter @sacha');

    expect(result, [
      const TaggedText(tag: Tag.normalText, text: 'Snowboarding'),
      const TaggedText(tag: Tag.normalText, text: 'is'),
      const TaggedText(tag: Tag.normalText, text: 'awesome!'),
      const TaggedText(tag: Tag.hashtag, text: ' #snowboarding'),
      const TaggedText(tag: Tag.hashtag, text: ' #winter'),
      const TaggedText(tag: Tag.mention, text: ' @sacha')
    ]);
  });
}
