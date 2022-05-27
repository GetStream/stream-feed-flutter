import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/widgets/buttons/buttons.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template activity_footer}
/// Displays the footer content for an activity.
///
/// This would be reaction buttons, the post, repost, and like buttons, etc.
/// {@endtemplate}
class ActivityFooter extends StatelessWidget {
  ///{@macro activity_footer}
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
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReplyButton(
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EnrichedActivity>('activity', activity));
    properties.add(StringProperty('feedGroup', feedGroup));
  }
}
