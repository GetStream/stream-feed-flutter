import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';

/// A simplified class that allows fetching a list of enriched activities (flat)
/// while exposing UI builders.
///
/// [FlatFeedCore] extends [GenericFlatFeedCore] with default types of:
/// - [User], [String], [String], [String].
///
/// Under most circumstances [FlatFeedCore] is all you need to use.
///
/// {@macro flatFeedCore}
class FlatFeedCore extends GenericFlatFeedCore<User, String, String, String> {
  /// Instantiates a new [FlatFeedCore].
  const FlatFeedCore({
    Key? key,
    required EnrichedFeedBuilder<User, String, String, String> feedBuilder,
    required WidgetBuilder loadingBuilder,
    required WidgetBuilder emptyBuilder,
    required ErrorBuilder errorBuilder,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
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
          ranking: ranking,
          userId: userId,
          feedGroup: feedGroup,
        );
}

/// [GenericFlatFeedCore] is a simplified class that allows fetching a list of
/// enriched activities (flat) while exposing UI builders.
///
/// {@macro flatFeedCore}
/// {@macro genericParameters}
class GenericFlatFeedCore<A, Ob, T, Or> extends StatefulWidget {
  /// Create a new [GenericFlatFeedCore].
  const GenericFlatFeedCore({
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
    this.ranking,
    this.userId,
  }) : super(key: key);

  /// A builder that provides a list of EnrichedActivities to display
  final EnrichedFeedBuilder<A, Ob, T, Or> feedBuilder;

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

  /// The ranking to use for the request
  final String? ranking;

  /// The user id to use for the request
  final String? userId;

  /// The feed group to use for the request
  final String feedGroup;

  @override
  _GenericFlatFeedCoreState<A, Ob, T, Or> createState() =>
      _GenericFlatFeedCoreState<A, Ob, T, Or>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<EnrichedFeedBuilder<A, Ob, T, Or>>.has(
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
      ..add(StringProperty('ranking', ranking))
      ..add(
          ObjectFlagProperty<WidgetBuilder>.has('emptyBuilder', emptyBuilder));
  }
}

class _GenericFlatFeedCoreState<A, Ob, T, Or>
    extends State<GenericFlatFeedCore<A, Ob, T, Or>> {
  late GenericFeedBloc<A, Ob, T, Or> bloc;

  /// Fetches initial paginated enriched activities and updates the widget
  Future<void> loadData() => bloc.refreshPaginatedEnrichedActivities(
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
