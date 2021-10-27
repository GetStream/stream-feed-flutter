import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/activities_controller.dart';
import 'package:stream_feed_flutter_core/src/bloc/reactions_controller.dart';
import 'package:stream_feed_flutter_core/src/extensions.dart';

class GenericFeedBloc<A, Ob, T, Or> {
  GenericFeedBloc({required this.client, this.analyticsClient});

  final StreamFeedClient client;
  StreamUser? get currentUser => client.currentUser;

  final StreamAnalytics? analyticsClient;

  late ReactionsController reactionsController = ReactionsController();

  late ActivitiesController<A, Ob, T, Or> activitiesController =
      ActivitiesController<A, Ob, T, Or>();

  /// The current activities list.
  List<GenericEnrichedActivity<A, Ob, T, Or>>? getActivities(
          String feedGroup) =>
      activitiesController.getActivities(feedGroup);

  /// The current reactions list.
  List<Reaction> getReactions(String activityId, [Reaction? reaction]) =>
      reactionsController.getReactions(activityId, reaction);

  /// The current activities list as a stream.
  Stream<List<GenericEnrichedActivity<A, Ob, T, Or>>>? getActivitiesStream(
          String feedGroup) =>
      activitiesController.getStream(feedGroup);

  /// The current reactions list as a stream.
  Stream<List<Reaction>>? getReactionsStream(
      //TODO: better name?
      String activityId,
      [String? kind]) {
    return reactionsController.getStream(activityId, kind);
  }

  void clearActivities(String feedGroup) =>
      activitiesController.clearActivities(feedGroup);

  void clearAllActivities(List<String> feedGroups) =>
      activitiesController.clearAllActivities(feedGroups);

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

  final Map<String, BehaviorSubject<bool>> _queryReactionsLoadingControllers =
      {};

  /// The stream notifying the state of queryReactions call.
  Stream<bool> queryReactionsLoadingFor(String activityId) =>
      _queryReactionsLoadingControllers[activityId]!;

  /// The stream notifying the state of queryActivities call.
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
  }) async {
    final activity = Activity(
      actor: client.currentUser?.ref,
      verb: verb,
      object: object,
      extraData: data,
      to: to,
    );

    final flatFeed = client.flatFeed(feedGroup, userId);

    final addedActivity = await flatFeed.addActivity(activity);

    // TODO(Sacha): merge activity and enriched activity classes together
    final enrichedActivity = await flatFeed
        .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);

    final _activities = getActivities(feedGroup) ?? [];

    // ignore: cascade_invocations
    _activities.insert(0, enrichedActivity);

    activitiesController.add(feedGroup, _activities);

    await trackAnalytics(
      label: verb,
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value
    return addedActivity;
  }

  /// Remove child reaction.
  Future<void> onRemoveChildReaction({
    required String kind,
    required GenericEnrichedActivity activity,
    required Reaction childReaction,
    required Reaction parentReaction,
  }) async {
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

    // remove reaction from rxstream
    reactionsController
      ..unshiftById(activity.id!, childReaction, ShiftType.decrement)
      ..update(activity.id!, _reactions.updateIn(updatedReaction, indexPath));
  }

  Future<Reaction> onAddChildReaction({
    required String kind,
    required Reaction reaction,
    required GenericEnrichedActivity activity,
    Map<String, Object>? data,
    String? userId,
    List<FeedId>? targetFeeds,
  }) async {
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
    reactionsController
      ..unshiftById(activity.id!, childReaction)
      ..update(activity.id!, _reactions.updateIn(updatedReaction, indexPath));
    // return reaction;
    return childReaction;
  }

  /// Remove reaction from the feed.
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

    // remove reaction from the stream
    reactionsController.unshiftById(
        activity.id!, reaction, ShiftType.decrement);

    activitiesController.update(
        feedGroup, _activities.updateIn(updatedActivity, indexPath));
  }

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required GenericEnrichedActivity<A, Ob, T, Or> activity,
    List<FeedId>? targetFeeds,
    required String feedGroup,
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
    reactionsController.unshiftById(activity.id!, reaction);

    activitiesController.update(
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

  Future<void> queryReactions(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
  }) async {
    reactionsController.init(lookupValue);
    _queryReactionsLoadingControllers[lookupValue] =
        BehaviorSubject.seeded(false);
    if (_queryReactionsLoadingControllers[lookupValue]?.value == true) return;

    if (reactionsController.hasValue(lookupValue)) {
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
      reactionsController.add(lookupValue, temp);
    } catch (e, stk) {
      // reset loading controller
      _queryReactionsLoadingControllers[lookupValue]?.add(false);
      if (reactionsController.hasValue(lookupValue)) {
        _queryReactionsLoadingControllers[lookupValue]?.addError(e, stk);
      } else {
        reactionsController.addError(lookupValue, e, stk);
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
    activitiesController.init(feedGroup);
    if (_queryActivitiesLoadingController.value == true) return;

    if (activitiesController.hasValue(feedGroup)) {
      _queryActivitiesLoadingController.add(true);
    }

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

      activitiesController.add(feedGroup, activitiesResponse);
      if (activitiesController.hasValue(feedGroup) &&
          _queryActivitiesLoadingController.value) {
        _queryActivitiesLoadingController.sink.add(false);
      }
    } catch (e, stk) {
      // reset loading controller
      _queryActivitiesLoadingController.add(false);
      if (activitiesController.hasValue(feedGroup)) {
        _queryActivitiesLoadingController.addError(e, stk);
      } else {
        activitiesController.addError(feedGroup, e, stk);
      }
    }
  }

  /// Follows the given [flatFeed].
  Future<void> followFlatFeed(
    String otherUser,
  ) async {
    final timeline = client.flatFeed('timeline');
    final user = client.flatFeed('user', otherUser);
    await timeline.follow(user);
  }

  /// Unfollows the given [actingFeed].
  Future<void> unfollowFlatFeed(
    String otherUser,
  ) async {
    final timeline = client.flatFeed('timeline');
    final user = client.flatFeed('user', otherUser);
    await timeline.unfollow(user);
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
    final following = await client.flatFeed('timeline').following(
      limit: 1,
      offset: 0,
      filter: [
        FeedId.id('user:$userId'),
      ],
    );
    return following.isNotEmpty;
  }

  void dispose() {
    activitiesController.close();
    reactionsController.close();
    _queryActivitiesLoadingController.close();
    _queryReactionsLoadingControllers.forEach((key, value) {
      value.close();
    });
  }

  Future<void> onRemoveActivity({
    required String feedGroup,
    required String activityId,
  }) async {
    await client.flatFeed(feedGroup).removeActivityById(activityId);
  }
}
