import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FlatFeedCore extends GenericFlatFeedCore<User, String, String, String> {
  FlatFeedCore({
    required EnrichedFeedBuilder<User, String, String, String> feedBuilder,
    Widget onErrorWidget = const ErrorStateWidget(),
    Widget onProgressWidget = const ProgressStateWidget(),
    Widget onEmptyWidget =
        const EmptyStateWidget(message: 'No activities to display'),
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
    required String feedGroup,
    ScrollPhysics? scrollPhysics,
  }) : super(
          feedBuilder: feedBuilder,
          onErrorWidget: onErrorWidget,
          onProgressWidget: onProgressWidget,
          onEmptyWidget: onEmptyWidget,
          limit: limit,
          offset: offset,
          session: session,
          filter: filter,
          flags: flags,
          ranking: ranking,
          userId: userId,
          feedGroup: feedGroup,
          scrollPhysics: scrollPhysics,
        );
}

/// [GenericFlatFeedCore] is a simplified class that allows fetching a list of
/// enriched activities (flat) while exposing UI builders.
///
/// {@macro flatFeedCore}
/// {@macro genericParameters}
class GenericFlatFeedCore<A, Ob, T, Or> extends StatefulWidget {
  const GenericFlatFeedCore({
    Key? key,
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
        const EmptyStateWidget(message: 'No activities to display'),
    this.scrollPhysics,
  }) : super(key: key);

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

  final ScrollPhysics? scrollPhysics;

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
      stream: bloc.getActivitiesStream(widget.feedGroup),
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
        return ListView.separated(
          physics:
              widget.scrollPhysics ?? const AlwaysScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const Divider(),
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
