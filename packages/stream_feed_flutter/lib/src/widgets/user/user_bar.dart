import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/user_bar_theme.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/delete_activity_dialog.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/src/widgets/user/username.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Displays the user's name, profile picture, and a timestamp at which the
/// user posted the message.
class UserBar extends StatelessWidget {
  /// Builds a [UserBar].
  const UserBar({
    Key? key,
    required this.activityId,
    required this.timestamp,
    required this.kind,
    required this.user,
    required this.feedGroup,
    this.onUserTap,
    this.reactionIcon,
    this.afterUsername,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
    this.subtitle,
    this.showSubtitle = true,
    this.showReactedBy = false,
  }) : super(key: key);

  /// The ID of the activity deing displayed.
  final String activityId;

  /// The User whose bar is being displayed.
  final User user;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// The reaction icon to display next to the user's name (if any)
  final Widget? reactionIcon;

  /// The widget to display after the user's name.
  final Widget? afterUsername;

  /// The subtitle of the user bar if any
  final Widget? subtitle;

  /// The json key for the user's handle.
  final String handleJsonKey;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// The time at which the user posted the message.
  final DateTime timestamp;

  /// The reaction kind to display.
  final String kind;

  /// Whether or not to show the subtitle.
  final bool showSubtitle;

  /// Whether to show the "reacted by" widget or not.
  ///
  /// Defaults to `false`.
  final bool showReactedBy;

  /// The feed group that this activity belongs to.
  ///
  /// Ex: 'timeline'.
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    final bloc =
        GenericFeedProvider<User, String, String, String>.of(context).bloc;

    // If handle is null, show name. If both are null, show
    // an empty string.
    final displayName = user.data?[handleJsonKey] as String? ??
        user.data?[nameJsonKey] as String?;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Avatar(
            user: user,
            onUserTap: onUserTap,
            size: UserBarTheme.of(context).avatarSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Username(
                user: user,
                nameJsonKey: nameJsonKey,
              ),
              const SizedBox(width: 4),
              if (afterUsername != null) afterUsername!,
              if (showSubtitle && subtitle != null)
                subtitle!
              else if (showReactedBy)
                ReactedBy(
                  icon: reactionIcon ?? ReactionByIcon(kind: kind),
                  handleOrUsername: displayName ?? '',
                ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: HumanReadableTimestamp(timestamp: timestamp),
        ),
        if (bloc.currentUser!.id == user.id)
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              size: 18,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (_) => DeleteActivityDialog(
                    activityId: activityId,
                    feedGroup: feedGroup,
                  ),
                );
              }
            },
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<String>('activityId', activityId));
    properties.add(DiagnosticsProperty<bool>('showSubtitle', showSubtitle));
    properties.add(StringProperty('kind', kind));
    properties.add(DiagnosticsProperty<DateTime>('timestamp', timestamp));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(DiagnosticsProperty<User>('user', user));
    properties.add(DiagnosticsProperty<bool>('showReactedBy', showReactedBy));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}

class ReactedBy extends StatelessWidget {
  /// Builds a [ReactedBy].
  const ReactedBy({
    Key? key,
    required this.icon,
    required this.handleOrUsername,
  }) : super(key: key);

  final Widget icon;

  final String handleOrUsername;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 4,
          ),
          const Text('by '), //TODO: padding?
          Text(handleOrUsername) //TODO: padding?
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('handleOrUsername', handleOrUsername));
  }
}

class ReactionByIcon extends StatelessWidget {
  /// Builds a [ReactionByIcon].
  const ReactionByIcon({
    Key? key,
    required this.kind,
  }) : super(key: key);

  final String kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case 'like':
        return StreamSvgIcon.loveActive();
      case 'repost':
        return StreamSvgIcon.repost();
      default:
        return const Offstage();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('kind', kind));
  }
}
