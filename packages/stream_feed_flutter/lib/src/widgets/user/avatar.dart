import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart'
    hide Image;

import '../../utils/typedefs.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.user,
    this.jsonKey = 'profile_image',
    this.size = 46,
    this.onUserTap,
  }) : super(key: key);

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
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      //TODO: provide a way to customize progress indicator
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
                  //TODO: provide a way to cusomize default avatar
                  size: size)),
    );
  }
}
