import 'package:flutter/material.dart';

class ReactionIcon extends StatelessWidget {
  const ReactionIcon({Key? key, this.count, required this.icon, this.onTap})
      : super(key: key);
  final int? count;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
