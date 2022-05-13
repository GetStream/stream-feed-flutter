// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/activities_manager.dart';
import 'package:stream_feed_flutter_core/src/bloc/grouped_activities_manager.dart';
import 'package:stream_feed_flutter_core/src/bloc/reactions_manager.dart';
import 'package:stream_feed_flutter_core/src/extensions.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';

@immutable
class FeedBloc extends GenericFeedBloc<User, String, String, String> {
  FeedBloc({
    required StreamFeedClient client,
    StreamAnalytics? analyticsClient,
    UploadController? uploadController,
    ActivitiesManager<User, String, String, String>? activitiesManager,
    GroupedActivitiesManager<User, String, String, String>?
        groupedActivitiesManager,
    ReactionsManager? reactionsManager,
  }) : super(
          client: client,
          analyticsClient: analyticsClient,
          uploadController: uploadController,
          activitiesManager: activitiesManager,
          groupedActivitiesManager: groupedActivitiesManager,
          reactionsManager: reactionsManager,
        );
}

/// The generic version of `FeedBloc`.
///
/// {@macro feedBloc}
/// {@macro genericParameters}
@immutable
class GenericFeedBloc<A, Ob, T, Or> extends Equatable {
  /// {@macro feedBloc}
  GenericFeedBloc({
    required this.client,
    this.analyticsClient,
    UploadController? uploadController,
    ActivitiesManager<A, Ob, T, Or>? activitiesManager,
    GroupedActivitiesManager<A, Ob, T, Or>? groupedActivitiesManager,
    ReactionsManager? reactionsManager,
  })  : uploadController = uploadController ?? UploadController(client),
        activitiesManager =
            activitiesManager ?? ActivitiesManager<A, Ob, T, Or>(),
        groupedActivitiesManager = groupedActivitiesManager ??
            GroupedActivitiesManager<A, Ob, T, Or>(),
        reactionsManager = reactionsManager ?? ReactionsManager();

  /// The underlying Stream Feed client instance.
  ///
  /// {@macro stream_feed_client}
  final StreamFeedClient client;

  /// The current User
  StreamUser? get currentUser => client.currentUser;

  /// The underlying analytics client
  final StreamAnalytics? analyticsClient;

  /// {@template uploadController}
  /// Controller to manage file uploads.
  ///
  /// A controller is automatically created from the given [client]. Or,
  /// alternatively, you can pass in your own when creating a `GenericFeedBloc`
  /// or `FeedBloc`.
  ///
  /// ```dart
  /// GenericFeedBloc(
  ///    client: client,
  ///    uploadController: uploadController,
  /// );
  /// ```
  /// {@endtemplate}
  final UploadController uploadController;

  /// Manager for activities.
  ///
  /// This is only used internally and for testing.
  @visibleForTesting
  final ActivitiesManager<A, Ob, T, Or> activitiesManager;

  /// Manager for aggregated activities.
  ///
  /// This is only used internally and for testing.
  @visibleForTesting
  final GroupedActivitiesManager<A, Ob, T, Or> groupedActivitiesManager;

  /// Manager for reactions.
  ///
  /// This is only used internally and for testing.
  @visibleForTesting
  final ReactionsManager reactionsManager;

  /* STREAMS */

  /// The current activities list as a stream.
  Stream<List<GenericEnrichedActivity<A, Ob, T, Or>>>? getActivitiesStream(
          String feedGroup) =>
      activitiesManager.getStream(feedGroup);

  /// The current activities list as a stream.
  Stream<List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>>?
      getGroupedActivitiesStream(String feedGroup) =>
          groupedActivitiesManager.getStream(feedGroup);

  /// The current reactions list as a stream.
  Stream<List<Reaction>>? getReactionsStream(String lookupValue,
      [String? kind]) {
    return reactionsManager.getStream(lookupValue, kind);
  }

  /* LISTS */

  /// The current activities list.
  List<GenericEnrichedActivity<A, Ob, T, Or>>? getActivities(
          String feedGroup) =>
      activitiesManager.getActivities(feedGroup);

  /// The current grouped (aggregated) activities list
  List<Group<GenericEnrichedActivity<A, Ob, T, Or>>>? getGroupedActivities(
          String feedGroup) =>
      groupedActivitiesManager.getActivities(feedGroup);

  /// The current reactions list.
  List<Reaction> getReactions(String lookupValue, [Reaction? reaction]) =>
      reactionsManager.getReactions(lookupValue, reaction);

  /* LOADING CONTROLLERS */

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

  final _queryGroupedActivitiesLoadingController =
      BehaviorSubject.seeded(false);

  final Map<String, BehaviorSubject<bool>> _queryReactionsLoadingControllers =
      {};

  /* NEXT PARAMS */

  /// Retrieves the last stored paginated params, [NextParams], for the given
  /// [feedGroup].
  @visibleForTesting
  NextParams? paginatedParamsGroupedActivites({required String feedGroup}) =>
      groupedActivitiesManager.paginatedParams[feedGroup];

  /// Retrieves the last stored paginated params, [NextParams], for the given
  /// [feedGroup].
  @visibleForTesting
  NextParams? paginatedParamsActivities({required String feedGroup}) =>
      activitiesManager.paginatedParams[feedGroup];

  /// Retrieves the last stored paginated params, [NextParams], for the given
  /// [lookupValue].
  @visibleForTesting
  NextParams? paginatedParamsReactions({required String lookupValue}) =>
      reactionsManager.paginatedParams[lookupValue];

  /* CLEARING */

  ///  Clear activities for a given `feedGroup`.
  void clearActivities(String feedGroup) =>
      activitiesManager.clearActivities(feedGroup);

  ///  Clear all activities for the given `feedGroups`.
  void clearAllActivities(List<String> feedGroups) =>
      activitiesManager.clearAllActivities(feedGroups);

  /// Clear grouped/aggregated activities for the given `feedGroup`.
  void clearGroupedActivities(String feedGroup) =>
      groupedActivitiesManager.clearGroupedActivities(feedGroup);

  ///  Clear all grouped/aggregated activities for the given `feedGroups`.
  void clearAllGroupedActivities(List<String> feedGroups) =>
      groupedActivitiesManager.clearAllGroupedActivities(feedGroups);

  /// Clear reactions for a given `lookupValue`.
  void clearReactions(String lookupValue) =>
      reactionsManager.clearReactions(lookupValue);

  /// Clear all reactions for the given `lookupValues
  void clearAllReactions(List<String> lookupValues) =>
      reactionsManager.clearAllReactions(lookupValues);

  /* STREAMS */

  /// The stream notifying the state of queryReactions call.
  Stream<bool> queryReactionsLoadingFor(String activityId) =>
      _queryReactionsLoadingControllers[activityId]!;

  /// The stream notifying the state of queryActivities call.
  Stream<bool> get queryActivitiesLoading =>
      _queryActivitiesLoadingController.stream;

  /// The stream notifying the state of queryActivities call.
  Stream<bool> get queryGroupedActivitiesLoading =>
      _queryActivitiesLoadingController.stream;

  /* ACTIVITIES */

  /// {@template onAddActivity}
  ///  Add an activity to the feed in a reactive way
  ///
  /// For example, a tweet:
  /// ```dart
  /// FeedProvider.of(context).bloc.onAddActivity(
  ///   feedGroup: 'user',
  ///   verb: 'tweet',
  ///   object: 'tweet_id:1234',
  /// );
  /// ```
  /// {@endtemplate}

  Future<Activity> onAddActivity({
    required String feedGroup,
    Map<String, Object>? data,
    required String verb,
    required String object,
    String? userId,
    List<FeedId>? to,
    DateTime? time,
  }) async {
    final activity = Activity(
      actor: client.currentUser?.ref,
      verb: verb,
      object: object,
      extraData: data,
      to: to,
      time: time,
    );

    final flatFeed = client.flatFeed(feedGroup, userId);
    final addedActivity = await flatFeed.addActivity(activity);

    // TODO(Sacha): this is a hack.
    // We should Merge activity and enriched activity classes together
    // to avoid this from hapenning
    final enrichedActivity = await flatFeed
        .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);

    final _activities = (getActivities(feedGroup) ?? []).toList();

    _activities.insert(0, enrichedActivity);

    activitiesManager.add(feedGroup, _activities);

    await trackAnalytics(
      label: verb,
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value

    return addedActivity;
  }

  Future<Activity> onAddActivityGroup({
    required String feedGroup,
    Map<String, Object>? data,
    required String verb,
    required String object,
    String? userId,
    List<FeedId>? to,
  }) async {
    final activity = Activity(
      actor: client.currentUser?.ref,
      verb: verb,
      object: object,
      extraData: data,
      to: to,
    );

    final aggregatedFeed = client.aggregatedFeed(feedGroup, userId);
    final addedActivity = await aggregatedFeed.addActivity(activity);

    // TODO(Sacha): this is a hack.
    // We should Merge activity and enriched activity classes together
    // to avoid this from hapenning
    final enrichedGroupedActivity = await aggregatedFeed
        .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);

    final _groupedActivities = (getGroupedActivities(feedGroup) ?? []).toList();

    _groupedActivities.insert(0, enrichedGroupedActivity);

    groupedActivitiesManager.add(feedGroup, _groupedActivities);

    await trackAnalytics(
      label: verb,
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value

    return addedActivity;
  }

  /// {@template onRemoveActivity}
  /// Remove an Activity from the feed in a reactive way
  ///
  /// For example delete a tweet
  /// ```dart
  /// FeedProvider.of(context).bloc.onRemoveActivity()
  /// ```
  /// {@endtemplate}
  Future<void> onRemoveActivity({
    required String feedGroup,
    required String activityId,
  }) async {
    await client.flatFeed(feedGroup).removeActivityById(activityId);
    final _activities = getActivities(feedGroup) ?? [];
    _activities.removeWhere((element) => element.id == activityId);
    activitiesManager.add(feedGroup, _activities);
  }

  /// {@template onRemoveActivity}
  /// Remove an Activity from the feed in a reactive way
  ///
  /// For example delete a tweet
  /// ```dart
  /// FeedProvider.of(context).bloc.onRemoveActivity()
  /// ```
  /// {@endtemplate}
  Future<void> onRemoveActivityGroup({
    required String feedGroup,
    required String activityId,
  }) async {
    await client.aggregatedFeed(feedGroup).removeActivityById(activityId);
    final _activities = getGroupedActivities(feedGroup) ?? [];
    _activities.removeWhere((element) => element.id == activityId);
    groupedActivitiesManager.add(feedGroup, _activities);
  }

  /* CHILD REACTIONS */

  /// {@template onAddChildReaction}
  /// Add child reaction to the feed in a reactive way
  ///
  /// For example to add a like to a comment
  /// ```dart
  /// FeedProvider.of(context).bloc.onAddReaction()
  /// ```
  /// {@endtemplate}
  Future<Reaction> onAddChildReaction({
    required String kind,
    required Reaction reaction,
    required String lookupValue,
    Map<String, Object>? data,
    String? userId,
    List<FeedId>? targetFeeds,
  }) async {
    final childReaction = await client.reactions.addChild(
      kind,
      reaction.id!,
      targetFeeds: targetFeeds,
      data: data,
    );
    // await trackAnalytics(
    //     label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    final _reactions = getReactions(lookupValue, reaction);
    final reactionPath = _reactions.getReactionPath(reaction);
    final indexPath = _reactions
        .indexWhere((r) => r.id! == reaction.id); //TODO: handle null safety

    final reactionCounts = reactionPath.childrenCounts.unshiftByKind(kind);
    final latestReactions =
        reactionPath.latestChildren.unshiftByKind(kind, childReaction);
    final ownReactions =
        reactionPath.ownChildren.unshiftByKind(kind, childReaction);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownReactions,
      latestChildren: latestReactions,
      childrenCounts: reactionCounts,
    );

    // adds reaction to the stream

    reactionsManager
      ..unshiftById(reaction.id!, childReaction)
      ..update(
          lookupValue,
          _reactions //TODO: handle null safety
              .updateIn(updatedReaction, indexPath));
    return childReaction;
  }

  /// {@template onRemoveChildReaction}
  /// Remove child reactions from the feed in a reactive way
  ///
  /// For example to unlike a comment
  /// ```dart
  /// FeedProvider.of(context).bloc.onRemoveChildReaction()
  /// ```
  /// {@endtemplate}
  Future<void> onRemoveChildReaction({
    required String kind,
    required String lookupValue,
    required Reaction childReaction,
    required Reaction parentReaction,
  }) async {
    await client.reactions.delete(childReaction.id!);
    // await trackAnalytics(
    //     label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    final _reactions = getReactions(lookupValue, parentReaction);
    final reactionPath = _reactions.getReactionPath(parentReaction);
    final indexPath = _reactions.indexWhere(
        (r) => r.id! == parentReaction.id); //TODO: handle null safety

    final reactionCounts =
        reactionPath.childrenCounts.unshiftByKind(kind, ShiftType.decrement);
    final latestReactions = reactionPath.latestChildren
        .unshiftByKind(kind, childReaction, ShiftType.decrement);
    final ownReactions = reactionPath.ownChildren
        .unshiftByKind(kind, childReaction, ShiftType.decrement);

    final updatedReaction = reactionPath.copyWith(
      ownChildren: ownReactions,
      latestChildren: latestReactions,
      childrenCounts: reactionCounts,
    );

    // adds reaction to the stream
    reactionsManager
      ..unshiftById(lookupValue, childReaction, ShiftType.decrement)
      ..update(
          lookupValue,
          _reactions //TODO: handle null safety
              .updateIn(updatedReaction, indexPath));
  }

  /// {@template onRemoveReaction}
  /// Remove reaction from the feed in a reactive way
  ///
  /// For example to delete a comment under a tweet
  /// ```dart
  /// FeedProvider.of(context).bloc.onRemoveReaction()
  /// ```
  /// {@endtemplate}
  Future<void> onRemoveReaction({
    required String kind,
    required GenericEnrichedActivity<A, Ob, T, Or> activity,
    required Reaction reaction,
    required String feedGroup,
  }) async {
    await client.reactions.delete(reaction.id!);
    await trackAnalytics(
        label: 'un$kind', foreignId: activity.foreignId, feedGroup: feedGroup);
    final _activities = getActivities(feedGroup) ?? [activity];
    final activityPath = _activities.getEnrichedActivityPath(activity);

    final indexPath = _activities
        .indexWhere((a) => a.id! == activity.id); //TODO: handle null safety

    final reactionCounts =
        activityPath.reactionCounts.unshiftByKind(kind, ShiftType.decrement);

    final latestReactions = activityPath.latestReactions
        .unshiftByKind(kind, reaction, ShiftType.decrement);

    final ownReactions = activityPath.ownReactions
        .unshiftByKind(kind, reaction, ShiftType.decrement);

    final updatedActivity = activityPath.copyWith(
      ownReactions: ownReactions,
      latestReactions: latestReactions,
      reactionCounts: reactionCounts,
    );

    // remove reaction from the stream
    reactionsManager.unshiftById(activity.id!, reaction, ShiftType.decrement);

    activitiesManager.update(
        feedGroup, _activities.updateIn(updatedActivity, indexPath));
  }

  /* REACTIONS */

  /// {@template onAddReaction}
  /// Add a new reaction to the feed
  ///  in a reactive way.
  /// For example to add a comment under a tweet:
  /// ```dart
  /// FeedProvider.of(context).bloc.onAddReaction(kind:'comment',
  /// activity: activities[idx],feedGroup:'user'),
  /// data: {'text': trimmedText}
  /// ```
  /// {@endtemplate}

  Future<Reaction> onAddReaction({
    required String kind,
    required GenericEnrichedActivity<A, Ob, T, Or> activity,
    required String feedGroup,
    List<FeedId>? targetFeeds,
    Map<String, Object>? data,
  }) async {
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    final _activities = getActivities(feedGroup) ?? [activity];
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

    // adds reaction to the stream
    reactionsManager.unshiftById(activity.id!, reaction);

    activitiesManager.update(
        feedGroup,
        _activities //TODO: handle null safety
            .updateIn(updatedActivity, indexPath));
    return reaction;
  }

  /// Track analytics.
  Future<void> trackAnalytics({
    required String label,
    String? foreignId,
    required String feedGroup,
  }) async {
    analyticsClient != null
        ? await analyticsClient!.trackEngagement(Engagement(
            content: Content(foreignId: FeedId.fromId(foreignId)),
            label: label,
            feedId: FeedId.fromId(feedGroup),
          ))
        : print('warning: analytics: not enabled'); //TODO:logger
  }

  @Deprecated(
      '''use `refreshPaginatedReactions` instead to refresh reactions '''
      ''', and `loadMoreReactions` to load more reactions''')
  @internal
  Future<void> queryReactions(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
  }) async {
    reactionsManager.init(lookupValue);
    _queryReactionsLoadingControllers[lookupValue] =
        BehaviorSubject.seeded(false);
    if (_queryReactionsLoadingControllers[lookupValue]?.value == true) return;

    if (reactionsManager.hasValue(lookupValue)) {
      _queryReactionsLoadingControllers[lookupValue]!.add(true);
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
      reactionsManager.add(lookupValue, temp);
    } catch (e, stk) {
      // reset loading controller
      _queryReactionsLoadingControllers[lookupValue]?.add(false);
      if (reactionsManager.hasValue(lookupValue)) {
        _queryReactionsLoadingControllers[lookupValue]?.addError(e, stk);
      } else {
        reactionsManager.addError(lookupValue, e, stk);
      }
    }
  }

  @Deprecated(
      '''use `refreshPaginatedEnrichedActivities` instead to refresh enriched '''
      '''activities, and `loadMoreEnrichedActivities` to load more paginated activities''')
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
    if (_queryActivitiesLoadingController.value == true) {
      return; // already loading
    }
    if (!activitiesManager.hasValue(feedGroup)) {
      activitiesManager.init(feedGroup);
    }
    _queryActivitiesLoadingController.add(true);
    try {
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
      activitiesManager.add(feedGroup, activitiesResponse);
      if (activitiesManager.hasValue(feedGroup) &&
          _queryActivitiesLoadingController.value) {
        _queryActivitiesLoadingController.sink.add(false);
      }
    } catch (e, stk) {
      // reset loading controller
      _queryActivitiesLoadingController.add(false);
      if (activitiesManager.hasValue(feedGroup)) {
        _queryActivitiesLoadingController.addError(e, stk);
      } else {
        activitiesManager.addError(feedGroup, e, stk);
      }
    }
  }

  /// Queries the reactions stream and stores the pagination results.
  ///
  /// See the `ReactionListCore` widget to display reactions easily.
  /// This method is used internally by the `ReactionListCore` widget
  /// and should not be called directly.
  ///
  /// #### See:
  /// - [getReactions] to retrieve all the current reactions for the given
  /// activity.
  /// - [refreshPaginatedReactions] to refresh the reactions for the given
  /// activity.
  /// - [loadMoreReactions] to automatically load the next paginated
  /// reactions for a given activity.
  @internal
  Future<void> queryPaginatedReactions(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
    bool refresh = false,
    //TODO: no way to parameterized marker?
  }) async {
    if (_queryReactionsLoadingControllers[lookupValue]?.value == true) {
      return; // already loading
    }
    if (!reactionsManager.hasValue(lookupValue)) {
      reactionsManager.init(lookupValue);
      _queryReactionsLoadingControllers[lookupValue] =
          BehaviorSubject.seeded(false);
    }
    _queryReactionsLoadingControllers[lookupValue]?.add(true);
    try {
      final reactionsResponse =
          await client.reactions.paginatedFilter<A, Ob, T, Or>(
        lookupAttr,
        lookupValue,
        filter: filter,
        flags: flags,
        limit: limit,
        kind: kind,
      );
      NextParams? nextParams;
      try {
        if (reactionsResponse.next != null &&
            reactionsResponse.next!.isNotEmpty) {
          nextParams = parseNext(reactionsResponse.next!);
        }
        reactionsManager.paginatedParams[lookupValue] = nextParams;
      } catch (e, st) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: st);
        // TODO:(gordon) add logs
      }
      if (reactionsResponse.results != null) {
        final allReactions = <Reaction>{
          if (!refresh) ...reactionsManager.getReactions(lookupValue),
          ...?reactionsResponse.results
        };
        reactionsManager.add(lookupValue, allReactions.toList());

        if (reactionsManager.hasValue(lookupValue) &&
            _queryReactionsLoadingControllers[lookupValue]!.value) {
          _queryReactionsLoadingControllers[lookupValue]!.sink.add(false);
        }
      }
    } catch (e, stk) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stk);
      // TODO(Gordon) add logs
      // reset loading controller
      _queryReactionsLoadingControllers[lookupValue]!.add(false);
      if (reactionsManager.hasValue(lookupValue)) {
        _queryReactionsLoadingControllers[lookupValue]!.addError(e, stk);
      } else {
        reactionsManager.addError(lookupValue, e, stk);
      }
    }
  }

  /// Queries the activities stream and stores the pagination results.
  ///
  /// See the `FlatFeedCore` widget to display activities easily.
  /// This method is used internally by the `FlatFeedCore` widget
  /// and should not be called directly.
  ///
  /// #### See:
  /// - [getActivities] to retrieve all the current activities for the given
  /// feed.
  /// - [refreshPaginatedEnrichedActivities] to refresh the feed for a given
  /// feed.
  /// - [loadMoreEnrichedActivities] to automatically load the next paginated
  /// activities for a given feed.
  @internal
  Future<void> queryPaginatedEnrichedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
    bool refresh = false,
    //TODO: no way to parameterized marker?
  }) async {
    if (_queryActivitiesLoadingController.value == true) {
      return; // already loading
    }
    if (!activitiesManager.hasValue(feedGroup)) {
      activitiesManager.init(feedGroup);
    }
    _queryActivitiesLoadingController.add(true);
    try {
      final activitiesResponse = await client
          .flatFeed(feedGroup, userId)
          .getPaginatedEnrichedActivities<A, Ob, T, Or>(
            limit: limit,
            offset: offset,
            session: session,
            filter: filter,
            flags: flags,
            ranking: ranking,
          );
      NextParams? nextParams;
      try {
        if (activitiesResponse.next != null &&
            activitiesResponse.next!.isNotEmpty) {
          nextParams = parseNext(activitiesResponse.next!);
        }
        activitiesManager.paginatedParams[feedGroup] = nextParams;
      } catch (e) {
        // TODO:(gordon) add logs
      }
      if (activitiesResponse.results != null) {
        final allActivities = <GenericEnrichedActivity<A, Ob, T, Or>>{
          if (!refresh) ...?activitiesManager.getActivities(feedGroup),
          ...?activitiesResponse.results
        };
        activitiesManager.add(feedGroup, allActivities.toList());

        if (activitiesManager.hasValue(feedGroup) &&
            _queryActivitiesLoadingController.value) {
          _queryActivitiesLoadingController.sink.add(false);
        }
      }
    } catch (e, stk) {
      // reset loading controller
      _queryActivitiesLoadingController.add(false);
      if (activitiesManager.hasValue(feedGroup)) {
        _queryActivitiesLoadingController.addError(e, stk);
      } else {
        activitiesManager.addError(feedGroup, e, stk);
      }
    }
  }

  /// Queries the activities stream for aggregated activities
  /// and stores the pagination results.
  ///
  /// See the `AggregatedFeedCore` widget to display activities easily.
  /// This method is used internally by the `AggregatedFeedCore` widget
  /// and should not be used directly.
  ///
  /// #### See:
  /// - [getGroupedActivities] to retrieve all the current activities for the
  /// given feed.
  /// - [refreshPaginatedGroupedActivities] to refresh the aggregated group
  /// for a given feed.
  /// - [loadMoreGroupedActivities] to automatically load the next paginated
  /// grouped/aggregated activities for a given feed.
  @internal
  Future<void> queryPaginatedGroupedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? userId,
    bool refresh = false,
    //TODO(sacha): no way to parameterized marker?
  }) async {
    if (_queryGroupedActivitiesLoadingController.value == true) {
      return; // already loading
    }
    if (!groupedActivitiesManager.hasValue(feedGroup)) {
      groupedActivitiesManager.init(feedGroup);
    }
    _queryGroupedActivitiesLoadingController.add(true);
    try {
      final activitiesGroupResponse = await client
          .aggregatedFeed(feedGroup, userId)
          .getPaginatedActivities<A, Ob, T, Or>(
            limit: limit,
            offset: offset,
            session: session,
            filter: filter,
            flags: flags,
          );
      NextParams? nextParams;
      try {
        if (activitiesGroupResponse.next != null &&
            activitiesGroupResponse.next!.isNotEmpty) {
          nextParams = parseNext(activitiesGroupResponse.next!);
        }
        groupedActivitiesManager.paginatedParams[feedGroup] = nextParams;
      } catch (e) {
        // TODO:(gordon) add logs
      }
      if (activitiesGroupResponse.results != null) {
        final allGroupedActivities =
            <Group<GenericEnrichedActivity<A, Ob, T, Or>>>{
          if (!refresh) ...?groupedActivitiesManager.getActivities(feedGroup),
          ...?activitiesGroupResponse.results
        };
        groupedActivitiesManager.add(feedGroup, allGroupedActivities.toList());

        if (groupedActivitiesManager.hasValue(feedGroup) &&
            _queryGroupedActivitiesLoadingController.value) {
          _queryGroupedActivitiesLoadingController.sink.add(false);
        }
      }
    } catch (e, stk) {
      // reset loading controller
      _queryGroupedActivitiesLoadingController.add(false);
      if (groupedActivitiesManager.hasValue(feedGroup)) {
        _queryGroupedActivitiesLoadingController.addError(e, stk);
      } else {
        groupedActivitiesManager.addError(feedGroup, e, stk);
      }
    }
  }

  /* LOAD MORE METHODS */

  /// {@template loadMoreReactions}
  /// Loads the next paginated reactions.
  ///
  /// This method call [queryPaginatedReactions] for you and automatically
  /// uses the correct `limit` and `filter` as determined by the last strored
  /// [paginatedParamsReactions].
  ///
  /// The [lookupAttr] default value is set to[LookupAttribute.activityId].
  ///
  /// You can override the [limit] value, otherwise it is retrieved from the
  /// latest [NextParams].
  /// {@endtemplate}
  Future<void> loadMoreReactions(
    String lookupValue, {
    LookupAttribute lookupAttr = LookupAttribute.activityId,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,

    //TODO: no way to parameterized marker?
  }) async {
    final nextParams = paginatedParamsReactions(lookupValue: lookupValue);

    if (nextParams == null) {
      // TODO(gordon): add logs
      return;
    }

    queryPaginatedReactions(
      lookupAttr,
      lookupValue,
      filter: nextParams.idLT,
      limit: limit ?? nextParams.limit,
      kind: kind,
      flags: flags,
    );
  }

  /// {@template loadMoreGroupedActivities}
  /// Loads the next paginated grouped activities.
  ///
  /// This method call [paginatedParamsGroupedActivites] for you and
  /// automatically uses the correct `limit` and `filter` as determined by the
  /// last strored [paginatedParamsGroupedActivites].
  ///
  /// You can override the [limit] value, otherwise it is retrieved from the
  /// latest [NextParams].
  /// {@endtemplate}
  Future<void> loadMoreGroupedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
    // TODO: no way to parameterized marker?
  }) async {
    final nextParams = paginatedParamsGroupedActivites(feedGroup: feedGroup);

    if (nextParams == null) {
      // TODO(gordon): add logs
      return;
    }

    queryPaginatedGroupedActivities(
      feedGroup: feedGroup,
      limit: limit ?? nextParams.limit,
      offset: offset,
      session: session,
      filter: nextParams.idLT,
      flags: flags,
      userId: userId,
    );
  }

  /// {@template loadMoreEnrichedActivities}
  /// Loads the next paginated enriched activities.
  ///
  /// This method call [queryPaginatedEnrichedActivities] for you and
  /// automatically uses the correct `limit` and `filter` as determined by the
  /// last strored [paginatedParamsActivities].
  ///
  /// You can override the [limit] value, otherwise it is retrieved from the
  /// latest [NextParams].
  ///
  /// {@endtemplate}
  Future<void> loadMoreEnrichedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
    // TODO: no way to parameterized marker?
  }) async {
    final nextParams = paginatedParamsActivities(feedGroup: feedGroup);

    if (nextParams == null) {
      // TODO(gordon): add logs
      return;
    }

    queryPaginatedEnrichedActivities(
      feedGroup: feedGroup,
      limit: limit ?? nextParams.limit,
      offset: offset,
      session: session,
      filter: nextParams.idLT,
      flags: flags,
      ranking: ranking,
      userId: userId,
    );
  }

  /// Refreshes the paginated reactions by calling
  /// [queryPaginatedReactions] and refreshing the state.
  ///
  /// This results in the reactions being loaded again, and
  /// replacing the current state with the updated values.
  Future<void> refreshPaginatedReactions(
    String lookupValue, {
    LookupAttribute lookupAttr = LookupAttribute.activityId,
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
  }) async {
    queryPaginatedReactions(
      lookupAttr,
      lookupValue,
      filter: filter,
      limit: limit,
      kind: kind,
      flags: flags,
      refresh: true,
    );
  }

  /// Refreshes the paginated grouped activities by calling
  /// [queryPaginatedGroupedActivities] and refreshing the state.
  ///
  /// This results in the aggregated activities being loaded again, and
  /// replacing the current state with the updated values.
  Future<void> refreshPaginatedGroupedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? userId,
  }) async {
    queryPaginatedGroupedActivities(
      feedGroup: feedGroup,
      limit: limit,
      offset: offset,
      session: session,
      filter: filter,
      flags: flags,
      userId: userId,
      refresh: true,
    );
  }

  /// Refreshes the paginated enriched activities by calling
  /// [queryPaginatedEnrichedActivities] and refreshing the state.
  ///
  /// This results in the activities being loaded again, and replacing the
  /// current state with the updated values.
  Future<void> refreshPaginatedEnrichedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
  }) async {
    await queryPaginatedEnrichedActivities(
      feedGroup: feedGroup,
      limit: limit,
      offset: offset,
      session: session,
      filter: filter,
      flags: flags,
      ranking: ranking,
      userId: userId,
      refresh: true,
    );
  }

  /* FOLLOW */

// TODO(sacha):follower manager
  /// Follows the given [followeeId] id.
  Future<void> followFeed({
    String followerFeedGroup = 'timeline',
    String followeeFeedGroup = 'user',
    required String followeeId,
  }) async {
    final followerFeed = client.flatFeed(followerFeedGroup);
    final followeeFeed = client.flatFeed(followeeFeedGroup, followeeId);
    await followerFeed.follow(followeeFeed);
  }

  /// Unfollows the given [unfolloweeId] id.
  Future<void> unfollowFeed({
    String unfollowerFeedGroup = 'timeline',
    String unfolloweeFeedGroup = 'user',
    required String unfolloweeId,
  }) async {
    final unfollowerFeed = client.flatFeed(unfollowerFeedGroup);
    final unfolloweeFeed = client.flatFeed(unfolloweeFeedGroup, unfolloweeId);
    await unfollowerFeed.unfollow(unfolloweeFeed);
  }

  /// Checks whether the current user is following a feed with the given
  /// [followerId].
  ///
  /// It filters the request such that if the current user is in fact
  /// following the given user, one user will be returned that matches the
  /// current user, thus indicating that the current user does follow the given
  /// user. If no results are found, this means that the current user is not
  /// following the given user.
  Future<bool> isFollowingFeed({
    String followeeFeedGroup = 'timeline',
    String followerFeedGroup = 'user',
    required String followerId,
  }) async {
    final following = await client.flatFeed(followeeFeedGroup).following(
      limit: 1,
      offset: 0,
      filter: [
        FeedId.id('$followerFeedGroup:$followerId'),
      ],
    );
    return following.isNotEmpty;
  }

  void dispose() {
    groupedActivitiesManager.close();
    activitiesManager.close();
    reactionsManager.close();
    _queryGroupedActivitiesLoadingController.close();
    _queryActivitiesLoadingController.close();
    _queryReactionsLoadingControllers.forEach((key, value) {
      value.close();
    });
  }

  @override
  List<Object?> get props => [client, analyticsClient];
}
