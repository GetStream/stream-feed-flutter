import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/debug.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template reaction_list_page}
/// Renders a list of reactions to a post.
/// {@endtemplate}
class ReactionListPage extends StatelessWidget {
  ///{@macro reaction_list_page}
  ReactionListPage({
    Key? key,
    required this.activity,
    required this.onReactionTap,
    required this.onHashtagTap,
    required this.onMentionTap,
    required this.onUserTap,
    required this.reactionBuilder,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const ProgressStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No comments to display'),
    this.flags,
    this.lookupAttr = LookupAttribute.activityId,
    String? lookupValue,
    this.filter,
    this.limit,
    this.kind,
  })  : _lookupValue = lookupValue ?? activity.id!,
        super(key: key);

  /// The activity we want to display notifications for.
  final EnrichedActivity activity;

  ///{@macro reaction_callback}
  final OnReactionTap? onReactionTap;

  ///{@macro hashtag_callback}
  final OnHashtagTap? onHashtagTap;

  ///{@macro mention_callback}
  final OnMentionTap? onMentionTap;

  ///{@macro user_callback}
  final OnUserTap? onUserTap;

  /// The callback to invoke when a reaction is added.
  final ReactionBuilder reactionBuilder;

  /// The error widget to display if there is an error.
  final Widget onErrorWidget;

  /// The progress widget to display if there is a progress.
  final Widget onProgressWidget;

  /// The empty widget to display if there is no data.
  final Widget onEmptyWidget;

  /// The flags to use for the request
  final EnrichmentFlags? flags;

  final LookupAttribute lookupAttr;
  final String _lookupValue;
  final Filter? filter;
  final int? limit;
  final String? kind;

  @override
  Widget build(BuildContext context) {
    //  debugCheckHasReactionsProvider(context);
    return ReactionListCore(
      bloc: FeedBlocProvider.of(context).bloc,
      lookupValue: _lookupValue, //TODO: handle null safety
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      onEmptyWidget: onEmptyWidget,
      flags: flags,
      filter: filter,
      kind: kind,
      lookupAttr: lookupAttr,
      limit: limit,
      reactionsBuilder: (context, reactions, idx) =>
          reactionBuilder(context, reactions[idx]),
    );
  }
}
