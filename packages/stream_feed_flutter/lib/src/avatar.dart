import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/icons.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;

class Avatar extends StatelessWidget {
  final User? user;
  final double size;
  final OnUserTap? onUserTap;
  Avatar({this.user, this.size = 48, this.onUserTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onUserTap?.call(user);
      },
      child: user != null
          ? ClipOval(
              child: Image.network(
                user!.data!['profile_image'] as String,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
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
