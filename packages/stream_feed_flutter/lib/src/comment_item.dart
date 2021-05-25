import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'utils/extensions.dart';

typedef OnClickMention = void Function(String? mention);
typedef OnClickHashtag = void Function(String? hashtag);

class CommentItem extends StatelessWidget {
  final User user;
  final Reaction reaction;
  final OnClickMention onClickMention;
  final OnClickHashtag onClickHashtag;
  CommentItem(
      {required this.user,
      required this.reaction,
      required this.onClickMention,
      required this.onClickHashtag});
  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final taggedText = detector.parseText(reaction.data!['text'] as String);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Avatar(
            size: 25,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      Text(user.data!['name'] as String,
                          style: TextStyle(
                              color: Color(0xff0ba8e0),
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        timeago.format(reaction.createdAt!),
                        style: TextStyle(
                            color: Color(0xff7a8287),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Wrap(
                      children: taggedText
                          .map((it) => _InteractiveText(
                                tagged: it,
                                onClickHashtag: onClickHashtag,
                                onClickMention: onClickMention,
                              ))
                          .toList(),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _InteractiveText extends StatelessWidget {
  final OnClickMention onClickMention;
  final OnClickHashtag onClickHashtag;
  TaggedText tagged;
  _InteractiveText(
      {required this.tagged,
      required this.onClickHashtag,
      required this.onClickMention});

  @override
  Widget build(BuildContext context) {
    switch (tagged.tag) {
      case Tag.normalText:
        return Text('${tagged.text!} ', style: tagged.tag.style());
      case Tag.hashtag:
        return InkWell(
          onTap: () {
            onClickHashtag(tagged.text);
          },
          child: Text(tagged.text!, style: tagged.tag.style()),
        );
      case Tag.mention:
        return InkWell(
          onTap: () {
            onClickMention(tagged.text);
          },
          child: Text(tagged.text!, style: tagged.tag.style()),
        );
      default:
        return Text(tagged.text!, style: tagged.tag.style());
    }
  }
}
