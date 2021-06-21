import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/activity_content.dart';
import 'package:stream_feed_flutter/src/activity_header.dart';
import 'package:stream_feed_flutter/src/like_button.dart';
import 'package:stream_feed_flutter/src/repost_button.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivityFooter extends StatelessWidget {
  const ActivityFooter({required this.activity, this.feedGroup = 'user'});
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
  const PostButton(
      {Key? key,
      required this.feedGroup,
      required this.activity,
      this.iconSize = 14})
      : super(key: key);
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

///Opens file explorer
class MediasAction extends StatelessWidget {
  const MediasAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.collections_outlined, //TODO: svg icons
      color: Colors.blue,
      semanticLabel: 'Medias', //TODO: i18n
    );
  }
}

///Opens an emoji dialog
class EmojisAction extends StatelessWidget {
  const EmojisAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.emoji_emotions_outlined, //TODO: svg icons
      color: Colors.blue,
      semanticLabel: 'Emoji', //TODO: i18n
    );
  }
}

///Opens a gif dialog
class GIFAction extends StatelessWidget {
  const GIFAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.blue)),
        child: Icon(
          Icons.gif_outlined, //TODO: svg icons
          color: Colors.blue,
          semanticLabel: 'GIF', //TODO: i18n
        ));
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
