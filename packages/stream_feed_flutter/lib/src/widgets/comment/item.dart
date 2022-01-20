import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/user_bar_theme.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/like.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/repost.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/src/widgets/user/username.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template comment_item}
/// Displays a single comment on an activity.
///
/// Click on:
/// - the avatar to view the user's profile
/// - hashtags to view the activity feed for that tag.
/// - mentions to view the activity feed for that user.
///
/// {@endtemplate}
class CommentItem extends StatelessWidget {
  /// Builds a [CommentItem].
  const CommentItem({
    Key? key,
    required this.reaction,
    required this.activity,
    this.user,
    this.onMentionTap,
    this.onHashtagTap,
    this.onUserTap,
    this.nameJsonKey = 'name',
    this.commentJsonKey = 'text',
    this.onReactionTap,
  }) : super(key: key);

  /// Who posted this comment.
  final User? user;

  /// The content of the comment reaction
  final Reaction reaction;

  /// {@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// A callback to invoke when the user clicks on a hashtag.
  final OnHashtagTap? onHashtagTap;

  /// {@macro user_callback}
  final OnUserTap? onUserTap;

  /// The json key in [User.data].
  ///
  /// Used to access the name you want to display. By default it is 'name'.
  final String nameJsonKey;

  /// The json key in [Reaction.data].
  ///
  /// Used to access the text of the comment you want to display.
  /// By default it is 'text'.
  final String commentJsonKey;

  /// {@macro reaction_callback}
  final OnReactionTap? onReactionTap;
  final EnrichedActivity activity;

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final taggedText = reaction.data?[commentJsonKey] != null
        ? detector.parseText(reaction.data![commentJsonKey]! as String)
        : <TaggedText>[];
    return InkWell(
      onTap: () {
        onReactionTap?.call(reaction);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Avatar(
              user: user,
              onUserTap: onUserTap,
              size: UserBarTheme.of(context).avatarSize,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        Username(
                          user: user,
                          nameJsonKey: nameJsonKey,
                        ),
                        const SizedBox(width: 4),
                        if (reaction.createdAt != null)
                          HumanReadableTimestamp(
                              timestamp:
                                  reaction.createdAt!) //not null in the future
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Wrap(
                      //TODO: move to Text.rich(WidgetSpans)
                      children: taggedText
                          .map((it) => InteractiveText(
                                tagged: it,
                                onHashtagTap: onHashtagTap,
                                onMentionTap: onMentionTap,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeButton(activity: activity, reaction: reaction)
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<User?>('user', user));
    properties.add(DiagnosticsProperty<Reaction>('reaction', reaction));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(StringProperty('commentJsonKey', commentJsonKey));
    properties.add(
        ObjectFlagProperty<OnReactionTap?>.has('onReactionTap', onReactionTap));
  }
}
