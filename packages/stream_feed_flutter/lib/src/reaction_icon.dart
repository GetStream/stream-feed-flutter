import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  const ReactionIcon({Key? key, this.count, required this.icon, this.onTap})
      : super(key: key);
  
  final int? count;

  ///The reaction icon you want to display
  final Widget icon;
  
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPositive = count?.isNegative;
    return InkWell(
      onTap: onTap,
      child: isPositive != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon, SizedBox(width: 6), Text('$count')],
            )
          : icon,
    );
  }
}
