import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template comment_field}
/// A field for adding comments to a feed.
///
/// It displays the avatar, a text area and a button to submit the comment.
/// {@endtemplate}
class CommentField extends StatelessWidget {
  /// Builds a [CommentField].
  const CommentField({
    Key? key,
    required this.feedGroup,
    this.activity,
    this.targetFeeds,
    required this.textEditingController,
    this.enableButton = true,
  }) : super(key: key);

  /// The activity on which the comment will be posted (reaction).
  ///
  /// If no activity is provided, the comment will be posted as a new activity.
  final EnrichedActivity? activity;

  /// The target feed on which the comment will be posted.
  final List<FeedId>? targetFeeds;

  /// [TextEditingController] used by both the comment text area and the
  /// submit button.
  final TextEditingController textEditingController;

  /// Whether or not to display the comment button.
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
              padding: const EdgeInsets.all(8),
              //TODO: pass down User
              child: Avatar(
                user: User(
                  data: FeedBlocProvider.of(context).bloc.currentUser!.data,
                ),
                size: UserBarTheme.of(context).avatarSize,
              ), //TODO: User in core and onUserTap
            ),
            Expanded(
              child: TextArea(
                textEditingController: textEditingController,
                hintText: 'Post your reply',
              ),
            ),
            if (enableButton)
              PostCommentButton(
                feedGroup: feedGroup,
                activity: activity,
                targetFeeds: targetFeeds,
                textEditingController: textEditingController,
              )
          ],
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<GenericEnrichedActivity?>('activity', activity));
    properties.add(IterableProperty<FeedId>('targetFeeds', targetFeeds));
    properties.add(DiagnosticsProperty<TextEditingController>(
        'textEditingController', textEditingController));
    properties.add(DiagnosticsProperty<bool>('enableButton', enableButton));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}
