import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  const ReactionIcon({Key? key, this.count = 0, required this.icon, this.onTap})
      : super(key: key);
  final int count;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: count == 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon, SizedBox(width: 6), Text('$count')],
            )
          : icon,
    );
  }
}
