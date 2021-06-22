import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class PostCommentButton extends StatelessWidget {
  /// ```dart
  /// PostCommentButton(
  ///           feedGroup: feedGroup,
  ///           activity: activity,
  ///           targetFeeds: targetFeeds,
  ///           textEditingController: textEditingController,
  ///         )
  /// ```
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
                  data: {'text': trimmedText},
                  verb: 'post',
                  object: trimmedText);
        },
        child: const Text('Post' //Respond //TODO: i18n
            ));
  }
}
