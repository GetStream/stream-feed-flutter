import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class CommentField extends StatelessWidget {
  final EnrichedActivity? activity;
  final List<FeedId>? targetFeeds;
  final TextEditingController textEditingController;
  final bool enableButton;

  ///The feed group part of the feed
  final String feedGroup;

  CommentField({
    Key? key,
    required this.feedGroup,
    this.activity,
    this.targetFeeds,
    required this.textEditingController,
    this.enableButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar(), //TODO: onUserTap
            ),
            Expanded(
              child: TextArea(
                textEditingController: textEditingController,
              ),
            ),
          ],
        ),
        if (enableButton)
          PostCommentButton(
            feedGroup: feedGroup,
            activity: activity,
            targetFeeds: targetFeeds,
            textEditingController: textEditingController,
          )
      ],
    );
  }
}
