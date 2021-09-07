import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ReactionsBloc {
  ReactionsBloc({required this.client, this.analyticsClient});
  final StreamFeedClient client;
  final StreamAnalytics? analyticsClient;

  /// The current reactions list
  List<Reaction>? get reactions => _reactionsController.valueOrNull;

  /// The current reactions list as a stream
  Stream<List<Reaction>> get reactionsStream => _reactionsController.stream;

  final _reactionsController = BehaviorSubject<List<Reaction>>();

  final _queryReactionsLoadingController = BehaviorSubject.seeded(false);

  /// The stream notifying the state of queryReactions call
  Stream<bool> get queryReactionsLoading =>
      _queryReactionsLoadingController.stream;

  ///Track analytics
  Future<void> trackAnalytics({
    required String label,
    required String feedGroup,
    String? foreignId,
  }) async {
    analyticsClient != null
        ? await analyticsClient!.trackEngagement(Engagement(
            content: Content(foreignId: FeedId.fromId(foreignId)),
            label: label,
            feedId: FeedId.fromId(feedGroup),
          ))
        : print('warning: analytics: not enabled'); //TODO:logger
  }

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required EnrichedActivity activity,
    List<FeedId>? targetFeeds,
    required String feedGroup,
  }) async {
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    return reaction;
  }

  ///Add child reaction
  Future<Reaction> onAddChildReaction(
      {required String kind,
      required Reaction reaction,
      Map<String, Object>? data,
      String? userId,
      List<FeedId>? targetFeeds}) async {
    final childReaction = await client.reactions.addChild(kind, reaction.id!,
        data: data, userId: userId, targetFeeds: targetFeeds);
    return childReaction;
  }

  // Future<Reaction> onAddChildReaction(
  //     {required String kind,
  //     required Reaction reaction,
  //     Map<String, Object>? data,
  //     String? userId,
  //     List<FeedId>? targetFeeds}) async {
  //   final client = _streamFeedCore.client;
  //   final childReaction = await client.reactions.addChild(kind, reaction.id!,
  //       data: data, userId: userId, targetFeeds: targetFeeds);

  //   final path = getReactionPath(reaction);
  //   var count = path.childrenCounts?[kind] ?? 0;
  //   count += 1;
  //   final ownReactions = reaction.ownChildren?[kind];
  //   final reactionsKind = ownReactions?.filterByKind(kind);
  //   var alreadyReacted = reactionsKind?.isNotEmpty != null;
  //   var idToRemove = reactionsKind?.last?.id;

  // }

  Future<void> queryReactions(LookupAttribute lookupAttr, String lookupValue,
      {Filter? filter,
      int? limit,
      String? kind,
      EnrichmentFlags? flags}) async {
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

  void dispose() {
    _reactionsController.close();
    _queryReactionsLoadingController.close();
  }
}

class ReactionsProvider extends InheritedWidget {
  const ReactionsProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }) : super(key: key, child: child);

  final ReactionsBloc bloc;

  static ReactionsProvider of(BuildContext context) {
    final ReactionsProvider? result =
        context.dependOnInheritedWidgetOfExactType<ReactionsProvider>();
    assert(result != null, 'No ReactionsBloc found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ReactionsProvider old) => bloc != old.bloc;
}
