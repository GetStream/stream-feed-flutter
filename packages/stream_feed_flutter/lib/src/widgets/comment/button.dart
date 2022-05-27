import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/reactive_elevated_button.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template post_comment_button}
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
/// {@endtemplate}
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
        final activities = FeedProvider.of(context).bloc;
        final trimmedText = inputText.trim();
        activity != null
            ? await activities.onAddReaction(
                kind: 'comment',
                activity: activity!,
                data: {'text': trimmedText}, //TODO: key
                targetFeeds: targetFeeds,
                feedGroup: feedGroup,
              )
            : await activities.onAddActivity(
                feedGroup: feedGroup,
                verb: 'post',
                //data: TODO: attachments with upload controller thingy
                object: trimmedText,
              );
      },

      label: activity != null ? 'Respond' : 'Post', //TODO: i18n
      textEditingController: textEditingController,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<GenericEnrichedActivity?>('activity', activity));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
  }
}
