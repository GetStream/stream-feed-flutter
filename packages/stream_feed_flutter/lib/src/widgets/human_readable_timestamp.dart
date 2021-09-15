import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/user_bar_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A human readable date.
class HumanReadableTimestamp extends StatelessWidget {
  /// Builds a [HumanReadableTimestamp].
  const HumanReadableTimestamp({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  /// The timestamp to display.
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeago.format(timestamp),
      style: UserBarTheme.of(context).timestampTextStyle,
    );
  }
}
