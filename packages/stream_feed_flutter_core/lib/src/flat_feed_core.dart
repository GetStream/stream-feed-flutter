import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// [FlatFeedCore] is a simplified class that allows fetching a list of
/// enriched activities (flat) while exposing UI builders.
///
///
/// ```dart
/// class FlatActivityListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: FlatFeedCore(
///         onErrorWidget: Center(
///             child: Text('An error has occured'),
///         ),
///         onEmptyWidget: Center(
///             child: Text('Nothing here...'),
///         ),
///         onProgressWidget: Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, activties, idx) {
///           return YourActivityWidget(activity: activities[idx]);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [StreamFeedCore] ancestor in order to provide the
/// information about the activities.
class FlatFeedCore<A, Ob> extends StatelessWidget {
  const FlatFeedCore(
      {Key? key,
      required this.feedGroup,
      required this.feedBuilder,
      this.onErrorWidget = const ErrorStateWidget(),
      this.onProgressWidget = const ProgressStateWidget(),
      this.limit,
      this.offset,
      this.session,
      this.filter,
      this.flags,
      this.ranking,
      this.userId,
      this.onEmptyWidget =
          const EmptyStateWidget(message: 'No activties to display')})
      : super(key: key);

  /// A builder that let you build a ListView of EnrichedActivity based Widgets
  final EnrichedFeedBuilder<A, Ob> feedBuilder;

  /// An error widget to show when an error occurs
  final Widget onErrorWidget;

  /// A progress widget to show when a request is in progress
  final Widget onProgressWidget;

  /// A widget to show when the feed is empty
  final Widget onEmptyWidget;

  /// The limit of activities to fetch
  final int? limit;

  /// The offset of activities to fetch
  final int? offset;

  /// The session to use for the request
  final String? session;

  /// The filter to use for the request
  final Filter? filter;

  /// The flags to use for the request
  final EnrichmentFlags? flags;

  /// The ranking to use for the request
  final String? ranking;

  /// The user id to use for the request
  final String? userId;

  /// The feed group to use for the request
  final String feedGroup;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StreamFeedCore.of(context).getEnrichedActivities<A, Ob>(
        feedGroup: feedGroup,
        limit: limit,
        offset: offset,
        session: session,
        filter: filter,
        flags: flags,
        ranking: ranking,
        userId: userId,
      ),
      builder:
          (context, AsyncSnapshot<List<EnrichedActivity<A, Ob>>> snapshot) {
        if (snapshot.hasError) {
          return onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
        }
        if (!snapshot.hasData) {
          return onProgressWidget;
        }
        final activities = snapshot.data!;
        if (activities.isEmpty) {
          return onEmptyWidget;
        }
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, idx) => feedBuilder(
            context,
            activities,
            idx,
          ),
        );
      },
    );
  }
}
