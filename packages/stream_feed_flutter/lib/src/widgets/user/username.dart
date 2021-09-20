import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

// ignore_for_file: cascade_invocations

/// TODO: document me
class Username extends StatelessWidget {
  /// Builds a [Username].
  const Username({
    Key? key,
    this.user,
    required this.nameJsonKey,
  }) : super(key: key);

  /// The user to show a username for
  final User? user;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// Username
  String? get username => user?.data?[nameJsonKey] as String?;

  @override
  Widget build(BuildContext context) {
    return Text(
      username ?? 'anonymous',
      style: UserBarTheme.of(context).usernameTextStyle,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('username', username));
    properties.add(DiagnosticsProperty<User?>('user', user));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
  }
}
