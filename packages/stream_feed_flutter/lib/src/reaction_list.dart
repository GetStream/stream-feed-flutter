import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'comment_item.dart';

typedef OnReactionTap = void Function(Reaction? reaction);

class ReactionList extends StatelessWidget {
  final List<Reaction> reactions;
  final bool? reverse;
  final OnReactionTap? onReactionTap;
  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;

  const ReactionList({
    Key? key,
    required this.reactions,
    this.reverse,
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: reverse ?? false,
        itemCount: reactions.length,
        itemBuilder: (context, idx) => InkWell(
              onTap: () {
                onReactionTap?.call(reactions[idx]);
              },
              child: CommentItem(
                // user: getUser(reactions[idx].userId),//TODO: we probably need an EnrichedReaction here to get user instead of Reaction
                reaction: reactions[idx],
                onHashtagTap: onHashtagTap,
                onMentionTap: onMentionTap,
              ),
            ));
  }

  // getUser(String? userId) {}
}
