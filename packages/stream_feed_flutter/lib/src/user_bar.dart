import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/human_readable_timestamp.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/src/utils/display.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class UserBar extends StatelessWidget {
  final User? user;
  final OnUserTap? onUserTap;
  final Widget? reactionIcon;
  final Widget? afterUsername;
  final Widget? subtitle;
  final String handleJsonKey;
  final String nameJsonKey;
  final DateTime timestamp;
  final String kind;

  const UserBar({
    required this.timestamp,
    required this.kind,
    this.user,
    this.onUserTap,
    this.reactionIcon,
    this.afterUsername,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Avatar(user: user, onUserTap: onUserTap)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...displayUsername(user),
                if (afterUsername != null) afterUsername!,
                subtitle ??
                    ReactedBy(
                        icon: reactionIcon ??
                            ReactionByIcon(
                              kind: kind,
                            ),
                        handleOrUsername:
                            user?.data?[handleJsonKey] as String? ??
                                user?.data?[nameJsonKey] as String),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HumanReadableTimestamp(timestamp: timestamp),
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
  ReactionByIcon({Key? key, required this.kind, this.icon}) : super(key: key);
  final String kind;
  final Widget? icon;

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
