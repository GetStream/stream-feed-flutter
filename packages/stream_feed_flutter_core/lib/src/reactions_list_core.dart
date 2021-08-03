import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

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
class ReactionListCore extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reaction>>(
        future: StreamFeedCore.of(context).getReactions(
          lookupAttr,
          lookupValue,
          filter: filter,
          flags: flags,
          limit: limit,
          kind: kind,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return onErrorWidget; //snapshot.error
          }
          if (!snapshot.hasData) {
            return onProgressWidget;
          }
          final reactions = snapshot.data!;
          if (reactions.isEmpty) {
            return onEmptyWidget;
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: reactions.length,
            itemBuilder: (context, idx) => reactionsBuilder(
              context,
              reactions,
              idx,
            ),
          );
        });
  }
}
