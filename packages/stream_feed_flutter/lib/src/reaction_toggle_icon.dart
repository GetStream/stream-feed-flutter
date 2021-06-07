import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/reaction_icon.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionToggleIcon extends StatelessWidget {
  final List<Reaction>? ownReactions;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String kind;
  final int? count;

  ReactionToggleIcon(
      {required this.activeIcon,
      required this.inactiveIcon,
      required this.kind,
      this.ownReactions,
      this.count});
  @override
  Widget build(BuildContext context) {
    final hasReactions = ownReactions != null;
    final icon = hasReactions && ownReactions!.filterByKind(kind).isNotEmpty
        ? activeIcon
        : inactiveIcon;

    return ReactionIcon(icon: icon, count: count);
  }
}
