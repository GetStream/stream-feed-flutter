import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/reaction_theme.dart';
import 'package:stream_feed_flutter/src/utils/tag_detector.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';

/// A widget used for interactive text like mentions, hashtags, and links.
class InteractiveText extends StatelessWidget {
  /// Builds an [InteractiveText].
  const InteractiveText({
    Key? key,
    required this.tagged,
    this.onHashtagTap,
    this.onMentionTap,
  }) : super(key: key);

  /// {@macro mention_callback}
  final OnMentionTap? onMentionTap;

  /// A callback that is invoked when the user clicks on a hashtag.
  final OnHashtagTap? onHashtagTap;

  /// The tagged text we parsed as hashtag, mention, or normal text.
  final TaggedText tagged;

  @override
  Widget build(BuildContext context) {
    switch (tagged.tag) {
      case Tag.normalText:
        return Text(
          '${tagged.text} ',
          style: ReactionTheme.of(context).normalTextStyle,
        );
      case Tag.hashtag:
        return InkWell(
          onTap: () {
            onHashtagTap?.call(tagged.text.trim().replaceFirst('#', ''));
          },
          child: Text(
            tagged.text,
            style: ReactionTheme.of(context).hashtagTextStyle,
          ),
        );
      case Tag.mention:
        return InkWell(
          onTap: () {
            onMentionTap?.call(tagged.text.trim().replaceFirst('@', ''));
          },
          child: Text(
            tagged.text,
            style: ReactionTheme.of(context).mentionTextStyle,
          ),
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(DiagnosticsProperty<TaggedText>('tagged', tagged));
  }
}
