import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template comment_field}
/// A Comment Field widget is a field for adding comments to a feed
/// It displays the avatar, a textarea and a button to submit the comment.
///{@endtemplate}
class CommentField extends StatelessWidget {
  ///{@macro comment_field}
  const CommentField({
    Key? key,
    required this.feedGroup,
    this.activity,
    this.targetFeeds,
    required this.textEditingController,
    required this.statusUpdateFormController,
    this.enableButton = true,
  }) : super(key: key);

  /// The activity on which the comment will be posted (reaction)
  /// if none is provided, the comment will be posted as new activity.
  final EnrichedActivity? activity;

  /// The target feed on which the comment will be posted.
  final List<FeedId>? targetFeeds;

  /// Text Editing Controller used by both the comment textarea and the submit button.
  final TextEditingController textEditingController;

  final StatusUpdateFormController statusUpdateFormController;

  /// Wether or not you want to display the comment button.
  final bool enableButton;

  ///The feed group part of the feed
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar(), //TODO: User in core and onUserTap
            ),
            Expanded(
              child: TextArea(
                textEditingController: textEditingController,
              ),
            ),
            if (enableButton)
              PostCommentButton(
                feedGroup: feedGroup,
                activity: activity,
                targetFeeds: targetFeeds,
                textEditingController: textEditingController,
                statusUpdateFormController: statusUpdateFormController,
              )
          ],
        ),
      ],
    );
  }
}
