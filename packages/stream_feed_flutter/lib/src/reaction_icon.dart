import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  ReactionIcon({this.count, required this.icon, this.onTap});
  final int? count;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(onTap: onTap, child: icon),
        SizedBox(width: 6),
        count != null ? Text('$count') : Container()
      ],
    );
  }
}
