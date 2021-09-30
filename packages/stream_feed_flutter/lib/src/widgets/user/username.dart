import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

/// Text widget to display a user's username.
class Username extends StatelessWidget {
  /// Text widget to display a user's username.

  const Username({
    Key? key,
    this.user,
    required this.nameJsonKey, // TODO (Gordon): create certain user parameters on [User], similar to Chat.
  }) : super(key: key);

  /// The user to show a username for.
  final User? user;

  /// The json key for the user's name.
  final String nameJsonKey;

  /// Get the user's username.
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
    properties
      ..add(StringProperty('username', username))
      ..add(DiagnosticsProperty<User?>('user', user))
      ..add(StringProperty('nameJsonKey', nameJsonKey));
  }
}
