import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/display.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';

import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///A Comment Item is a widget used to display a single comment on an activity.
/// You click on:
/// - the avatar to view the user's profile
/// - on hashtags to view the activity feed for that tag.
/// - mentions to view the activity feed for that user.
///
class CommentItem extends StatelessWidget {
  /// Who posted this comment.
  final User? user;

  /// The content of the comment reaction
  final Reaction reaction;

  ///{@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// A callback to invoke when the user clicks on a hashtag.
  final OnHashtagTap? onHashtagTap;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// The json key in [User.data]
  /// used to access the name you want to display. By default it's 'name'.
  final String nameJsonKey;

  /// The json key in [Reaction.data]
  /// used to access the text of the comment you want to display. By default it's 'text'.
  final String commentJsonKey;

  ///{@macro reaction_callback}
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
