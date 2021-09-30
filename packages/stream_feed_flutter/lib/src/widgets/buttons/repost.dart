import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reaction.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template repost_button}
/// A Repost Button is a widget that allows a user to repost a feed item.
/// When pressed it will post a new item with the same content as the original
/// {@endtemplate}
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

  /// The icon to display when a post has been liked by the current user.
  final Widget? activeIcon;

  /// The icon to display when a post has not yet been liked by the current
  /// user.
  final Widget? inactiveIcon;

  /// The reaction received from Stream that should be liked when pressing
  /// the [LikeButton].
  final Reaction? reaction;

  /// The activity received from Stream that should be liked when pressing
  /// the [LikeButton].
  final EnrichedActivity activity;

  /// The callback to be performed on tap.
  ///
  /// This is generally not to be overridden, but can be done if developers
  /// wish.
  final VoidCallback? onTap;

  /// The feed group that the activity belongs to.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return ReactionButton(
      activity: activity,
      reaction: reaction,
      activeIcon: activeIcon ?? StreamSvgIcon.repost(color: Colors.blue),
      inactiveIcon: inactiveIcon ??
          StreamSvgIcon.repost(
            color: StreamFeedTheme.of(context).primaryIconTheme.color,
          ),
      hoverColor: Colors.green.shade100,
      kind: 'repost',
      onTap: onTap,
      feedGroup: feedGroup,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Reaction?>('reaction', reaction))
      ..add(DiagnosticsProperty<EnrichedActivity>('activity', activity))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap))
      ..add(StringProperty('feedGroup', feedGroup));
  }
}
