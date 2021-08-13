import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class ActivitiesBloc extends StatefulWidget {
  /// Instantiate a new [ActivitiesBloc]. The parameter [child] must be supplied and
  /// not null.
  const ActivitiesBloc({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// The widget child
  final Widget child;

  @override
  ActivitiesBlocState createState() => ActivitiesBlocState();

  /// Use this method to get the current [ActivitiesBlocState] instance
  static ActivitiesBlocState of(BuildContext context) {
    ActivitiesBlocState? state;

    state = context.findAncestorStateOfType<ActivitiesBlocState>();

    assert(
      state != null,
      'You must have a ActivitiesBloc widget as ancestor',
    );

    return state!;
  }
}

/// The current state of the [ReactionsBloc]
class ActivitiesBlocState extends State<ActivitiesBloc>
    with AutomaticKeepAliveClientMixin {
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

  late StreamFeedCoreState _streamFeedCore;

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required EnrichedActivity activity,
    List<FeedId>? targetFeeds,
    required String feedGroup,
  }) async {
    final client = _streamFeedCore.client;
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    final activityPath = activities!.getEnrichedActivityPath(activity);
    print("ACTIVITY PATH: $activityPath");
    final indexPath = activities!.indexOf(activity);

    var ownReactions = activityPath.ownReactions;
    var latestReactions = activityPath.latestReactions;
    var reactionCounts = activityPath.reactionCounts;

    final reactionsByKind = ownReactions![kind];
    final latestReactionsByKind = latestReactions![kind];
    final reactionCountsByKind = reactionCounts?[kind] ?? 0;

    ownReactions[kind] = reactionsByKind!
        .unshift(reaction); //List<Reaction>.from(reactionsByKind!)
    latestReactions[kind] = latestReactionsByKind!
        .unshift(reaction); //List<Reaction>.from(latestReactionsByKind!)
    reactionCounts![kind] = reactionCountsByKind + 1;

    final updatedActivity = activityPath.copyWith(
      ownReactions: ownReactions,
      latestReactions: latestReactions,
      reactionCounts: reactionCounts,
    );

    _activitiesController.value = activities!
        .updateIn(updatedActivity, indexPath); //List<EnrichedActivity>.from
    return reaction;
  }

  ///Track analytics
  Future<void> trackAnalytics(
      {required String label,
      String? foreignId,
      required String feedGroup}) async {
    final analyticsClient = _streamFeedCore.analyticsClient;
    analyticsClient != null
        ? await analyticsClient.trackEngagement(Engagement(
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
    final client = _streamFeedCore.client;

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
    _activitiesController.close();
    _queryActivitiesLoadingController.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
