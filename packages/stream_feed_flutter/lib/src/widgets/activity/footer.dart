import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/buttons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
/// The Activity Footer is a widget that is used to display the activity footer.
/// i.e. reaction buttons,post,repost,like buttons, etc.
class ActivityFooter extends StatelessWidget {
  const ActivityFooter({
    Key? key,
    required this.activity,
    this.feedGroup = 'user',
  }) : super(key: key);
  final EnrichedActivity activity;
  final String feedGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PostButton(
            activity: activity,
            feedGroup: feedGroup,
          ),
          RepostButton(
            activity: activity,
            feedGroup: feedGroup,
          ),
          LikeButton(
            activity: activity,
            feedGroup: feedGroup,
          ),
        ],
      ),
    );
  }
}
