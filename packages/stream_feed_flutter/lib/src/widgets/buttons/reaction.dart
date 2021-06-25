import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionButton extends StatelessWidget {
  ReactionButton({
    required this.activity,
    required this.kind,
    required this.activeIcon,
    required this.inactiveIcon,
    this.feedGroup = 'user',
    this.hoverColor = Colors.lightBlue,
    this.reaction,
    this.onTap,
    this.data,
  });

  ///The reaction received from stream that should be liked when pressing the LikeButton.
  final Reaction? reaction;

  /// The activity received from stream that should be liked when pressing the LikeButton.
  final EnrichedActivity activity;

  ///If you want to override on tap for some reasons
  final VoidCallback? onTap;

  final String kind;

  /// The button to display if the user already reacted
  final Widget activeIcon;

  /// The button to display if the user didn't reacted yet
  final Widget inactiveIcon;

  final Map<String, Object>? data;

  final Color hoverColor;

  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return ReactionToggleIcon(
      activity: activity,
      count: reaction?.childrenCounts?[kind] ?? activity.reactionCounts?[kind],
      ownReactions:
          reaction?.ownChildren?[kind] ?? activity.ownReactions?[kind],
      activeIcon: activeIcon,
      inactiveIcon: inactiveIcon,
      hoverColor: hoverColor,
      kind: kind,
      onTap: onTap,
      data: data,
      feedGroup: feedGroup,
    );
  }
}

class ReactionToggleIcon extends StatefulWidget {
  final List<Reaction>? ownReactions;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String kind;
  final int? count;
  final VoidCallback? onTap;
  final String feedGroup;
  final EnrichedActivity activity;
  final String? userId;
  final Map<String, Object>? data;
  final List<FeedId>? targetFeeds;
  final Color hoverColor;
  //TODO: see what we can extract from a parent widget and put in core
  ReactionToggleIcon({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.kind,
    required this.activity,
    this.targetFeeds,
    this.data,
    this.onTap,
    this.ownReactions,
    this.feedGroup = 'user',
    this.hoverColor = Colors.lightBlue,
    this.count,
    this.userId,
  });

  @override
  State<ReactionToggleIcon> createState() => _ReactionToggleIconState();
}

class _ReactionToggleIconState extends State<ReactionToggleIcon> {
  late bool alreadyReacted;
  late List<Reaction?>? reactionsKind;
  late String? idToRemove;

  @override
  void initState() {
    super.initState();
    reactionsKind = widget.ownReactions?.filterByKind(widget.kind);
    alreadyReacted = reactionsKind?.isNotEmpty != null;
    idToRemove = reactionsKind?.last?.id;
  }

  @override
  Widget build(BuildContext context) {
    final displayedIcon =
        alreadyReacted ? widget.activeIcon : widget.inactiveIcon;

    return ReactionIcon(
      hoverColor: widget.hoverColor,
      icon: displayedIcon,
      count: widget.count, //TODO: handle count
      onTap: () async {
        widget.onTap?.call ?? await onToggleReaction();
      },
    );
  }

  Future<void> onToggleReaction() async {
    alreadyReacted ? await removeReaction() : await addReaction();
  }

  Future<void> addReaction() async {
    final reaction = await StreamFeedCore.of(context).onAddReaction(
        kind: widget.kind,
        activity: widget.activity,
        data: widget.data,
        feedGroup: widget.feedGroup);
    setState(() {
      alreadyReacted = !alreadyReacted;
      idToRemove = reaction.id!;
    });
  }

  Future<void> removeReaction() async {
    await StreamFeedCore.of(context).onRemoveReaction(
        kind: widget.kind,
        activity: widget.activity,
        id: idToRemove!,
        feedGroup: widget.feedGroup);
    setState(() {
      alreadyReacted = !alreadyReacted;
    });
  }
}

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
