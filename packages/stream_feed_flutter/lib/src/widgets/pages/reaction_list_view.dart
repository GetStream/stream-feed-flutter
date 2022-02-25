import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/default/default.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template reaction_list_page}
/// Renders a list of reactions to a post.
/// {@endtemplate}
class ReactionListView extends StatelessWidget {
  /// Builds a [ReactionListView].
  ReactionListView({
    Key? key,
    required this.activity,
    this.onReactionTap,
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    required this.reactionBuilder,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const LoadingStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No comments to display'),
    this.flags,
    this.lookupAttr = LookupAttribute.activityId,
    String? lookupValue,
    this.filter,
    this.limit,
    this.kind,
    this.scrollPhysics,
  })  : _lookupValue = lookupValue ?? activity.id!,
        super(key: key);

  /// The activity to display notifications for.
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

  /// The widget to display if there is an error.
  final Widget onErrorWidget;

  /// The widget to display while loading is in progress.
  final Widget onProgressWidget;

  /// The widget to display if there is no data.
  final Widget onEmptyWidget;

  /// The flags to use for the request
  final EnrichmentFlags? flags;

  final LookupAttribute lookupAttr;

  final String _lookupValue;

  final Filter? filter;

  final int? limit;

  final String? kind;

  final ScrollPhysics? scrollPhysics;
  @override
  Widget build(BuildContext context) {
    //  debugCheckHasReactionsProvider(context);
    return ReactionListCore(
      lookupValue: _lookupValue, //TODO: handle null safety
      loadingBuilder: (context) => onProgressWidget,
      errorBuilder: (context, error) => onErrorWidget,
      emptyBuilder: (context) => onEmptyWidget,
      flags: flags,
      filter: filter,
      kind: kind,
      lookupAttr: lookupAttr,
      limit: limit,
      reactionsBuilder: (context, reactions) {
        return ListView.builder(
          itemCount: reactions.length,
          itemBuilder: (context, index) {
            return reactionBuilder(context, reactions[index]);
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<GenericEnrichedActivity>('activity', activity));
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
