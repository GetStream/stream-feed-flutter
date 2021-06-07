import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  const ReactionIcon({Key? key, required this.count, required this.icon})
      : super(key: key);

  /// The number of likes or reposts this ReactionIcon will display
  final int count;

  ///The reaction icon you want to display
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [icon, const SizedBox(width: 6), Text('$count')],
    );
  }
}
