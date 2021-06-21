import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  const ReactionIcon({
    Key? key,
    this.count,
    required this.icon,
    this.onTap,
    this.hoverColor = Colors.lightBlue,
  }) : super(key: key);
  final int? count;
  final Widget icon;
  final VoidCallback? onTap;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        hoverColor: hoverColor,
        borderRadius: BorderRadius.circular(18.0), //iconSize
        onTap: onTap,
        child: count != null && count! > 0
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    SizedBox(width: 6),
                    Center(child: Text('$count'))
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: icon,
              ));
  }
}
