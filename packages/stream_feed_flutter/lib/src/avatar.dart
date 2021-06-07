import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;

class Avatar extends StatelessWidget {
  Avatar({this.user, this.jsonKey});

  final User? user;
  final String? jsonKey;

  @override
  Widget build(BuildContext context) {
    return user != null
        ? ClipOval(
            child: Image.network(
              user!.data![jsonKey ?? 'profile_image'] as String,
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
