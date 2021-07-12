import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/circular_progress_indicator.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// An avatar for the user.
class Avatar extends StatelessWidget {
  ///The User whose avatar we are displaying.
  final User? user;

  ///The size of the avatar.
  final double size;

  /// A callback invoked when the avatar is clicked.
  final OnUserTap? onUserTap;
  Avatar({
    Key? key,
    this.user,
    this.size = 46,
    this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //TODO: fix border radius
      onTap: () {
        onUserTap?.call(user);
      },
      child: user != null
          ? ClipOval(
              child: Image.network(
                user!.data!['profile_image'] as String,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) =>
                    StreamCircularProgressIndicator(
                  loadingProgress: loadingProgress,
                  child: child,
                ),
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
