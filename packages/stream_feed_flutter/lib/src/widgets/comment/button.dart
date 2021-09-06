import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template post_comment_button}
/// Allows the current user to comment on a post.
///
/// When pressed, the comment in the post will be sent to the server.
/// ```dart
/// PostCommentButton(
///   feedGroup: feedGroup,
///   activity: activity,
///   targetFeeds: targetFeeds,
///   textEditingController: textEditingController,
/// ),
/// ```
///{@endtemplate}
class PostCommentButton extends StatelessWidget {
  /// Builds a [PostCommentButton].
  const PostCommentButton({
    Key? key,
    required this.textEditingController,
    this.activity,
    required this.feedGroup,
    this.targetFeeds,
  }) : super(key: key);

  /// The activity that the reaction created by this [PostCommentButton] will
  /// be attached to.
  ///
  /// If no activity is supplied, this will be a new activity.
  final EnrichedActivity? activity;

  /// The Text Editing Controller used to edit the comment text.
  ///
  /// Useful to decouple the text editing from the button.
  final TextEditingController textEditingController;

  /// The feed group that the post will be posted in.
  final String feedGroup;

  ///The targeted feeds to post to.
  final List<FeedId>? targetFeeds;

  @override
  Widget build(BuildContext context) {
    return ReactiveElevatedButton(
      onSend: (inputText) async {
        final streamFeed = StreamFeedCore.of(context);
        final trimmedText = inputText.trim();
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

      label: activity != null ? 'Respond' : 'Post', //TODO: i18n
      textEditingController: textEditingController,
    );
  }
}

/// TODO: document me
typedef OnSend = Function(String inputText);

/// TODO: document me
class ReactiveElevatedButton extends StatefulWidget {
  /// Builds a [ReactiveElevatedButton].
  const ReactiveElevatedButton({
    Key? key,
    required this.textEditingController,
    required this.label,
    required this.onSend,
  }) : super(key: key);

  /// TODO: document me
  final TextEditingController textEditingController;

  /// TODO: document me
  final OnSend onSend;

  /// TODO: document me
  final String label;

  @override
  _ReactiveElevatedButtonState createState() => _ReactiveElevatedButtonState();
}

class _ReactiveElevatedButtonState extends State<ReactiveElevatedButton> {
  late final StreamController<String> _textUpdates = StreamController<String>();

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      _textUpdates.add(widget.textEditingController.value.text);
    });
  }

  @override
  void dispose() {
    _textUpdates.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: _textUpdates.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              // Dis/enabled button if textInputValue.length> 0
              onPressed: snapshot.hasData && snapshot.data!.isNotEmpty
                  ? () async {
                      await widget.onSend(snapshot.data!);
                    }
                  : null,

              child: Text(widget.label),
            ),
          );
        });
  }
}
