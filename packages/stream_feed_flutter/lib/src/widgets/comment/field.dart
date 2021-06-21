import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/text.dart';
import 'package:stream_feed_flutter/src/widgets/comment/textarea.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class CommentField extends StatefulWidget {
  final EnrichedActivity? activity;
  final List<FeedId>? targetFeeds;

  ///The feed group part of the feed
  final String feedGroup;

  CommentField({
    Key? key,
    required this.feedGroup,
    this.activity,
    this.targetFeeds,
  }) : super(key: key);

  @override
  CommentFieldState createState() => CommentFieldState();
}

class CommentFieldState extends State<CommentField> {
  late String text;

  @override
  Widget build(BuildContext context) {
    final streamFeed = StreamFeedCore.of(context);

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
              child: TextArea(onSubmitted: (value) {
                setState(() {
                  text = value;
                });//TODO: value notifier
              }),
            ),
          ],
        ),
        StyledTextButton(
            //TODO; add way to customize button
            label: 'Post',
            onPressed: () async {
              widget.activity != null
                  ? await streamFeed.onAddReaction(
                      kind: 'comment',
                      activity: widget.activity!,
                      data: {'text': text}, //TODO: key
                      targetFeeds: widget.targetFeeds,
                      feedGroup: widget.feedGroup,
                    )
                  : await streamFeed.onAddActivity(
                      feedGroup: widget.feedGroup, data: {'text': text});
            },
            type: ButtonType.faded)
      ],
    );
  }
}
