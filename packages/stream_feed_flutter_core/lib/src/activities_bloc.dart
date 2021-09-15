import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef DefaultFeedBloc
    = FeedBloc<User, String, String, String>;

class FeedBloc<A, Ob, T, Or> {
  FeedBloc({required this.client, this.analyticsClient});

  final StreamFeedClient client;

  final StreamAnalytics? analyticsClient;

  /// The current activities list
  List<EnrichedActivity<A, Ob, T, Or>>? get activities =>
      _activitiesController.valueOrNull;

  /// The current reactions list
  List<Reaction> reactionsFor(String activityId, [Reaction? reaction]) =>
      _reactionsControllers[activityId]?.valueOrNull ??
      (reaction != null ? [reaction] : []);

  // void set updateactivities(List<EnrichedActivity> newActivities) =>
  //     _activitiesController.value = newActivities;

  /// The current activities list as a stream
  Stream<List<EnrichedActivity<A, Ob, T, Or>>> get activitiesStream =>
      _activitiesController.stream;

  /// The current reactions list as a stream
  Stream<List<Reaction>>? reactionsStreamFor(
          String activityId) => //TODO: better name
      _reactionsControllers[activityId]?.stream;

  final _reactionsControllers = Map<String, BehaviorSubject<List<Reaction>>>();

  final _activitiesController =
      BehaviorSubject<List<EnrichedActivity<A, Ob, T, Or>>>();

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

  final _queryReactionsLoadingControllers =
      Map<String, BehaviorSubject<bool>>();

  /// The stream notifying the state of queryReactions call
  Stream<bool> queryReactionsLoadingFor(String activityId) =>
      _queryReactionsLoadingControllers[activityId]!;

  /// The stream notifying the state of queryActivities call
  Stream<bool> get queryActivitiesLoading =>
      _queryActivitiesLoadingController.stream;

  /// Add an activity to the feed.
  Future<Activity> onAddActivity(
      //TODO: add this to the stream
      {required String feedGroup,
      Map<String, String>? data,
      required String verb,
      required String object,
      String? userId}) async {
    final activity = Activity(
      actor: client.currentUser?.ref,
      verb: verb,
      object: object,
      extraData: data,
    );

    final addedActivity =
        await client.flatFeed(feedGroup, userId).addActivity(activity);
    //TODO: add activity to the stream
    await trackAnalytics(
      label: 'post',
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value
    return addedActivity;
  }

  /// Remove child reaction
  Future<void> onRemoveChildReaction(
      //TODO: remove this to from the stream
      {
    required String kind,
    required EnrichedActivity activity,
    required Reaction reaction,
  }) async {
    await client.reactions.delete(reaction.id!);
    print(reaction);
    final _reactions = reactionsFor(activity.id!, reaction);
    final reactionPath = _reactions.getReactionPath(reaction);
    final indexPath = _reactions
        .indexWhere((r) => r.id! == reaction.id); //TODO: handle null safety
    print("indexPath: $indexPath");
    print("_reactions: $_reactions");
    final childrenCounts =
        reactionPath.childrenCounts.unshiftByKind(kind, ShiftType.decrement);
    print("childrenCounts: $childrenCounts");
    final latestChildren = reactionPath.latestChildren
        .unshiftByKind(kind, reaction, ShiftType.decrement);
    final ownChildren = reactionPath.ownChildren
        .unshiftByKind(kind, reaction, ShiftType.decrement);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownChildren,
      latestChildren: latestChildren,
      childrenCounts: childrenCounts,
    );
    print("reaction: $updatedReaction");

    //adds reaction to the stream
    // _reactionsControllers.unshiftById(activity.id!, reaction);

    if (_reactionsControllers[activity.id!]?.hasValue != null) {
      _reactionsControllers[activity.id!]!.value =
          _reactions.updateIn(updatedReaction, indexPath);
    }
  }

  Future<Reaction> onAddChildReaction(
      //TODO: add this to the stream
      {required String kind,
      required Reaction reaction,
      required EnrichedActivity activity,
      Map<String, Object>? data,
      String? userId,
      List<FeedId>? targetFeeds}) async {
    final childReaction = await client.reactions.addChild(kind, reaction.id!,
        data: data, userId: userId, targetFeeds: targetFeeds);
    final _reactions = reactionsFor(activity.id!, reaction);
    final reactionPath = _reactions.getReactionPath(reaction);
    final indexPath = _reactions
        .indexWhere((r) => r.id! == reaction.id); //TODO: handle null safety

    final childrenCounts = reactionPath.childrenCounts.unshiftByKind(kind);
    final latestChildren =
        reactionPath.latestChildren.unshiftByKind(kind, reaction);
    final ownChildren = reactionPath.ownChildren.unshiftByKind(kind, reaction);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownChildren,
      latestChildren: latestChildren,
      childrenCounts: childrenCounts,
    );

    //adds reaction to the stream
    // _reactionsControllers.unshiftById(activity.id!, reaction);

    if (_reactionsControllers[activity.id!]?.hasValue != null) {
      _reactionsControllers[activity.id!]!.value =
          _reactions.updateIn(updatedReaction, indexPath);
    }
    // return reaction;
    return childReaction;
  }

  /// Remove reaction from the feed.
  Future<void> onRemoveReaction(
      {required String kind,
      required EnrichedActivity<A, Ob, T, Or> activity,
      required Reaction reaction,
      required String feedGroup}) async {
    await client.reactions.delete(reaction.id!);

    await trackAnalytics(
        label: 'un$kind', foreignId: activity.foreignId, feedGroup: feedGroup);
    final _activities = activities ?? [activity];
    final activityPath = _activities.getEnrichedActivityPath(activity);

    final indexPath = _activities
        .indexWhere((a) => a.id! == activity.id); //TODO: handle null safety

    final reactionCounts =
        activityPath.reactionCounts.unshiftByKind(kind, ShiftType.decrement);

    // final reaction =
    //     reactionsFor(activity.id!).firstWhere((reaction) => reaction.id == id);
    final latestReactions = activityPath.latestReactions
        .unshiftByKind(kind, reaction, ShiftType.decrement);

    final ownReactions = activityPath.ownReactions
        .unshiftByKind(kind, reaction, ShiftType.decrement);

    final updatedActivity = activityPath.copyWith(
      ownReactions: ownReactions,
      latestReactions: latestReactions,
      reactionCounts: reactionCounts,
    );

    //remove reaction from the stream
    _reactionsControllers.unshiftById(
        activity.id!, reaction, ShiftType.decrement);

    _activitiesController.value =
        _activities.updateIn(updatedActivity, indexPath);
  }

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required EnrichedActivity<A, Ob, T, Or> activity,
    List<FeedId>? targetFeeds,
    required String feedGroup,
  }) async {
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    final _activities = activities ?? [activity];
    final activityPath = _activities.getEnrichedActivityPath(activity);
    final indexPath = _activities
        .indexWhere((a) => a.id! == activity.id); //TODO: handle null safety

    final reactionCounts = activityPath.reactionCounts.unshiftByKind(kind);
    final latestReactions =
        activityPath.latestReactions.unshiftByKind(kind, reaction);
    final ownReactions =
        activityPath.ownReactions.unshiftByKind(kind, reaction);

    final updatedActivity = activityPath.copyWith(
      ownReactions: ownReactions,
      latestReactions: latestReactions,
      reactionCounts: reactionCounts,
    );

    //adds reaction to the stream
    _reactionsControllers.unshiftById(activity.id!, reaction);

    _activitiesController.value = _activities //TODO: handle null safety
        .updateIn(updatedActivity, indexPath); //List<EnrichedActivity>.from
    return reaction;
  }

  ///Track analytics
  Future<void> trackAnalytics(
      {required String label,
      String? foreignId,
      required String feedGroup}) async {
    analyticsClient != null
        ? await analyticsClient!.trackEngagement(Engagement(
            content: Content(foreignId: FeedId.fromId(foreignId)),
            label: label,
            feedId: FeedId.fromId(feedGroup),
          ))
        : print('warning: analytics: not enabled'); //TODO:logger
  }

  Future<void> queryReactions(LookupAttribute lookupAttr, String lookupValue,
      {Filter? filter,
      int? limit,
      String? kind,
      EnrichmentFlags? flags}) async {
    if (_queryReactionsLoadingControllers[lookupValue]?.value == true) return;

    if (_reactionsControllers[lookupValue]?.hasValue != null) {
      _queryReactionsLoadingControllers[lookupValue]!.add(true);
    }

    try {
      final oldReactions = List<Reaction>.from(reactionsFor(lookupValue));
      final reactionsResponse = await client.reactions.filter(
        lookupAttr,
        lookupValue,
        filter: filter,
        flags: flags,
        limit: limit,
        kind: kind,
      );
      final temp = oldReactions + reactionsResponse;
      _reactionsControllers[lookupValue] = BehaviorSubject.seeded(temp);
    } catch (e, stk) {
      // reset loading controller
      _queryReactionsLoadingControllers[lookupValue]?.add(false);
      if (_reactionsControllers[lookupValue]?.hasValue != null) {
        _queryReactionsLoadingControllers[lookupValue]?.addError(e, stk);
      } else {
        _reactionsControllers[lookupValue]?.addError(e, stk);
      }
    }
  }

  Future<void> queryEnrichedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,

    //TODO: no way to parameterized marker?
  }) async {
    if (_queryActivitiesLoadingController.value == true) return;

    if (_activitiesController.hasValue) {
      _queryActivitiesLoadingController.add(true);
    }

    try {
      final oldActivities =
          List<EnrichedActivity<A, Ob, T, Or>>.from(activities ?? []);
      final activitiesResponse = await client
          .flatFeed(feedGroup, userId)
          .getEnrichedActivities<A, Ob, T, Or>(
            limit: limit,
            offset: offset,
            session: session,
            filter: filter,
            flags: flags,
            ranking: ranking,
          );

      final temp = oldActivities + activitiesResponse;
      _activitiesController.add(temp);
    } catch (e, stk) {
      // reset loading controller
      _queryActivitiesLoadingController.add(false);
      if (_activitiesController.hasValue) {
        _queryActivitiesLoadingController.addError(e, stk);
      } else {
        _activitiesController.addError(e, stk);
      }
    }
  }

  void dispose() {
    _activitiesController.close();
    _reactionsControllers.forEach((key, value) {
      value.close();
    });
    _queryActivitiesLoadingController.close();
    _queryReactionsLoadingControllers.forEach((key, value) {
      value.close();
    });
  }
}

class FeedBlocProvider extends InheritedWidget {
  //TODO: merge this with StreamFeedProvider ?
  const FeedBlocProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }) : super(key: key, child: child);

  final FeedBloc bloc;

  static FeedBlocProvider of(BuildContext context) {
    final FeedBlocProvider? result =
        context.dependOnInheritedWidgetOfExactType<FeedBlocProvider>();
    assert(result != null, 'No FeedBloc found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(FeedBlocProvider old) => bloc != old.bloc;
}
