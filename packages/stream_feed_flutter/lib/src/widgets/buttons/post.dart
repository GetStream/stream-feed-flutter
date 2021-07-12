import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
///The Post Button is a reaction button that displays a post icon.
///It is used to post a comment to a post when clicked.
class PostButton extends StatelessWidget {
  const PostButton({
    Key? key,
    this.feedGroup = 'user',
    required this.activity,
    this.iconSize = 14,
  }) : super(key: key);
  final String feedGroup;
  final EnrichedActivity activity;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: iconSize + 4,
      iconSize: iconSize,
      hoverColor: Colors.blue.shade100,
      onPressed: () {
        showDialog<void>(
          //TODO: switch (await showDialog<Delete/Register>
          context: context,
          builder: (_) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: StreamFeedCore(
                  //TODO: there might be a better way to do this
                  client: StreamFeedCore.of(context).client,
                  child: AlertDialogComment(
                    activity: activity,
                    feedGroup: feedGroup,
                  ),
                ));
          },
        );
      },
      icon: StreamSvgIcon.post(),
    );
  }
}
