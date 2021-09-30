import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

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
  /// {@macro reactionListCore.onErrorWidget}
  final Widget onErrorWidget;

  /// {@macro reactionListCore.onProgressWidget}
  final Widget onProgressWidget;

  /// The widget to display if there is no data.
  final Widget onEmptyWidget;

  /// The flags to use for the request.
  final EnrichmentFlags? flags;

  /// Lookup objects based on attributes.
  final LookupAttribute lookupAttr;

  /// Lookup objects based on string value.
  final String _lookupValue;

  /// {@macro filter}
  final Filter? filter;

  /// The limit of activities to fetch.
  final int? limit;

  /// The kind of reaction.
  final String? kind;

  @override
  Widget build(BuildContext context) {
    return ReactionListCore(
      lookupValue: _lookupValue, // TODO (Sacha): handle null safety
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
    properties
      ..add(DiagnosticsProperty<EnrichedActivity>('activity', activity))
      ..add(ObjectFlagProperty<OnReactionTap?>.has(
          'onReactionTap', onReactionTap))
      ..add(ObjectFlagProperty<OnHashtagTap?>.has('onHashtagTap', onHashtagTap))
      ..add(ObjectFlagProperty<OnMentionTap?>.has('onMentionTap', onMentionTap))
      ..add(ObjectFlagProperty<OnUserTap?>.has('onUserTap', onUserTap))
      ..add(ObjectFlagProperty<ReactionBuilder>.has(
          'reactionBuilder', reactionBuilder))
      ..add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags))
      ..add(EnumProperty<LookupAttribute>('lookupAttr', lookupAttr))
      ..add(DiagnosticsProperty<Filter?>('filter', filter))
      ..add(IntProperty('limit', limit))
      ..add(StringProperty('kind', kind));
  }
}
