import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FeedBloc {
  FeedBloc({required this.client, this.analyticsClient});

  final StreamFeedClient client;

  final StreamAnalytics? analyticsClient;

  /// The current activities list
  List<EnrichedActivity>? get activities => _activitiesController.valueOrNull;

  /// The current reactions list
  List<Reaction> reactionsFor(String activityId) =>
      _reactionsControllers[activityId]?.valueOrNull ?? [];

  // void set updateactivities(List<EnrichedActivity> newActivities) =>
  //     _activitiesController.value = newActivities;

  /// The current activities list as a stream
  Stream<List<EnrichedActivity>> get activitiesStream =>
      _activitiesController.stream;

  /// The current reactions list as a stream
  Stream<List<Reaction>>? reactionsStreamFor(
          String activityId) => //TODO: better name
      _reactionsControllers[activityId]?.stream;

  final _reactionsControllers = Map<String, BehaviorSubject<List<Reaction>>>();

  final _activitiesController = BehaviorSubject<List<EnrichedActivity>>();

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
      {required String id, String? kind, Reaction? reaction}) async {
    await client.reactions.delete(id);
    //TODO: handle state
  }

  Future<Reaction> onAddChildReaction(
      {required String kind,
      required Reaction reaction,
      Map<String, Object>? data,
      String? userId,
      List<FeedId>? targetFeeds}) async {
    final childReaction = await client.reactions.addChild(kind, reaction.id!,
        data: data, userId: userId, targetFeeds: targetFeeds);
    //TODO: handle state
    return childReaction;
  }

  /// Remove reaction from the feed.
  Future<void> onRemoveReaction(
      {required String kind,
      required EnrichedActivity activity,
      required String id,
      required String feedGroup}) async {
    await client.reactions.delete(id);
    //TODO: handle state / decrement
    await trackAnalytics(
        label: 'un$kind', foreignId: activity.foreignId, feedGroup: feedGroup);
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
    final _activities = activities ?? [activity];
    final activityPath = _activities.getEnrichedActivityPath(activity);
    final indexPath = _activities.indexOf(activity); //TODO: handle null safety

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
      final oldActivities = List<EnrichedActivity>.from(activities ?? []);
      final activitiesResponse =
          await client.flatFeed(feedGroup, userId).getEnrichedActivities(
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

class FeedBlocProvider extends InheritedWidget {//TODO: merge this with StreamFeedProvider ?
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
