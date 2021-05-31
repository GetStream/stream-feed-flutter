import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'utils/extensions.dart';

typedef OnMentionTap = void Function(String? mention);
typedef OnHashtagTap = void Function(String? hashtag);

class CommentItem extends StatelessWidget {
  final User? user;
  final Reaction reaction;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;

  const CommentItem({
    required this.reaction,
    this.user,
    this.onMentionTap,
    this.onHashtagTap,
  });

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final taggedText = reaction.data?['text'] != null
        ? detector.parseText(reaction.data!['text'] as String)
        : <TaggedText?>[];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Avatar(user: user)),
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
                      reaction.createdAt != null
                          ? Text(
                              timeago.format(reaction.createdAt!),
                              style: TextStyle(
                                  color: Color(0xff7a8287),
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  fontSize: 14),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Wrap(
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

  List<Widget> displayUsername(User? user) {
    return user?.data?['name'] != null
        ? [
            Text(user!.data?['name'] as String,
                style: TextStyle(
                    color: Color(0xff0ba8e0),
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            // : Container(),
            SizedBox(
              width: 4.0,
            ),
          ]
        : [Container()];
  }
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
      return Container();
    }
  }
}
