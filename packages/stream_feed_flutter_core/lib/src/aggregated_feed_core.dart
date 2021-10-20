import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

// ignore_for_file: cascade_invocations

/// {@template aggregated_feed_core}
/// A simplified class that allows fetching a list of aggregated activities
/// while exposing UI builders
/// {@endtemplate}
class AggregatedFeedCore<A, Ob, T, Or> extends StatefulWidget {
  /// {@macro aggregated_feed_core}
  const AggregatedFeedCore({
    Key? key,
    required this.feedGroup,
    required this.aggregatedFeedBuilder,
    required this.bloc,
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
        const EmptyStateWidget(message: 'No activities to display'),
  }) : super(key: key);

  /// A builder that let you build a ListView of EnrichedActivity based Widgets
  final EnrichedAggregatedFeedBuilder<A, Ob, T, Or> aggregatedFeedBuilder;

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

  /// The feed bloc for managing state.
  final FeedBloc<A, Ob, T, Or> bloc;

  @override
  _AggregatedFeedCoreState<A, Ob, T, Or> createState() =>
      _AggregatedFeedCoreState<A, Ob, T, Or>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('limit', limit));
    properties.add(IntProperty('offset', offset));
    properties.add(StringProperty('session', session));
    properties.add(DiagnosticsProperty<Filter?>('filter', filter));
    properties.add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags));
    properties.add(StringProperty('ranking', ranking));
    properties.add(StringProperty('userId', userId));
    properties.add(StringProperty('feedGroup', feedGroup));
    properties.add(DiagnosticsProperty<FeedBloc<A, Ob, T, Or>>('bloc', bloc));
    properties.add(
        ObjectFlagProperty<EnrichedAggregatedFeedBuilder<A, Ob, T, Or>>.has(
            'aggregatedFeedBuilder', aggregatedFeedBuilder));
  }
}

class _AggregatedFeedCoreState<A, Ob, T, Or>
    extends State<AggregatedFeedCore<A, Ob, T, Or>> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// Fetches initial activities and updates the widget
  Future<void> loadData() => widget.bloc.queryAggregatedActivities(
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
  Widget build(BuildContext context) {
    return FeedBlocProvider(
      bloc: widget.bloc,
      child: StreamBuilder<List<Group<EnrichedActivity<A, Ob, T, Or>>>>(
        stream: widget.bloc.aggregatedActivitiesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget
                .onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
          }
          if (!snapshot.hasData) {
            return widget.onProgressWidget;
          }
          final aggregatedActivities = snapshot.data!;
          if (aggregatedActivities.isEmpty) {
            return widget.onEmptyWidget;
          }
          return ListView.builder(
            itemCount: aggregatedActivities.length,
            itemBuilder: (context, idx) => widget.aggregatedFeedBuilder(
              context,
              aggregatedActivities,
              idx,
            ),
          );
        },
      ),
    );
  }
}
