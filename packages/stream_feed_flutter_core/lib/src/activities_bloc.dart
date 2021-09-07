import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivitiesBloc {
  ActivitiesBloc({required this.client, this.analyticsClient});

  final StreamFeedClient client;

  final StreamAnalytics? analyticsClient;

  /// The current reactions list
  List<EnrichedActivity>? get activities => _activitiesController.valueOrNull;

  // void set updateactivities(List<EnrichedActivity> newActivities) =>
  //     _activitiesController.value = newActivities;

  /// The current activities list as a stream
  Stream<List<EnrichedActivity>> get activitiesStream =>
      _activitiesController.stream;

  final _activitiesController = BehaviorSubject<List<EnrichedActivity>>();

  final _queryActivitiesLoadingController = BehaviorSubject.seeded(false);

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
    await trackAnalytics(
      label: 'post',
      foreignId: activity.foreignId,
      feedGroup: feedGroup,
    ); //TODO: remove hardcoded value
    return addedActivity;
  }

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required EnrichedActivity activity,
    List<FeedId>? targetFeeds,
    required String feedGroup,
  }) async {
    // print("HEY");
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    // final activityPath = activities!.getEnrichedActivityPath(activity);
    // print("ACTIVITY PATH: $activityPath");
    // final indexPath = activities!.indexOf(activity);

    // var ownReactions = activityPath.ownReactions;
    // var latestReactions = activityPath.latestReactions;
    // var reactionCounts = activityPath.reactionCounts;

    // final reactionsByKind = ownReactions![kind];
    // final latestReactionsByKind = latestReactions![kind];
    // final reactionCountsByKind = reactionCounts?[kind] ?? 0;

    // ownReactions[kind] = reactionsByKind!
    //     .unshift(reaction); //List<Reaction>.from(reactionsByKind!)
    // latestReactions[kind] = latestReactionsByKind!
    //     .unshift(reaction); //List<Reaction>.from(latestReactionsByKind!)
    // reactionCounts![kind] = reactionCountsByKind + 1;

    // final updatedActivity = activityPath.copyWith(
    //   ownReactions: ownReactions,
    //   latestReactions: latestReactions,
    //   reactionCounts: reactionCounts,
    // );

    // _activitiesController.value = activities!
    //     .updateIn(updatedActivity, indexPath); //List<EnrichedActivity>.from
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
    _queryActivitiesLoadingController.close();
  }
}

class ActivitiesProvider extends InheritedWidget {
  const ActivitiesProvider({
    Key? key,
    required this.bloc,
    required Widget child,
  }) : super(key: key, child: child);

  final ActivitiesBloc bloc;

  static ActivitiesProvider of(BuildContext context) {
    final ActivitiesProvider? result =
        context.dependOnInheritedWidgetOfExactType<ActivitiesProvider>();
    assert(result != null, 'No ActivitiesBloc found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ActivitiesProvider old) => bloc != old.bloc;
}
