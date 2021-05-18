import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  ReactionIcon({this.count, required this.icon});
  final int? count;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: 6),
        count != null ? Text('$count') : Container()
      ],
    );
  }
}
