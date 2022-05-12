import 'package:stream_feed_flutter/src/utils/tag_detector.dart';

part 'constants.dart';

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
}
