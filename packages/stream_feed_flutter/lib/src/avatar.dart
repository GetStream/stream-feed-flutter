import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;

class Avatar extends StatelessWidget {
  const Avatar({this.user, this.jsonKey = 'profile_image'});

  /// The [User] we want to display the avatar
  final User? user;

  /// A jsonKey if you want to override the profile url of [User.data]
  final String jsonKey;

  @override
  Widget build(BuildContext context) {
    final profileUrl = user?.data?[jsonKey];

    return profileUrl != null
        ? ClipOval(
            child: Image.network(
              profileUrl as String,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          )
        : ClipOval(
            child: StreamSvgIcon.avatar(
            size: 30,
          ));
  }
}
