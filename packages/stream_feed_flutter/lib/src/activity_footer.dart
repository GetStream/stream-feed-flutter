import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/like_button.dart';
import 'package:stream_feed_flutter/src/repost_button.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivityFooter extends StatelessWidget {
  const ActivityFooter({required this.activity});
  final EnrichedActivity activity;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RepostButton(activity: activity),
        LikeButton(activity: activity),
      ],
    );
  }
}
