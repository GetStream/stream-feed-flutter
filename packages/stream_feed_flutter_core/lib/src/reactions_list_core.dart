import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

//TODO: other things to add to core: FollowListCore, UserListCore

/// The generic version of [ReactionListCore]
///
/// {@macro reactionListCore}
/// {@macro genericParameters}
class GenericReactionListCore<A, Ob, T, Or> extends StatefulWidget {
  //TODO(sacha): in the future we should get rid of the generic bounds and accept a controller instead
  // like we did for UploadController and UploadListCore
  ///{@macro reactionListCore}
  const GenericReactionListCore({
    Key? key,
    required this.reactionsBuilder,
    required this.lookupValue,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const ProgressStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No comments to display'),
    this.lookupAttr = LookupAttribute.activityId,
    this.filter,
    this.flags,
    this.kind,
    this.limit,
  }) : super(key: key);

  /// {@macro reactionsBuilder}
  final ReactionsBuilder reactionsBuilder;

  ///{@macro onErrorWidget}
  final Widget onErrorWidget;

  ///{@macro onProgressWidget}
  final Widget onProgressWidget;

  ///{@macro onEmptyWidget}
  final Widget onEmptyWidget;

  ///{@macro lookupAttr}
  final LookupAttribute lookupAttr;

  /// TODO: document me
  final String lookupValue;

  /// {@macro filter}
  final Filter? filter;

  /// {@macro enrichmentFlags}
  final EnrichmentFlags? flags;

  /// The limit of activities to fetch
  final int? limit;

  /// The kind of reaction, usually i.e 'comment', 'like', 'reaction' etc
  final String? kind;

  @override
  _GenericReactionListCoreState<A, Ob, T, Or> createState() =>
      _GenericReactionListCoreState<A, Ob, T, Or>();
}

class _GenericReactionListCoreState<A, Ob, T, Or>
    extends State<GenericReactionListCore<A, Ob, T, Or>> {
  late GenericFeedBloc<A, Ob, T, Or> bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = GenericFeedProvider<A, Ob, T, Or>.of(context).bloc;
    loadData();
  }

  /// Fetches initial reactions and updates the widget
  Future<void> loadData() => bloc.queryReactions(
        widget.lookupAttr,
        widget.lookupValue,
        filter: widget.filter,
        flags: widget.flags,
        limit: widget.limit,
        kind: widget.kind,
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reaction>>(
        stream: bloc.getReactionsStream(widget.lookupValue, widget.kind),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.onErrorWidget; //snapshot.error
          }
          if (!snapshot.hasData) {
            return widget.onProgressWidget;
          }
          final reactions = snapshot.data!;
          if (reactions.isEmpty) {
            return widget.onEmptyWidget;
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: reactions.length,
            itemBuilder: (context, idx) => widget.reactionsBuilder(
              context,
              reactions,
              idx,
            ),
          );
        });
  }
}
