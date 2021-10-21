import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/src/feed_type.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FeedBloc<A, Ob, T, Or> {
  FeedBloc({required this.client, this.analyticsClient});

  final StreamFeedClient client;
  StreamUser? get currentUser => client.currentUser;

  final StreamAnalytics? analyticsClient;

  /// The current activities list
  List<EnrichedActivity<A, Ob, T, Or>>? get activities =>
      _activitiesController.valueOrNull;

  /// The current reactions list
  List<Reaction> getReactions(String activityId, [Reaction? reaction]) =>
      reactionsControllers.getReactions(activityId, reaction);

  /// The current activities list as a stream
  Stream<List<EnrichedActivity<A, Ob, T, Or>>> get activitiesStream =>
      _activitiesController.stream;

  /// The current reactions list as a stream
  Stream<List<Reaction>>? getReactionsStream(
      //TODO: better name?
      String activityId,
      [String? kind]) {
    return reactionsControllers.getStream(activityId, kind);
  }

  @visibleForTesting
  late ReactionsControllers reactionsControllers = ReactionsControllers();

  final _activitiesController =
      BehaviorSubject<List<EnrichedActivity<A, Ob, T, Or>>>();

  /// Tracks the activities within an aggregated feed.
  final _aggregatedActivitiesController =
      BehaviorSubject<List<Group<EnrichedActivity<A, Ob, T, Or>>>>();

  /// A stream of activities within an aggregated feed.
  Stream<List<Group<EnrichedActivity<A, Ob, T, Or>>>>
      get aggregatedActivitiesStream => _aggregatedActivitiesController.stream;

  /// A convenience getter for the value in the _aggregatedActivitiesController.
  List<Group<EnrichedActivity<A, Ob, T, Or>>>? get aggregatedActivities =>
      _aggregatedActivitiesController.valueOrNull;

  final _queryAggregatedActivitiesLoadingController =
      BehaviorSubject<bool>.seeded(false);

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

  final Map<String, BehaviorSubject<bool>> _queryReactionsLoadingControllers =
      {};

  /// The stream notifying the state of queryReactions call
  Stream<bool> queryReactionsLoadingFor(String activityId) =>
      _queryReactionsLoadingControllers[activityId]!;

  /// The stream notifying the state of queryActivities call
  Stream<bool> get queryActivitiesLoading =>
      _queryActivitiesLoadingController.stream;

  /// Add an activity to the feed.
  Future<Activity> onAddActivity({
    required String feedGroup,
    Map<String, String>? data,
    required String verb,
    required String object,
    String? userId,
    List<FeedId>? to,
    required FeedType feedType,
  }) async {
    final activity = Activity(
      actor: client.currentUser?.ref,
      verb: verb,
      object: object,
      extraData: data,
      to: to,
      time: DateTime.now(),
    );

    var addedActivity;
    var enrichedActivity;

    switch (feedType) {
      case FeedType.flat:
        final flatFeed = client.flatFeed(feedGroup, userId);
        addedActivity = await flatFeed.addActivity(activity);
        // TODO(Sacha): merge activity and enriched activity classes together
        enrichedActivity = await flatFeed
            .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);
        final _activities = activities ?? [];
        _activities.insert(0, enrichedActivity);
        _activitiesController.add(_activities);
        break;
      case FeedType.aggregated:
        final aggregatedFeed = client.aggregatedFeed(feedGroup, userId);
        addedActivity = await aggregatedFeed.addActivity(activity);
        // TODO(Sacha): merge activity and enriched activity classes together
        enrichedActivity = await aggregatedFeed
            .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);
        final _activities = aggregatedActivities ?? [];
        _activities.insert(0, enrichedActivity);
        _aggregatedActivitiesController.add(_activities);
        break;
      case FeedType.notification:
        // TODO: Handle this case.
        break;
    }

    await trackAnalytics(
      label: 'post',
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value
    return addedActivity;
  }

  /// Remove child reaction
  Future<void> onRemoveChildReaction(
      {required String kind,
      required EnrichedActivity activity,
      required Reaction childReaction,
      required Reaction parentReaction}) async {
    await client.reactions.delete(childReaction.id!);
    final _reactions = getReactions(activity.id!, parentReaction);

    final reactionPath = _reactions.getReactionPath(parentReaction);

    final indexPath = _reactions.indexWhere(
        (r) => r.id! == parentReaction.id); //TODO: handle null safety

    final childrenCounts =
        reactionPath.childrenCounts.unshiftByKind(kind, ShiftType.decrement);
    final latestChildren = reactionPath.latestChildren
        .unshiftByKind(kind, childReaction, ShiftType.decrement);
    final ownChildren = reactionPath.ownChildren
        .unshiftByKind(kind, childReaction, ShiftType.decrement);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownChildren,
      latestChildren: latestChildren,
      childrenCounts: childrenCounts,
    );

    //remove reaction from rxstream
    reactionsControllers.unshiftById(
        activity.id!, childReaction, ShiftType.decrement);

    reactionsControllers.update(
        activity.id!, _reactions.updateIn(updatedReaction, indexPath));
  }

  Future<Reaction> onAddChildReaction(
      {required String kind,
      required Reaction reaction,
      required EnrichedActivity activity,
      Map<String, Object>? data,
      String? userId,
      List<FeedId>? targetFeeds}) async {
    final childReaction = await client.reactions.addChild(kind, reaction.id!,
        data: data, userId: userId, targetFeeds: targetFeeds);
    final _reactions = getReactions(activity.id!, reaction);
    final reactionPath = _reactions.getReactionPath(reaction);
    final indexPath = _reactions
        .indexWhere((r) => r.id! == reaction.id); //TODO: handle null safety

    final childrenCounts = reactionPath.childrenCounts.unshiftByKind(kind);
    final latestChildren =
        reactionPath.latestChildren.unshiftByKind(kind, childReaction);
    final ownChildren =
        reactionPath.ownChildren.unshiftByKind(kind, childReaction);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownChildren,
      latestChildren: latestChildren,
      childrenCounts: childrenCounts,
    );

    // adds reaction to the rxstream
    reactionsControllers.unshiftById(activity.id!, childReaction);

    reactionsControllers.update(
        activity.id!, _reactions.updateIn(updatedReaction, indexPath));
    // return reaction;
    return childReaction;
  }

  /// Remove reaction from the feed.
  Future<void> onRemoveReaction({
    required String kind,
    required EnrichedActivity<A, Ob, T, Or> activity,
    required Reaction reaction,
    required String feedGroup,
  }) async {
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
    reactionsControllers.unshiftById(
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
    reactionsControllers.unshiftById(activity.id!, reaction);

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

  Future<void> queryReactions(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
  }) async {
    reactionsControllers.init(lookupValue);
    _queryReactionsLoadingControllers[lookupValue] =
        BehaviorSubject.seeded(false);
    if (_queryReactionsLoadingControllers[lookupValue]?.value == true) return;

    if (reactionsControllers.hasValue(lookupValue)) {
      _queryReactionsLoadingControllers[lookupValue]!
          .add(true); //TODO: fix null
    }

    try {
      final oldReactions = List<Reaction>.from(getReactions(lookupValue));
      final reactionsResponse = await client.reactions.filter(
        lookupAttr,
        lookupValue,
        filter: filter,
        flags: flags,
        limit: limit,
        kind: kind,
      );
      final temp = oldReactions + reactionsResponse;
      reactionsControllers.add(lookupValue, temp);
    } catch (e, stk) {
      // reset loading controller
      _queryReactionsLoadingControllers[lookupValue]?.add(false);
      if (reactionsControllers.hasValue(lookupValue)) {
        _queryReactionsLoadingControllers[lookupValue]?.addError(e, stk);
      } else {
        reactionsControllers.addError(lookupValue, e, stk);
      }
    }
  }

  /// Queries the given [feedGroup] for aggregated activities.
  Future<void> queryAggregatedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
  }) async {
    if (_queryAggregatedActivitiesLoadingController.value == true) return;

    if (_aggregatedActivitiesController.hasValue) {
      _queryAggregatedActivitiesLoadingController.add(true);
    }

    try {
      final oldActivities = List<Group<EnrichedActivity<A, Ob, T, Or>>>.from(
          aggregatedActivities ?? []);

      final activitiesResponse = await client
          .aggregatedFeed(feedGroup, userId)
          .getEnrichedActivities<A, Ob, T, Or>(
            limit: limit,
            offset: offset,
            session: session,
            filter: filter,
            flags: flags,
            //ranking: ranking,
          );

      final temp = oldActivities + activitiesResponse;
      _aggregatedActivitiesController.add(temp);
    } catch (e, stackTrace) {
      // reset loading controller
      _queryAggregatedActivitiesLoadingController.add(false);
      if (_aggregatedActivitiesController.hasValue) {
        _queryAggregatedActivitiesLoadingController.addError(e, stackTrace);
      } else {
        _aggregatedActivitiesController.addError(e, stackTrace);
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

  /// Follows the given [flatFeed].
  Future<void> followUser(
    FlatFeed flatFeed,
  ) async {
    final currentUserFeed = client.flatFeed('user', currentUser!.id);
    await currentUserFeed.follow(flatFeed);
  }

  /// Unfollows the given [flatFeed].
  Future<void> unfollowUser(
    FlatFeed flatFeed,
  ) async {
    final currentUserFeed = client.flatFeed('user', currentUser!.id);
    await currentUserFeed.unfollow(flatFeed);
  }

  /// Checks whether the current user is following a feed with the given
  /// [userId].
  ///
  /// It filters the request such that if the current user is in fact
  /// following the given user, one user will be returned that matches the
  /// current user, thus indicating that the current user does follow the given
  /// user. If no results are found, this means that the current user is not
  /// following the given user.
  Future<bool> isFollowingUser(String userId) async {
    final following = await client.flatFeed('user', userId).following(
      limit: 1,
      offset: 0,
      filter: [
        FeedId.id('user:${currentUser?.id}'),
      ],
    );
    return following.isNotEmpty;
  }

  void dispose() {
    _activitiesController.close();
    _aggregatedActivitiesController.close();
    _queryAggregatedActivitiesLoadingController.close();
    reactionsControllers.close();
    _queryActivitiesLoadingController.close();
    _queryReactionsLoadingControllers.forEach((key, value) {
      value.close();
    });
  }

  Future<void> onRemoveActivity(
      {required String feedGroup, required String activityId}) async {
    await client.flatFeed(feedGroup).removeActivityById(activityId);
  }
}

class FeedBlocProvider<A, Ob, T, Or> extends InheritedWidget {
  const FeedBlocProvider(
      {Key? key, required this.bloc, required Widget child, this.navigatorKey})
      : super(key: key, child: child);
  factory FeedBlocProvider.of(BuildContext context) {
    final FeedBlocProvider<A, Ob, T, Or>? result = context
        .dependOnInheritedWidgetOfExactType<FeedBlocProvider<A, Ob, T, Or>>();
    assert(result != null, 'No FeedBlocProvider found in context');
    return result!;
  }

  final FeedBloc<A, Ob, T, Or> bloc;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  bool updateShouldNotify(FeedBlocProvider old) =>
      navigatorKey != old.navigatorKey || bloc != old.bloc; //
}

class ReactionsControllers {
  final Map<String, BehaviorSubject<List<Reaction>>> _controller = {};

  /// Init controller for given activityId
  void init(String lookupValue) =>
      _controller[lookupValue] = BehaviorSubject<List<Reaction>>();

  /// Retrieve with activityId the corresponding StreamController from the map of controllers
  BehaviorSubject<List<Reaction>>? _getController(String lookupValue) =>
      _controller[lookupValue]; //TODO: handle null safety

  ///Retrieve Stream of reactions with activityId and filter it if necessary
  Stream<List<Reaction>>? getStream(String lookupValue, [String? kind]) {
    final isFiltered = kind != null;
    final reactionStream = _getController(lookupValue)?.stream;
    return isFiltered
        ? reactionStream?.map((reactions) =>
            reactions.where((reaction) => reaction.kind == kind).toList())
        : reactionStream; //TODO: handle null safety
  }

  /// Convert the Stream of reactions to a List of reactions
  List<Reaction> getReactions(String lookupValue, [Reaction? reaction]) =>
      _getController(lookupValue)?.valueOrNull ??
      (reaction != null ? [reaction] : <Reaction>[]);

  ///Check if controller is not empty
  bool hasValue(String lookupValue) =>
      _getController(lookupValue)?.hasValue != null;

  ///Lookup latest Reactions by Id and inserts the given reaction to the beginning of the list
  void unshiftById(String lookupValue, Reaction reaction,
          [ShiftType type = ShiftType.increment]) =>
      _controller.unshiftById(lookupValue, reaction, type);

  ///Close every stream controllers
  void close() => _controller.forEach((key, value) {
        value.close();
      });

  /// Update controller value with given reactions
  void update(String lookupValue, List<Reaction> reactions) {
    if (hasValue(lookupValue)) {
      _getController(lookupValue)!.value = reactions;
    }
  }

  /// Add given reactions to the correct controller
  void add(String lookupValue, List<Reaction> temp) {
    if (hasValue(lookupValue))
      _getController(lookupValue)!.add(temp); //TODO: handle null safety
  }

  ///Add error to the correct controller
  void addError(String lookupValue, Object e, StackTrace stk) {
    if (hasValue(lookupValue))
      _getController(lookupValue)!.addError(e, stk); //TODO: handle null safety
  }
}
