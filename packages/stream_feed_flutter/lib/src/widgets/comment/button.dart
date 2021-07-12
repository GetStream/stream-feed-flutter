import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///A Post comment button is a widget that allows the user to comment on a post.
/// When pressed the comment in the post will be sent to the server.
/// ```dart
/// PostCommentButton(
///           feedGroup: feedGroup,
///           activity: activity,
///           targetFeeds: targetFeeds,
///           textEditingController: textEditingController,
///         )
/// ```
class PostCommentButton extends StatelessWidget {
  const PostCommentButton({
    Key? key,
    required this.textEditingController,
    this.activity,
    required this.feedGroup,
    this.targetFeeds,
  }) : super(key: key);
  final EnrichedActivity? activity;
  final TextEditingController textEditingController;
  final String feedGroup;
  final List<FeedId>? targetFeeds;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Dis/enabled button if textInputValue.length> 0
      onPressed: () async {
        final streamFeed = StreamFeedCore.of(context);
        final text = textEditingController.value.text;
        final trimmedText = text.trim();
        activity != null
            ? await streamFeed.onAddReaction(
                kind: 'comment',
                activity: activity!,
                data: {'text': trimmedText}, //TODO: key
                targetFeeds: targetFeeds,
                feedGroup: feedGroup,
              )
            : await streamFeed.onAddActivity(
                feedGroup: feedGroup,
                verb: 'post',
                //data: TODO: attachments with upload controller thingy
                object: trimmedText);
      },
      child: Text(activity != null ? 'Respond' : 'Post'), //TODO: i18n
    );
  }
}
