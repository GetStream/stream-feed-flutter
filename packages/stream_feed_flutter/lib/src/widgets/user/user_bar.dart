import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/display.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Displays the user's name, profile picture, and a timestamp at which the
/// user posted the message.
class UserBar extends StatelessWidget {
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

  /// Builds a [UserBar].
  const UserBar({
    Key? key,
    required this.timestamp,
    required this.kind,
    required this.user,
    this.onUserTap,
    this.reactionIcon,
    this.afterUsername,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'full_name',
    this.subtitle,
    this.showSubtitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(user: user, onUserTap: onUserTap)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...displayUsername(user),
              if (afterUsername != null) afterUsername!,
              if (showSubtitle)
                subtitle ??
                    ReactedBy(
                        icon: reactionIcon ??
                            ReactionByIcon(
                              kind: kind,
                            ),
                        handleOrUsername:
                            user.data?[handleJsonKey] as String? ??
                                user.data?[nameJsonKey] as String),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HumanReadableTimestamp(timestamp: timestamp),
          ),
        )
      ],
    );
  }

  List<Widget> displayUsername(User? user) => handleDisplay(
      user?.data,
      nameJsonKey,
      TextStyle(
          color: Color(0xff0ba8e0), fontWeight: FontWeight.w700, fontSize: 14));
}

class ReactedBy extends StatelessWidget {
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
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 4.0,
            ),
            Text('by'), //TODO: padding?
            Text(handleOrUsername) //TODO: padding?
          ],
        ));
  }
}

class ReactionByIcon extends StatelessWidget {
  ReactionByIcon({Key? key, required this.kind}) : super(key: key);
  final String kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case 'like':
        return StreamSvgIcon.loveActive();
      case 'repost':
        return StreamSvgIcon.repost();
      default:
        return Offstage();
    }
  }
}
