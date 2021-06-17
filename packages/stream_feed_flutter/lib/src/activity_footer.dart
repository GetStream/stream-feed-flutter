import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/activity_content.dart';
import 'package:stream_feed_flutter/src/activity_header.dart';
import 'package:stream_feed_flutter/src/like_button.dart';
import 'package:stream_feed_flutter/src/repost_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivityFooter extends StatelessWidget {
  const ActivityFooter({required this.activity, required this.feedGroup});
  final EnrichedActivity activity;
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PostButton(activity: activity, feedGroup: feedGroup),
          RepostButton(activity: activity),
          LikeButton(activity: activity),
        ],
      ),
    );
  }
}

class PostButton extends StatelessWidget {
  const PostButton({
    Key? key,
    required this.feedGroup,
    required this.activity,
  }) : super(key: key);
  final String feedGroup;
  final EnrichedActivity activity;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: StreamDialogComment(
                    activity: activity,
                    feedGroup: feedGroup,
                  ));
            },
          );
        },
        icon: StreamSvgIcon.post());
  }
}

class StreamDialogComment extends StatelessWidget {
  const StreamDialogComment({
    Key? key,
    this.activity,
    required this.feedGroup,
  }) : super(key: key);
  final String feedGroup;
  final EnrichedActivity? activity;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          if (activity != null) ...[
            ActivityHeader(activity: activity!),
            ActivityContent(activity: activity!),
            //TODO: "in response to" activity.to
          ],
          CommentField(activity: activity, feedGroup: feedGroup)
        ],
      ),

      //TODO: actions emojis, upload images, gif, etc
    );
  }
}
