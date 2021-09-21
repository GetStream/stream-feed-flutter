import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter/src/widgets/interactive_text.dart';
import 'package:stream_feed_flutter/src/widgets/og/card.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template activity_content}
/// Displays the content of an activity.
///
/// This would be the actual text of the activity, the media, etc.
/// {@endtemplate}
class ActivityContent extends StatelessWidget {
  /// Builds an [ActivityContent].
  const ActivityContent({
    Key? key,
    required this.activity,
    this.onMentionTap,
    this.commentJsonKey = 'comment',
    this.onHashtagTap,
  }) : super(key: key);

  /// The activity that is being displayed.
  final DefaultEnrichedActivity activity;

  /// A callback to handle mention taps
  final OnMentionTap? onMentionTap;

  /// A callback to handle hashtag taps
  final OnHashtagTap? onHashtagTap;

  /// The json key for the comment
  final String commentJsonKey;

  @override
  Widget build(BuildContext context) {
    final detector = TagDetector(); //TODO: move this higher in the widget tree
    final activityObject = activity.object;
    final attachments =
        activity.extraData?['attachments']; //TODO: attachment builder
    final taggedText = activityObject != null
        ? detector.parseText(activityObject)
        : <TaggedText>[];
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Wrap(
            //TODO: move to Text.rich(WidgetSpans)
            children: taggedText
                .map((it) => InteractiveText(
                      //TODO: not interactive in case of a response
                      tagged: it,
                      onHashtagTap: onHashtagTap,
                      onMentionTap: onMentionTap,
                    ))
                .toList(),
          ),
          //TODO: handle Video + Audio + Gallery
          if (attachments != null)
            ActivityCard(
              og: OpenGraphData.fromJson(attachments as Map<String, dynamic>),
            )
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<DefaultEnrichedActivity>('activity', activity));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(StringProperty('commentJsonKey', commentJsonKey));
  }
}
