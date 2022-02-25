import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// {@template reactionListCore}
/// [ReactionListCore] is a core class that allows fetching a list of
/// reactions while exposing UI builders.
///
/// ## Usage
///
/// ```dart
/// class ReactionListView extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ReactionListCore(
///         onErrorWidget: Center(
///             child: Text('An error has occurred'),
///         ),
///         onEmptyWidget: Center(
///             child: Text('Nothing here...'),
///         ),
///         onProgressWidget: Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, reactions, idx) {
///           return YourReactionWidget(reaction: reactions[idx]);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [FeedProvider] ancestor in order to provide the
/// information about the reactions.
///
/// Usually what you want is the convenient [ReactionListCore] that already
/// has the default parameters defined for you
/// suitable to most use cases. But if you need a
/// more advanced use case use [GenericReactionListCore] instead
/// {@endtemplate}
///
class ReactionListCore
    extends GenericReactionListCore<User, String, String, String> {
  const ReactionListCore({
    Key? key,
    required ReactionsBuilder reactionsBuilder,
    Widget onErrorWidget = const ErrorStateWidget(),
    Widget onProgressWidget = const ProgressStateWidget(),
    Widget onEmptyWidget =
        const EmptyStateWidget(message: 'No comments to display'),
    LookupAttribute lookupAttr = LookupAttribute.activityId,
    required String lookupValue,
    Filter? filter,
    EnrichmentFlags? flags,
    int? limit,
    String? kind,
    ScrollPhysics? scrollPhysics,
  }) : super(
          key: key,
          reactionsBuilder: reactionsBuilder,
          onErrorWidget: onErrorWidget,
          onProgressWidget: onProgressWidget,
          onEmptyWidget: onEmptyWidget,
          lookupAttr: lookupAttr,
          lookupValue: lookupValue,
          filter: filter,
          flags: flags,
          limit: limit,
          kind: kind,
          scrollPhysics: scrollPhysics,
        );
}

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
    this.scrollPhysics,
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

  final ScrollPhysics? scrollPhysics;

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
      stream: bloc.getReactionsStream(widget.lookupValue,
          widget.kind), //reactionsStreamFor(widget.lookupValue)
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
        return ListView.separated(
          shrinkWrap: true,
          itemCount: reactions.length,
          physics: widget.scrollPhysics ?? const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, idx) => widget.reactionsBuilder(
            context,
            reactions,
            idx,
          ),
        );
      },
    );
  }
}
