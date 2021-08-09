import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template repost_button}
/// A Repost Button is a widget that allows a user to repost a feed item.
/// When pressed it will post a new item with the same content as the original
///{@endtemplate}
class RepostButton extends StatelessWidget {
  /// Builds a [RepostButton].
  const RepostButton({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
    this.reaction,
    this.onTap,
    this.inactiveIcon,
    this.activeIcon,
  }) : super(key: key);

  ///If you want to override the activeIcon
  final Widget? activeIcon;

  ///If you want to override the inactiveIcon
  final Widget? inactiveIcon;

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  /// The feed group that the activity belongs to.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
      activity: activity,
      reaction: reaction,
      activeIcon: activeIcon ?? StreamSvgIcon.repost(color: Colors.blue),
      inactiveIcon: inactiveIcon ?? StreamSvgIcon.repost(color: Colors.grey),
      hoverColor: Colors.green.shade100,
      kind: 'repost',
      onTap: onTap,
      feedGroup: feedGroup,
    );
  }
}
