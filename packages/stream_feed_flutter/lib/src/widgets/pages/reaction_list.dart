
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionListPage extends StatelessWidget {
  const ReactionListPage(
      {Key? key,
      required this.feedGroup,
      required this.activity,
      required this.onReactionTap,
      required this.onHashtagTap,
      required this.onMentionTap,
      required this.onUserTap,
      required this.onReaction,
      this.onErrorWidget = const ErrorStateWidget(),
      this.onProgressWidget = const ProgressStateWidget()})
      : super(key: key);

  final String feedGroup;
  final EnrichedActivity? activity;
  final OnReactionTap? onReactionTap;
  final OnHashtagTap? onHashtagTap;
  final OnMentionTap? onMentionTap;
  final OnUserTap? onUserTap;
  final OnReaction onReaction;
  final Widget onErrorWidget;
  final Widget onProgressWidget;

  @override
  Widget build(BuildContext context) {
    return ReactionListCore(
      feedGroup: feedGroup,
      lookupValue: activity!.id!, //TODO: handle null safety
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      onSuccess: (context, reactions, idx) =>
          onReaction(context, reactions[idx]),
    );
  }
}