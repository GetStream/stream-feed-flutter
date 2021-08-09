
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionsBloc extends StatefulWidget {
  /// Instantiate a new [UsersBloc]. The parameter [child] must be supplied and
  /// not null.
  const ReactionsBloc({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget child
  final Widget child;

  @override
  ReactionsBlocState createState() => ReactionsBlocState();

  /// Use this method to get the current [ReactionsBlocState] instance
  static ReactionsBlocState of(BuildContext context) {
    ReactionsBlocState? state;

    state = context.findAncestorStateOfType<ReactionsBlocState>();

    assert(
      state != null,
      'You must have a ReactionsBloc widget as ancestor',
    );

    return state!;
  }
}

/// The current state of the [ReactionsBloc]
class ReactionsBlocState extends State<ReactionsBloc>
    with AutomaticKeepAliveClientMixin {
  /// The current users list
  List<Reaction>? get reactions => _reactionsController.valueOrNull;

  /// The current users list as a stream
  Stream<List<Reaction>> get reactionsStream => _reactionsController.stream;

  final _reactionsController = BehaviorSubject<List<Reaction>>();

  final _queryReactionsLoadingController = BehaviorSubject.seeded(false);

  /// The stream notifying the state of queryUsers call
  Stream<bool> get queryReactionsLoading =>
      _queryReactionsLoadingController.stream;

  late StreamFeedCoreState _streamFeedCore;

  Future<void> queryReactions(LookupAttribute lookupAttr, String lookupValue,
      {Filter? filter,
      int? limit,
      String? kind,
      EnrichmentFlags? flags}) async {
    final client = _streamFeedCore.client;

    if (_queryReactionsLoadingController.value == true) return;

    if (_reactionsController.hasValue) {
      _queryReactionsLoadingController.add(true);
    }

    try {
      final oldReactions = List<Reaction>.from(reactions ?? []);
      final reactionsResponse = await client.reactions.filter(
        lookupAttr,
        lookupValue,
        filter: filter,
        flags: flags,
        limit: limit,
        kind: kind,
      );
      final temp = oldReactions + reactionsResponse;
      _reactionsController.add(temp);
    } catch (e, stk) {
      // reset loading controller
      _queryReactionsLoadingController.add(false);
      if (_reactionsController.hasValue) {
        _queryReactionsLoadingController.addError(e, stk);
      } else {
        _reactionsController.addError(e, stk);
      }
    }
  }

  @override
  void didChangeDependencies() {
    _streamFeedCore = StreamFeedCore.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  void dispose() {
    _reactionsController.close();
    _queryReactionsLoadingController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
