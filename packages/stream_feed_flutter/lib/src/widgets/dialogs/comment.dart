

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity_content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/activity_header.dart';
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
    return AlertDialog(
      actions: [
        AlertDialogActions(),
      ],
      content: CommentView(activity: activity, feedGroup: feedGroup),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView({
    Key? key,
    required this.activity,
    required this.feedGroup,
  }) : super(key: key);

  final EnrichedActivity? activity;
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (activity != null) ...[
            ActivityHeader(activity: activity!, showSubtitle: false),
            ActivityContent(activity: activity!), //TODO: not interactive
            //TODO: "in response to" activity.to
          ],
          CommentField(activity: activity, feedGroup: feedGroup)
        ],
      ),
    );
  }
}

class AlertDialogActions extends StatelessWidget {
  const AlertDialogActions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          LeftActions(),
          RightActions(),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        //TODO: Row : show progress (if textInputValue.length> 0) if number of characters restricted
        child: ElevatedButton(
            // Dis/enabled button if textInputValue.length> 0
            onPressed: () {},
            child: const Text(
              'Post', //Respond //TODO: i18n
            )));
  }
}
