import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template post_comment_button}
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
///{@endtemplate}
class PostCommentButton extends StatefulWidget {
  ///{@macro post_comment_button}
  const PostCommentButton({
    Key? key,
    required this.textEditingController,
    this.activity,
    required this.feedGroup,
    this.targetFeeds,
  }) : super(key: key);

  /// The activity that the reaction created by this post comment button will be attached to.
  /// if none supplied this will be a new activity.
  final EnrichedActivity? activity;

  /// The Text Editing Controller used to edit the comment text.
  /// Useful to decouple the text editing from the button.
  final TextEditingController textEditingController;

  /// The feed group that the post will be posted in.
  final String feedGroup;

  ///The targeted feeds to post to.
  final List<FeedId>? targetFeeds;

  @override
  State<PostCommentButton> createState() => _PostCommentButtonState();
}

class _PostCommentButtonState extends State<PostCommentButton> {
  late StreamController<String> _textUpdates = StreamController<String>();

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      _textUpdates.add(widget.textEditingController.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _textUpdates.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              // Dis/enabled button if textInputValue.length> 0
              onPressed: snapshot.hasData && snapshot.data!.isNotEmpty
                  ? () async {
                      final streamFeed = StreamFeedCore.of(context);
                      final trimmedText = snapshot.data!.trim();
                      widget.activity != null
                          ? await streamFeed.onAddReaction(
                              kind: 'comment',
                              activity: widget.activity!,
                              data: {'text': trimmedText}, //TODO: key
                              targetFeeds: widget.targetFeeds,
                              feedGroup: widget.feedGroup,
                            )
                          : await streamFeed.onAddActivity(
                              feedGroup: widget.feedGroup,
                              verb: 'post',
                              //data: TODO: attachments with upload controller thingy
                              object: trimmedText);
                    }
                  : null,
              child: Text(
                  widget.activity != null ? 'Respond' : 'Post'), //TODO: i18n
            ),
          );
        });
  }
}
