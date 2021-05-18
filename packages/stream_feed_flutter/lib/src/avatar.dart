import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class Avatar extends StatelessWidget {
  final String? url;
  Avatar({this.url});
  @override
  Widget build(BuildContext context) {
    return url != null
        ? ClipOval(
            child: Image.network(
              url!,
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
