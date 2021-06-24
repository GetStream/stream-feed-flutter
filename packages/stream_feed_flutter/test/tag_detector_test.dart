import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:test/test.dart';

main() {
  test('TagDetector', () {
    final detector = TagDetector();
    final result = detector
        .parseText('Snowboarding is awesome! #snowboarding #winter @sacha');

    expect(result, [
      TaggedText(tag: Tag.normalText, text: 'Snowboarding'),
      TaggedText(tag: Tag.normalText, text: 'is'),
      TaggedText(tag: Tag.normalText, text: 'awesome!'),
      TaggedText(tag: Tag.hashtag, text: ' #snowboarding'),
      TaggedText(tag: Tag.hashtag, text: ' #winter'),
      TaggedText(tag: Tag.mention, text: ' @sacha')
    ]);
  });
}
