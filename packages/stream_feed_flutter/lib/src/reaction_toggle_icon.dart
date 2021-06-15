import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/reaction_icon.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

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
