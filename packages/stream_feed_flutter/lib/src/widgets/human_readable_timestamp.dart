import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


/// An Human readable date.
class HumanReadableTimestamp extends StatelessWidget {
  const HumanReadableTimestamp({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  /// If you want to override reaction time
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeago.format(timestamp),
      style: TextStyle(
        color: Color(0xff7a8287),
        fontWeight: FontWeight.w400,
        height: 1.5,
        fontSize: 14,
      ),
    );
  }
}
