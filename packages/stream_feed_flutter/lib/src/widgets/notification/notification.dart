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
      // TODO: change colore based on seen/read
      onTap: () => onNotificationTap?.call(
          notificationGroup), //twitter behavior: display activity with a list of people who liked it and a follow button
      child: Row(
        children: [
          GroupIcon(group: group!),
          Column(
            children: [
              Avatars(users: users),
              NotificationHeader(
                group: group!,
                firstUsers: users.take(2).toList(),
                actorCount: notificationGroup.actorCount!,
              ),
              if (activity != null)
                NotificationContent(activity: activity!) //TODO: fixme
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
      {Key? key,
      required this.firstUsers,
      required this.actorCount,
      required this.group})
      : super(key: key);
  final List<User> firstUsers;
  final String group;
  final int actorCount;

  String userDisplay(User user) =>
      user.data?['handle'] as String? ?? user.data?['name'] as String;

  User get userOne => firstUsers[0];
  User get userTwo => firstUsers[1];

  String get action => <String, String>{
        'follow': 'followed you',
        'like': 'liked your post', //TODO: object
        'repost': 'reposted your post', //TODO: object
        'comment': 'commented your post' //TODO: object
      }[group]!;

  @override
  Widget build(BuildContext context) {
    if (actorCount < 2) {
      return Text('${userDisplay(firstUsers.first)} $action');
    }
    if (actorCount == 2) {
      return Text(
          '${userDisplay(userOne)} and ${userDisplay(userTwo)} $action');
    }
    return Text(
        '${userDisplay(firstUsers.first)} and ${actorCount - 1} other people $action');
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

class IconBadge extends StatelessWidget {
  const IconBadge(
      {Key? key,
      required this.onTap,
      this.hidden = false,
      this.showNumber = true,
      this.unseen = 0})
      : super(key: key);
  final bool hidden;
  final VoidCallback onTap;
  final bool showNumber;
  final int unseen;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: unseen > 0 && !hidden && showNumber
          ? Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0, //TODO: add posibility to position this
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$unseen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )
          : Icon(Icons.notifications),
    );
  }
}
