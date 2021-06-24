import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/icons.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;

class Avatar extends StatelessWidget {
  const Avatar({this.user, this.jsonKey = 'profile_image', this.size = 48, this.onUserTap});

  /// The [User] we want to display the avatar
  final User? user;

  /// A jsonKey if you want to override the profile url of [User.data]
  final String jsonKey;

  final double size;
  
  final OnUserTap? onUserTap;
  
  @override
  Widget build(BuildContext context) {
    final profileUrl = user?.data?[jsonKey];
    return InkWell(
      onTap: () {
        onUserTap?.call(user);
      },
      child: profileUrl != null
        ? ClipOval(
            child: Image.network(
              profileUrl as String,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          )
        : ClipOval(
            child: StreamSvgIcon.avatar(
            size: size,
          )),
    );
  }
}
