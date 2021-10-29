import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// [GenericFlatFeedCore] is a simplified class that allows fetching a list of
/// enriched activities (flat) while exposing UI builders.
///
///
/// ```dart
/// class FlatActivityListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: GenericFlatFeedCore(
///         onErrorWidget: Center(
///             child: Text('An error has occurred'),
///         ),
///         onEmptyWidget: Center(
///             child: Text('Nothing here...'),
///         ),
///         onProgressWidget: Center(
///             child: CircularProgressIndicator(),
///         ),
///         feedBuilder: (context, activities, idx) {
///           return YourActivityWidget(activity: activities[idx]);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [GenericFeedProvider] ancestor in order to provide the
/// information about the activities.
class GenericFlatFeedCore<A, Ob, T, Or> extends StatefulWidget {
  const GenericFlatFeedCore(
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
          const EmptyStateWidget(message: 'No activities to display')})
      : super(key: key);

  /// A builder that let you build a ListView of EnrichedActivity based Widgets
  final EnrichedFeedBuilder<A, Ob, T, Or> feedBuilder;

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
  _GenericFlatFeedCoreState<A, Ob, T, Or> createState() =>
      _GenericFlatFeedCoreState<A, Ob, T, Or>();
}

class _GenericFlatFeedCoreState<A, Ob, T, Or>
    extends State<GenericFlatFeedCore<A, Ob, T, Or>> {
  late GenericFeedBloc<A, Ob, T, Or> bloc;

  /// Fetches initial reactions and updates the widget
  Future<void> loadData() => bloc.queryEnrichedActivities(
        feedGroup: widget.feedGroup,
        limit: widget.limit,
        offset: widget.offset,
        session: widget.session,
        filter: widget.filter,
        flags: widget.flags,
        ranking: widget.ranking,
        userId: widget.userId,
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc = GenericFeedProvider<A, Ob, T, Or>.of(context).bloc;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GenericEnrichedActivity<A, Ob, T, Or>>>(
      stream: GenericFeedProvider<A, Ob, T, Or>.of(context)
          .bloc
          .getActivitiesStream(widget.feedGroup),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget
              .onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
        }
        if (!snapshot.hasData) {
          return widget.onProgressWidget;
        }
        final activities = snapshot.data!;
        if (activities.isEmpty) {
          return widget.onEmptyWidget;
        }
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, idx) => widget.feedBuilder(
            context,
            activities,
            idx,
          ),
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<GenericFeedBloc<A, Ob, T, Or>>('bloc', bloc));
  }
}
