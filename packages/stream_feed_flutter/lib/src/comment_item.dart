import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/human_reable_timestamp.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/display.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'utils/extensions.dart';

class CommentItem extends StatelessWidget {
  final User? user;
  final Reaction reaction;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final OnUserTap? onUserTap;
  final String nameJsonKey;
  final String commentJsonKey;

  const CommentItem(
      {required this.reaction,
      this.user,
      this.onMentionTap,
      this.onHashtagTap,
      this.onUserTap,
      this.nameJsonKey = 'name',
      this.commentJsonKey = 'text'});

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final taggedText = reaction.data?[commentJsonKey] != null
        ? detector.parseText(reaction.data![commentJsonKey] as String)
        : <TaggedText?>[];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(
              user: user,
              onUserTap: onUserTap,
            )),
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
                      ...displayUsername(user),
                      if (reaction.createdAt != null)
                        HumanReadableTimestamp(timestamp: reaction.createdAt!)
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Wrap(
                      //TODO: move to Text.rich(WidgetSpans)
                      children: taggedText
                          .map((it) => _InteractiveText(
                                tagged: it,
                                onHashtagTap: onHashtagTap,
                                onMentionTap: onMentionTap,
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

  List<Widget> displayUsername(User? user) => handleDisplay(
      user?.data,
      nameJsonKey,
      TextStyle(
        color: Color(0xff0ba8e0),
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ));
}

class _InteractiveText extends StatelessWidget {
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final TaggedText? tagged;
  const _InteractiveText({
    this.tagged,
    this.onHashtagTap,
    this.onMentionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tagged != null) {
      switch (tagged!.tag) {
        case Tag.normalText:
          return Text('${tagged!.text!} ', style: tagged!.tag.style());
        case Tag.hashtag:
          return InkWell(
            onTap: () {
              onHashtagTap?.call(tagged!.text?.trim().replaceFirst('#', ''));
            },
            child: Text(tagged!.text!, style: tagged!.tag.style()),
          );
        case Tag.mention:
          return InkWell(
            onTap: () {
              onMentionTap?.call(tagged!.text?.trim().replaceFirst('@', ''));
            },
            child: Text(tagged!.text!, style: tagged!.tag.style()),
          );
        default:
          return Text(tagged!.text!, style: tagged!.tag.style());
      }
    } else {
      return Offstage();
    }
  }
}
