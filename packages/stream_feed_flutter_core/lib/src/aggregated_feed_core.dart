import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';

/// A simplified class that allows fetching a list of enriched activities
/// (aggregated) while exposing UI builders.
///
/// [AggregatedFeedCore] extends [GenericAggregatedFeedCore] with default types
/// of:
/// - [User], [String], [String], [String].
///
/// Under most circumstances [AggregatedFeedCore] is all you need to use.
///
/// {@macro AggregatedFeedCore}
class AggregatedFeedCore
    extends GenericAggregatedFeedCore<User, String, String, String> {
  /// Instantiates a new [AggregatedFeedCore].
  const AggregatedFeedCore({
    Key? key,
    required AggregatedFeedBuilder<User, String, String, String> feedBuilder,
    required WidgetBuilder loadingBuilder,
    required WidgetBuilder emptyBuilder,
    required ErrorBuilder errorBuilder,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? userId,
    required String feedGroup,
  }) : super(
          key: key,
          feedBuilder: feedBuilder,
          loadingBuilder: loadingBuilder,
          emptyBuilder: emptyBuilder,
          errorBuilder: errorBuilder,
          limit: limit,
          offset: offset,
          session: session,
          filter: filter,
          flags: flags,
          userId: userId,
          feedGroup: feedGroup,
        );
}

/// [GenericAggregatedFeedCore] is a simplified class that allows fetching a
/// list of enriched activities (aggregated) while exposing UI builders.
///
/// {@macro AggregatedFeedCore}
/// {@macro genericParameters}
class GenericAggregatedFeedCore<A, Ob, T, Or> extends StatefulWidget {
  /// Create a new [GenericFlatFeedCore].
  const GenericAggregatedFeedCore({
    Key? key,
    required this.feedGroup,
    required this.feedBuilder,
    required this.loadingBuilder,
    required this.emptyBuilder,
    required this.errorBuilder,
    this.limit,
    this.offset,
    this.session,
    this.filter,
    this.flags,
    this.userId,
  }) : super(key: key);

  /// A builder that provides a list of Group<EnrichedActivities> to display
  final AggregatedFeedBuilder<A, Ob, T, Or> feedBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// Callback triggered when an error occurs while performing the given
  /// request.
  ///
  /// This parameter can be used to display an error message to users in the
  /// event of an error occuring fetching the flat feed.
  final ErrorBuilder errorBuilder;

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

  /// The user id to use for the request
  final String? userId;

  /// The feed group to use for the request
  final String feedGroup;

  @override
  _GenericAggregatedFeedCoreState<A, Ob, T, Or> createState() =>
      _GenericAggregatedFeedCoreState<A, Ob, T, Or>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<AggregatedFeedBuilder<A, Ob, T, Or>>.has(
          'feedBuilder', feedBuilder))
      ..add(ObjectFlagProperty<WidgetBuilder>.has(
          'loadingBuilder', loadingBuilder))
      ..add(StringProperty('feedGroup', feedGroup))
      ..add(IntProperty('limit', limit))
      ..add(DiagnosticsProperty<Filter?>('filter', filter))
      ..add(StringProperty('userId', userId))
      ..add(StringProperty('session', session))
      ..add(IntProperty('offset', offset))
      ..add(ObjectFlagProperty<ErrorBuilder>.has('errorBuilder', errorBuilder))
      ..add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags))
      ..add(
          ObjectFlagProperty<WidgetBuilder>.has('emptyBuilder', emptyBuilder));
  }
}

class _GenericAggregatedFeedCoreState<A, Ob, T, Or>
    extends State<GenericAggregatedFeedCore<A, Ob, T, Or>> {
  late GenericFeedBloc<A, Ob, T, Or> bloc;

  /// Fetches initial paginated enriched activities and updates the widget
  Future<void> loadData() => bloc.refreshPaginatedGroupedActivities(
        feedGroup: widget.feedGroup,
        limit: widget.limit,
        offset: widget.offset,
        session: widget.session,
        filter: widget.filter,
        flags: widget.flags,
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
    return StreamBuilder<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>(
      stream: bloc.getGroupedActivitiesStream(widget.feedGroup),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder(context, snapshot.error!);
        }
        if (!snapshot.hasData) {
          return widget.loadingBuilder(context);
        }
        final activities = snapshot.data!;
        if (activities.isEmpty) {
          return widget.emptyBuilder(context);
        }
        return widget.feedBuilder(context, activities);
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
