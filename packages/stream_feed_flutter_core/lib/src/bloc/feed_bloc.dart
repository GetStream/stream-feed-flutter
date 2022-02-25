// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/bloc/activities_controller.dart';
import 'package:stream_feed_flutter_core/src/bloc/reactions_controller.dart';
import 'package:stream_feed_flutter_core/src/extensions.dart';
import 'package:stream_feed_flutter_core/src/upload/upload_controller.dart';


/// {@template feedBloc}
/// Widget dedicated to the state management of an app's Stream feed
/// [FeedBloc] is used to manage a set of operations
/// associated with [EnrichedActivity]s and [Reaction]s.
///
/// [FeedBloc] can be access at anytime by using the factory [of] method
/// using Flutter's [BuildContext].
///
/// Usually what you want is the convenient [FeedBloc] that already
/// has the default parameters defined for you
/// suitable to most use cases. But if you need a
/// more advanced use case use [GenericFeedBloc] instead
///
/// ## Usage
/// - {@macro queryEnrichedActivities}
/// - {@macro queryReactions}
/// - {@macro onAddActivity}
/// - {@macro deleteActivity}
/// - {@macro onAddReaction}
/// - {@macro onRemoveReaction}
/// - {@macro onAddChildReaction}
/// - {@macro onRemoveChildReaction}
/// {@endtemplate}
///
/// {@template genericParameters}
/// The generic parameters can be of the following type:
/// - A : [actor] can be an User, or a String
/// - Ob : [object] can a String, or a CollectionEntry
/// - T : [target] can be a String or an Activity
/// - Or : [origin] can be a String or a Reaction or an User
///
/// To avoid potential runtime errors
/// make sure they are the same across the app if
/// you go the route of using Generic* classes
///
/// {@endtemplate}
class FeedBloc extends GenericFeedBloc<User, String, String, String> {
  FeedBloc({
    required StreamFeedClient client,
    StreamAnalytics? analyticsClient,
    UploadController? uploadController,
  }) : super(
            client: client,
            analyticsClient: analyticsClient,
            uploadController: uploadController);
}

/// The generic version of `FeedBloc`.
///
/// {@macro feedBloc}
/// {@macro genericParameters}
class GenericFeedBloc<A, Ob, T, Or> {
  /// {@macro feedBloc}
  GenericFeedBloc({
    required this.client,
    this.analyticsClient,
    UploadController? uploadController,
  }) : uploadController = uploadController ?? UploadController(client);

  /// The underlying client instance
  final StreamFeedClient client;

  /// The current User
  StreamUser? get currentUser => client.currentUser;

  /// The underlying analytics client
  final StreamAnalytics? analyticsClient;

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
  late UploadController uploadController;

  /// Manager for activities.
  @visibleForTesting
  late ActivitiesManager<A, Ob, T, Or> activitiesManager =
      ActivitiesManager<A, Ob, T, Or>();

  /// Manager for reactions.
  @visibleForTesting
  late ReactionsManager reactionsManager = ReactionsManager();

  /// The current activities list.
  List<GenericEnrichedActivity<A, Ob, T, Or>>? getActivities(
          String feedGroup) =>
      activitiesManager.getActivities(feedGroup);

  /// The current reactions list.
  List<Reaction> getReactions(String activityId, [Reaction? reaction]) =>
      reactionsManager.getReactions(activityId, reaction);

  /// The current activities list as a stream.
  Stream<List<GenericEnrichedActivity<A, Ob, T, Or>>>? getActivitiesStream(
          String feedGroup) =>
      activitiesManager.getStream(feedGroup);

  /// The current reactions list as a stream.
  Stream<List<Reaction>>? getReactionsStream(String activityId,
      [String? kind]) {
    return reactionsManager.getStream(activityId, kind);
  }

  ///  Clear activities for a given `feedGroup`.
  void clearActivities(String feedGroup) =>
      activitiesManager.clearActivities(feedGroup);

  ///  Clear all activities for the given `feedGroups`.
  void clearAllActivities(List<String> feedGroups) =>
      activitiesManager.clearAllActivities(feedGroups);

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

  final Map<String, BehaviorSubject<bool>> _queryReactionsLoadingControllers =
      {};

  /// The stream notifying the state of queryReactions call.
  Stream<bool> queryReactionsLoadingFor(String activityId) =>
      _queryReactionsLoadingControllers[activityId]!;

  /// The stream notifying the state of queryActivities call.
  Stream<bool> get queryActivitiesLoading =>
      _queryActivitiesLoadingController.stream;

  /// Convenient method to fetch a list of users current user is following
  Future<List<User>> followingUsers({String feedGroup = 'timeline'}) async {
    final following =
        await client.flatFeed(feedGroup, currentUser!.id).following();
    final users = following
        .map((follow) => client.getUser(follow.feedId.split(':').last))
        .toList();
    return Future.wait(users);
  }

  /// Convenient method to fetch a list of users following current (followers)
  Future<List<User>> followersUsers({String feedGroup = 'user'}) async {
    final followers =
        await client.flatFeed(feedGroup, currentUser!.id).followers();
    final users = followers
        .map((follow) => client.getUser(follow.feedId.split(':').last))
        .toList();
    return Future.wait(users);
  }

  /* ACTIVITIES */

  /// {@template onAddActivity}
  ///  Add an activity to the feed in a reactive way
  ///
  /// For example a tweet
  /// ```dart
  /// FeedProvider.of(context).bloc.onAddActivity()
  /// ```
  /// {@endtemplate}

  Future<Activity> onAddActivity({
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

    final flatFeed = client.flatFeed(feedGroup, userId);

    final addedActivity = await flatFeed.addActivity(activity);

    // TODO(Sacha): this is a hack. Merge activity and enriched activity classes together
    final enrichedActivity = await flatFeed
        .getEnrichedActivityDetail<A, Ob, T, Or>(addedActivity.id!);

    final _activities = getActivities(feedGroup) ?? [];

    // ignore: cascade_invocations
    _activities.insert(0, enrichedActivity);

    activitiesManager.add(feedGroup, _activities);

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
    // ignore: cascade_invocations
    _activities.removeWhere((element) => element.id == activityId);
    activitiesManager.add(feedGroup, _activities);
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
    reactionsManager
      ..unshiftById(activity.id!, childReaction)
      ..update(activity.id!, _reactions.updateIn(updatedReaction, indexPath));

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
    reactionsManager
      ..unshiftById(activity.id!, childReaction, ShiftType.decrement)
      ..update(activity.id!, _reactions.updateIn(updatedReaction, indexPath));
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

  /// {@template queryReactions}
  /// Query the reactions stream (like, retweet, claps).
  ///
  /// Checkout our convenient core widget
  ///  [ReactionListCore] for displaying reactions easily
  /// {@endtemplate}
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

  /// {@template queryEnrichedActivities}
  /// Query the activities stream
  ///
  /// Checkout our convenient core widget [FlatFeedCore]
  /// to display activities easily
  /// {@endtemplate}
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
    activitiesManager.init(feedGroup);
    if (_queryActivitiesLoadingController.value == true) return;

    if (activitiesManager.hasValue(feedGroup)) {
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

  /* FOLLOW */

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
    activitiesManager.close();
    reactionsManager.close();
    _queryActivitiesLoadingController.close();
    _queryReactionsLoadingControllers.forEach((key, value) {
      value.close();
    });
  }
}
