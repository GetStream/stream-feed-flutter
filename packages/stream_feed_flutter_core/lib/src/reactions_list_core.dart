import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/bloc.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';

class ReactionListCore
    extends GenericReactionListCore<User, String, String, String> {
  const ReactionListCore({
    Key? key,
    required ReactionsBuilder reactionsBuilder,
    required WidgetBuilder loadingBuilder,
    required WidgetBuilder emptyBuilder,
    required ErrorBuilder errorBuilder,
    LookupAttribute lookupAttr = LookupAttribute.activityId,
    required String lookupValue,
    Filter? filter,
    EnrichmentFlags? flags,
    int? limit,
    String? kind,
  }) : super(
          key: key,
          reactionsBuilder: reactionsBuilder,
          loadingBuilder: loadingBuilder,
          emptyBuilder: emptyBuilder,
          errorBuilder: errorBuilder,
          lookupAttr: lookupAttr,
          lookupValue: lookupValue,
          filter: filter,
          flags: flags,
          limit: limit,
          kind: kind,
        );
}

// TODO: other things to add to core: FollowListCore, UserListCore

/// The generic version of [ReactionListCore]
///
/// {@macro reactionListCore}
/// {@macro genericParameters}
class GenericReactionListCore<A, Ob, T, Or> extends StatefulWidget {
  // TODO(sacha): in the future we should get rid of the generic bounds and
  // accept a controller instead like we did for UploadController and
  // UploadListCore
  ///{@macro reactionListCore}
  const GenericReactionListCore({
    Key? key,
    required this.reactionsBuilder,
    required this.lookupValue,
    required this.loadingBuilder,
    required this.emptyBuilder,
    required this.errorBuilder,
    this.lookupAttr = LookupAttribute.activityId,
    this.filter,
    this.flags,
    this.kind,
    this.limit,
    this.scrollPhysics,
  }) : super(key: key);

  /// {@macro reactionsBuilder}
  final ReactionsBuilder reactionsBuilder;

  /// Callback triggered when an error occurs while performing the given
  /// request.
  ///
  /// This parameter can be used to display an error message to users in the
  /// event of an error occuring fetching the flat feed.
  final ErrorBuilder errorBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder emptyBuilder;

  /// {@macro lookupAttr}
  final LookupAttribute lookupAttr;

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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<ReactionsBuilder>.has(
        'reactionsBuilder', reactionsBuilder));
    properties.add(EnumProperty<LookupAttribute>('lookupAttr', lookupAttr));
    properties.add(
        ObjectFlagProperty<WidgetBuilder>.has('emptyBuilder', emptyBuilder));
    properties.add(IntProperty('limit', limit));
    properties.add(
        DiagnosticsProperty<ScrollPhysics?>('scrollPhysics', scrollPhysics));
    properties.add(StringProperty('kind', kind));
    properties.add(DiagnosticsProperty<Filter?>('filter', filter));
    properties.add(DiagnosticsProperty<EnrichmentFlags?>('flags', flags));
    properties.add(ObjectFlagProperty<WidgetBuilder>.has(
        'loadingBuilder', loadingBuilder));
    properties.add(StringProperty('lookupValue', lookupValue));
    properties.add(
        ObjectFlagProperty<ErrorBuilder>.has('errorBuilder', errorBuilder));
  }
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
  Future<void> loadData() => bloc.refreshPaginatedReactions(
        widget.lookupValue,
        lookupAttr: widget.lookupAttr,
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
          return widget.errorBuilder(
            context,
            snapshot.error!,
          );
        }
        if (!snapshot.hasData) {
          return widget.loadingBuilder(context);
        }
        final reactions = snapshot.data!;
        if (reactions.isEmpty) {
          return widget.emptyBuilder(context);
        }
        return widget.reactionsBuilder(context, reactions);
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
