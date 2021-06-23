import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import '../comment/item.dart';

//TODO: rename this to ReactionListInner and do a futureBuilder (will be in core) with future client.reactions.filter()
class ReactionListInner extends StatelessWidget {
  final List<Reaction> reactions;
  final bool? reverse;
  final OnReactionTap? onReactionTap;
  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;

  const ReactionListInner({
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
      itemBuilder: (context, idx) => CommentItem(
        //TODO: builder here
        user: reactions[idx].user,
        reaction: reactions[idx],
        onReactionTap: onReactionTap,
        onHashtagTap: onHashtagTap,
        onMentionTap: onMentionTap,
        onUserTap: onUserTap,
      ),
    );
  }

  // getUser(String? userId) {}
}
