import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

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

  /// TODO: document me
  final String nameJsonKey;

  String? get username => user?.data?[nameJsonKey] as String?;

  @override
  Widget build(BuildContext context) {
    return Text(
      username ?? 'anonymous',
      style: UserBarTheme.of(context).usernameTextStyle,
    );
  }
}
