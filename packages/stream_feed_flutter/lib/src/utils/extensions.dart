import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

part 'constants.dart';

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
}

extension ListGroup<A, Ob, T, Or>
    on List<Group<EnrichedActivity<A, Ob, T, Or>>> {
  List<EnrichedActivity<A, Ob, T, Or>> flatten() =>
      [for (var group in this) ...group.activities!];
}
