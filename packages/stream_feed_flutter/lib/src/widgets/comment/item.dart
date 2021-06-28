import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/display.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class CommentItem extends StatelessWidget {
  final User? user;
  final Reaction reaction;
  final OnMentionTap? onMentionTap;
  final OnHashtagTap? onHashtagTap;
  final OnUserTap? onUserTap;
  final String nameJsonKey;
  final String commentJsonKey;
  final OnReactionTap? onReactionTap;

  const CommentItem({
    Key? key,
    required this.reaction,
    this.user,
    this.onMentionTap,
    this.onHashtagTap,
    this.onUserTap,
    this.nameJsonKey = 'name',
    this.commentJsonKey = 'text',
    this.onReactionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final taggedText = reaction.data?[commentJsonKey] != null
        ? detector.parseText(reaction.data![commentJsonKey] as String)
        : <TaggedText?>[];
    return InkWell(
      onTap: () {
        onReactionTap?.call(reaction);
      },
      child: Row(
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
                            .map((it) => InteractiveText(
                                  //TODO: for loop comprehension if not null instead of map
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
      ),
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
