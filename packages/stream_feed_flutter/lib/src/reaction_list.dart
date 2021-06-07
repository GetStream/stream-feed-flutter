import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/typedefs.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'comment_item.dart';

class ReactionList extends StatelessWidget {
  final List<Reaction> reactions;
  final bool? reverse;
  final OnReactionTap? onReactionTap;
  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;

  const ReactionList({
    Key? key,
    required this.reactions,
    this.reverse,
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        reverse: reverse ?? false,
        itemCount: reactions.length,
        itemBuilder: (context, idx) => InkWell(
              //TODO; hmm maybe move this in CommentItem
              onTap: () {
                onReactionTap?.call(reactions[idx]);
              },
              child: CommentItem(
                  user: reactions[idx].user,
                  reaction: reactions[idx],
                  onHashtagTap: onHashtagTap,
                  onMentionTap: onMentionTap,
                  onUserTap: onUserTap),
            ));
  }

  // getUser(String? userId) {}
}
