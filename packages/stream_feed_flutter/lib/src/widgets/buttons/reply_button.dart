import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/pages/compose_screen.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template reply_button}
/// A reaction button that displays a post icon.
///
/// Used to post a reply to a post when clicked.
/// {@endtemplate}
class ReplyButton extends StatelessWidget {
  /// Builds a [ReplyButton].
  const ReplyButton({
    Key? key,
    this.feedGroup = 'user',
    required this.activity,
    this.reaction,
    this.iconSize = 14,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
  }) : super(key: key);

  /// TODO: document me
  final String handleJsonKey;

  /// TODO: document me
  final String nameJsonKey;

  /// The group or slug of the feed to post to.
  final String feedGroup;

  /// The activity to post to the feed.
  final EnrichedActivity activity;

  /// TODO: document me
  final Reaction? reaction;

  /// The size of the icon to display.
  final double iconSize;

  /// TODO: document me
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ComposeScreen(
                  parentActivity: activity,
                  feedGroup: feedGroup,
                  textEditingController: TextEditingController(),
                ),
                fullscreenDialog: true,
              ),
            );
          },
          icon: StreamSvgIcon.reply(
            color: StreamFeedTheme.of(context).primaryIconTheme.color,
          ),
        ),
        if (count != null && count! > 0) Text('${count!}')
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('handleJsonKey', handleJsonKey));
    properties.add(StringProperty('nameJsonKey', nameJsonKey));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(DiagnosticsProperty<EnrichedActivity>('activity', activity));
    properties.add(DiagnosticsProperty<Reaction?>('reaction', reaction));
    properties.add(DoubleProperty('iconSize', iconSize));
    properties.add(IntProperty('count', count));
  }
}
