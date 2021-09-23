import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/debug.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template reaction_list_page}
/// Renders a list of reactions to a post.
/// {@endtemplate}
class ReactionListPage extends StatelessWidget {
  /// Builds a [ReactionListPage].
  ReactionListPage({
    Key? key,
    required this.activity,
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
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

  /// The activity to display notifications for.
  final DefaultEnrichedActivity activity;

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

  /// The widget to display if there is an error.
  final Widget onErrorWidget;

  /// The widget to display while loading is in progress.
  final Widget onProgressWidget;

  /// The widget to display if there is no data.
  final Widget onEmptyWidget;

  /// The flags to use for the request
  final EnrichmentFlags? flags;

  /// TODO: document me
  final LookupAttribute lookupAttr;

  final String _lookupValue;

  /// TODO: document me
  final Filter? filter;

  /// TODO: document me
  final int? limit;

  /// TODO: document me
  final String? kind;

  @override
  Widget build(BuildContext context) {
    //  debugCheckHasReactionsProvider(context);
    return ReactionListCore(
      bloc: DefaultFeedBlocProvider.of(context).bloc,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EnrichedActivity>('activity', activity));
    properties.add(
        ObjectFlagProperty<OnReactionTap?>.has('onReactionTap', onReactionTap));
    properties.add(
        ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap));
    properties.add(
        ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap));
    properties.add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap));
    properties.add(ObjectFlagProperty<ReactionBuilder>.has(
        'reactionBuilder', reactionBuilder));
    properties.add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags));
    properties.add(EnumProperty<LookupAttribute>('lookupAttr', lookupAttr));
    properties.add(DiagnosticsProperty<Filter?>('filter', filter));
    properties.add(IntProperty('limit', limit));
    properties.add(StringProperty('kind', kind));
  }
}
