import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/comment.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template post_button}
/// A reaction button that displays a post icon.
///
/// Used to post a reply to a post when clicked.
///{@endtemplate}
class PostButton extends StatelessWidget {
  /// Builds a [PostButton].
  const PostButton({
    Key? key,
    this.feedGroup = 'user',
    required this.activity,
    this.reaction,
    this.iconSize = 14,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  final String handleJsonKey;
  final String nameJsonKey;

  /// The group or slug of the feed to post to.
  final String feedGroup;

  /// The activity to post to the feed.
  final DefaultEnrichedActivity activity;

  final Reaction? reaction;

  /// The size of the icon to display.
  final double iconSize;

  int? get count =>
      reaction?.childrenCounts?['comment'] ??
      activity.reactionCounts?['comment'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
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
                        nameJsonKey: nameJsonKey,
                        handleJsonKey: handleJsonKey,
                      ),
                    ));
              },
            );
          },
          icon: StreamSvgIcon.reply(),
        ),
        if (count != null && count! > 0) Text('${count!}')
      ],
    );
  }
}
