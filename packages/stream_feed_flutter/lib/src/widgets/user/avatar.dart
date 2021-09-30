import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template avatar}
/// An avatar for the user.
/// {@endtemplate}
class Avatar extends StatelessWidget {
  /// Builds an [Avatar].
  const Avatar({
    Key? key,
    this.user,
    this.jsonKey = 'profile_image',
    this.size = 46,
    this.onUserTap,
  }) : super(key: key);

  /// The User whose avatar we are displaying.
  final User? user;

  /// The size of the avatar.
  final double? size;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// A jsonKey for overriding the profile url of [User.data]
  final String jsonKey;

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
                      // TODO (Anyone): provide a way to customize progress indicator
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
                // TODO (Anyone): provide a way to customize default avatar
                size: size,
              ),
            ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<User?>('user', user))
      ..add(DoubleProperty('size', size))
      ..add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap))
      ..add(StringProperty('jsonKey', jsonKey));
  }
}
