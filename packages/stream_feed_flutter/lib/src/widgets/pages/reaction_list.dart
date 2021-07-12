import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// Renders a list of reactions to a post.
class ReactionListPage extends StatelessWidget {
  const ReactionListPage(
      {Key? key,
      required this.feedGroup,
      required this.activity,
      required this.onReactionTap,
      required this.onHashtagTap,
      required this.onMentionTap,
      required this.onUserTap,
      required this.reactionBuilder,
      this.onErrorWidget = const ErrorStateWidget(),
      this.onProgressWidget = const ProgressStateWidget(),
      this.onEmptyWidget =
          const EmptyStateWidget(message: 'No comments to display')})
      : super(key: key);

  /// The group/slug of the feed we want to display notifications for.
  final String feedGroup;

  /// The activity we want to display notifications for.
  final EnrichedActivity? activity;

  /// The callback to invoke when a reaction is tapped.
  final OnReactionTap? onReactionTap;

  /// The callback to invoke when a hashtag is tapped.
  final OnHashtagTap? onHashtagTap;

  /// The callback to invoke when a mention is tapped.
  final OnMentionTap? onMentionTap;

  /// The callback to invoke when a user is tapped.
  final OnUserTap? onUserTap;

  /// The callback to invoke when a reaction is added.
  final ReactionBuilder reactionBuilder;

  /// The error widget to display if there is an error.
  final Widget onErrorWidget;

  /// The progress widget to display if there is a progress.
  final Widget onProgressWidget;

  /// The empty widget to display if there is no data.
  final Widget onEmptyWidget;

  @override
  Widget build(BuildContext context) {
    return ReactionListCore(
      feedGroup: feedGroup,
      lookupValue: activity!.id!, //TODO: handle null safety
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      onEmptyWidget: onEmptyWidget,
      reactionsBuilder: (context, reactions, idx) =>
          reactionBuilder(context, reactions[idx]),
    );
  }
}
