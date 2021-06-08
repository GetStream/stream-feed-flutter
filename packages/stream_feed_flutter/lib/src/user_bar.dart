import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserBar extends StatelessWidget {
  final User? user;
  final Reaction reaction;
  final OnUserTap? onUserTap;
  final Widget icon;
  final Widget? afterUsername;
  final Widget? subtitle;
  final String handleJsonKey;
  final String nameJsonKey;
  const UserBar(
      {required this.reaction,
      this.user,
      this.onUserTap,
      required this.icon,
      this.afterUsername,
      this.handleJsonKey = 'handle',
      this.nameJsonKey = 'name',
      this.subtitle});

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
                        icon: icon,
                        handle: user?.data?[handleJsonKey] as String),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HumanReadableTimestamp(timestamp: reaction.createdAt),
        )
      ],
    );
  }

  List<Widget> displayUsername(User? user) => handleDisplay(user, nameJsonKey);

  List<Widget> handleDisplay(User? user, String jsonKey) {
    return user?.data?[jsonKey] != null
        ? [
            Text(user!.data?[jsonKey] as String,
                style: TextStyle(
                    color: Color(0xff0ba8e0),
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            SizedBox(
              width: 4.0,
            ),
          ]
        : [Offstage()];
  }
}

class ReactedBy extends StatelessWidget {
  const ReactedBy({
    Key? key,
    required this.icon,
    required this.handle,
  }) : super(key: key);

  final Widget icon;
  final String handle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            icon, //TODO: infer from kind
            SizedBox(
              width: 4.0,
            ),
            Text('by'),
            Text(handle) //TODO: padding
          ],
        ));
  }
}

class HumanReadableTimestamp extends StatelessWidget {
  const HumanReadableTimestamp({Key? key, this.timestamp}) : super(key: key);

  /// If you want to override reaction time
  final DateTime? timestamp;
  @override
  Widget build(BuildContext context) {
    return timestamp != null
        ? Text(
            timeago.format(timestamp!),
            style: TextStyle(
                color: Color(0xff7a8287),
                fontWeight: FontWeight.w400,
                height: 1.5,
                fontSize: 14),
          )
        : Offstage();
  }
}
