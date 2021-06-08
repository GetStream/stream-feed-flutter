import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/reaction_icon.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionToggleIcon extends StatelessWidget {
  //TODO stateful with already reacted
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
  Widget build(BuildContext context) {
    final reactionsKind = ownReactions?.filterByKind(kind);
    final alreadyReacted = reactionsKind?.isNotEmpty != null;
    final displayedIcon = alreadyReacted ? activeIcon : inactiveIcon;

    return ReactionIcon(
      icon: displayedIcon,
      count: count,
      onTap: () async {
        onTap?.call ??
            await onToggleReaction(context, alreadyReacted,
                idToRemove: reactionsKind?.last.id);
      },
    );
  }

//TODO: clean this up
  Future<void> onToggleReaction(BuildContext context, bool alreadyReacted,
      {String? idToRemove}) async {
    final streamFeed = StreamFeedCore.of(context);

    alreadyReacted
        ? await streamFeed.onRemoveReaction(
            kind: kind,
            activity: activity,
            id: idToRemove!,
            feedGroup: feedGroup)
        : await streamFeed.onAddReaction(
            kind: kind,
            activity: activity,
            data: data,
            feedGroup: feedGroup,
            // targetFeeds: [
            //     if (userId != null)
            //       FeedId.id(
            //           '$feedGroup:$userId'), //'$feedGroup:${userId ?? streamFeed.user?.id}') fixed in master
            //     if (targetFeeds != null) ...targetFeeds!
            //   ]
          );
  }
}
