import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/reactions_bloc.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
import 'package:rxdart/rxdart.dart';

//TODO: other things to add to core: FollowListCore, UserListCore

/// [ReactionListCore] is a simplified class that allows fetching a list of
/// reactions while exposing UI builders.
///
///
/// ```dart
/// class FlatActivityListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ReactionListCore(
///         onErrorWidget: Center(
///             child: Text('An error has occured'),
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
/// Make sure to have a [StreamFeedCore] ancestor in order to provide the
/// information about the reactions.
class ReactionListCore extends StatefulWidget {
  const ReactionListCore({
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

  /// A builder that allows building a ListView of Reaction based Widgets
  final ReactionsBuilder reactionsBuilder;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

  final LookupAttribute lookupAttr;
  final String lookupValue;
  final Filter? filter;
  final EnrichmentFlags? flags;
  final int? limit;
  final String? kind;

  @override
  State<ReactionListCore> createState() => _ReactionListCoreState();
}

class _ReactionListCoreState extends State<ReactionListCore>
    with WidgetsBindingObserver {
  ReactionsBlocState? _reactionsBloc;

  @override
  void didChangeDependencies() {
    final newReactionsBloc = ReactionsBloc.of(context);
    if (newReactionsBloc != _reactionsBloc) {
      _reactionsBloc = newReactionsBloc;
      loadData();
    }
    super.didChangeDependencies();
  }

  /// Fetches initial users and updates the widget
  Future<void> loadData() => _reactionsBloc!.queryReactions(
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
        stream: _reactionsBloc!.reactionsStream,
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
