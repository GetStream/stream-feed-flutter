import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

//`follow`, `like`, `repost`, `comment`.
class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    Key? key,
    required this.notificationGroup,
    this.onNotificationTap,
    this.onUserTap,
  }) : super(key: key);
  final NotificationGroup<EnrichedActivity> notificationGroup;
  final OnUserTap? onUserTap;
  final OnNotificationTap? onNotificationTap;

  String? get group => notificationGroup.group;

  User getUserFrom(EnrichedActivity activity) => User.fromJson(
      EnrichableField.serialize(activity.actor) as Map<String, dynamic>);

  List<User> get users => notificationGroup.activities!
      .map((activity) => getUserFrom(activity))
      .take(10)
      .toList();

  EnrichedActivity? get activity => notificationGroup.activities?.first;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onNotificationTap?.call(
          notificationGroup), //twitter behavior: display activity with a list of people who liked it and a follow button
      child: Row(
        children: [
          GroupIcon(group: group!),
          Column(
            children: [
              Avatars(users: users),
              NotificationHeader(
                firstUsers: users.take(2).toList(),
                actorCount: notificationGroup.actorCount!,
              ),
              if (activity != null) NotificationContent(activity: activity!)
            ],
          )
        ], //Display 10 avatars max
      ),
    );
  }
}

class Avatars extends StatelessWidget {
  const Avatars({Key? key, required this.users}) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) =>
      Row(children: users.map((user) => Avatar(user: user, size: 28)).toList());
}

class GroupIcon extends StatelessWidget {
  const GroupIcon({Key? key, required this.group}) : super(key: key);
  final String group;
  @override
  Widget build(BuildContext context) {
    switch (group) {
      case 'follow':
        return Icon(Icons.person, color: Colors.blue);
      case 'like':
        return StreamSvgIcon.loveActive();
      case 'repost':
        return StreamSvgIcon.repost(color: Colors.blue);
      default:
        return StreamSvgIcon.post();
    }
  }
}

class NotificationHeader extends StatelessWidget {
  const NotificationHeader(
      {Key? key, required this.firstUsers, required this.actorCount})
      : super(key: key);
  final List<User> firstUsers;
  final int actorCount;

  String userDisplay(User user) =>
      user.data?['handle'] as String? ?? user.data?['name'] as String;

  User get userOne => firstUsers[0];
  User get userTwo => firstUsers[1];

  @override
  Widget build(BuildContext context) {
    if (actorCount < 2) {
      return Text(
          '${userDisplay(firstUsers.first)} followed you'); //TODO: unhardcode this
    }
    if (actorCount == 2) {
      return Text(
          '${userDisplay(userOne)} and ${userDisplay(userTwo)} followed you'); //TODO: unhardcode this
    }
    return Text(
        '${userDisplay(firstUsers.first)} and ${actorCount - 1} other people followed you'); //TODO: unhardcode this
  }
}

class NotificationContent extends StatelessWidget {
  const NotificationContent({Key? key, required this.activity})
      : super(key: key);
  final EnrichedActivity activity;

  String get activityObject =>
      EnrichableField.serialize(activity.object) as String;

  @override
  Widget build(BuildContext context) {
    return Text(activityObject);
  }
}
