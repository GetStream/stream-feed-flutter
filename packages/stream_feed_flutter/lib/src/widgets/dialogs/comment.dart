import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class AlertDialogComment extends StatelessWidget {
  const AlertDialogComment({
    Key? key,
    this.activity,
    required this.feedGroup,
  }) : super(key: key);
  final String feedGroup;
  final EnrichedActivity? activity;

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return AlertDialog(
      actions: [
        AlertDialogActions(
          activity: activity,
          feedGroup: feedGroup,
          textEditingController: textEditingController,
        ),
      ],
      content: CommentView(
        activity: activity,
        feedGroup: feedGroup,
        textEditingController: textEditingController,
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView(
      {Key? key,
      this.activity,
      this.feedGroup = 'user',
      required this.textEditingController,
      this.reactions = false})
      : super(key: key);

  final EnrichedActivity? activity;
  final String feedGroup;
  final TextEditingController textEditingController;
  final bool reactions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (activity != null) ...[
            ActivityHeader(activity: activity!, showSubtitle: false),
            ActivityContent(activity: activity!), //TODO: not interactive
            //TODO: analytics
            //TODO: "in response to" activity.to
          ],
          CommentField(
            textEditingController: textEditingController,
            activity: activity,
            enableButton: false,
            feedGroup: feedGroup,
          ),
          //TODO: builder for using it elsewhere than in actions
          // if (reactions)
          //   ReactionsListCore(
          //       onSuccess: (BuildContext context, List<Reaction> reactions) =>
          //           ReactionListInner(reactions: reactions))
        ],
      ),
    );
  }
}

class AlertDialogActions extends StatelessWidget {
  const AlertDialogActions({
    Key? key,
    this.activity,
    this.targetFeeds,
    required this.feedGroup,
    required this.textEditingController,
  }) : super(key: key);
  final EnrichedActivity? activity;
  final List<FeedId>? targetFeeds;
  final String feedGroup;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          LeftActions(), //TODO: upload controller thingy
          RightActions(
            textEditingController: textEditingController,
            activity: activity, //TODO: upload controller thingy
            targetFeeds: targetFeeds,
            feedGroup: feedGroup,
          ),
        ],
      ),
    );
  }
}

class LeftActions extends StatelessWidget {
  const LeftActions({
    Key? key,
    this.spaceBefore = 60,
    this.spaceBetween = 8.0,
  }) : super(key: key);
  final double spaceBefore;
  final double spaceBetween;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: spaceBefore, //TODO: compute this based on media query size
      child: Row(
        children: [
          MediasAction(), //TODO: actions actual emojis, upload images, gif, etc
          SizedBox(width: spaceBetween),
          EmojisAction(),
          SizedBox(width: spaceBetween),
          GIFAction(),
        ],
      ),
    );
  }
}

class RightActions extends StatelessWidget {
  const RightActions({
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
    return Align(
        alignment: Alignment.bottomRight,
        //TODO: Row : show progress (if textInputValue.length> 0) if number of characters restricted
        child: PostCommentButton(
          feedGroup: feedGroup,
          activity: activity,
          targetFeeds: targetFeeds,
          textEditingController: textEditingController,
        ));
  }
}
