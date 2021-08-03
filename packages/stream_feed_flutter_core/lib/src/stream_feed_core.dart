import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

/// Widget used to provide information about the feed to the widget tree.
/// This Widget is used to react to life cycle changes and system updates.
/// When the app goes into the background, the websocket connection is kept
/// alive for two minutes before being terminated.
///
/// Conversely, when app is resumed or restarted, a new connection is initiated.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamFeedClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamFeedCore(
///           client: client,
///           child: child,
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
class StreamFeedCore extends StatefulWidget {
  /// Constructor used for creating a new instance of [StreamFeedCore].
  ///
  /// [StreamFeedCore] is a stateful widget which reacts to system events and
  /// updates Stream's connection status accordingly.
  StreamFeedCore(
      {Key? key,
      required this.client,
      required this.child,
      this.trackAnalytics = false,
      // required this.feedGroup,
      this.navigatorKey,
      this.analyticsLocation,
      this.analyticsClient})
      : super(key: key);

  /// Instance of Stream Feed Client containing information about the current
  /// application.
  final StreamFeedClient client;

  ///Analytics client
  final StreamAnalytics? analyticsClient;

  ///wether or not you want to track analytics in your app (can be useful for customised feeds via ML)
  final bool trackAnalytics;

  /// The location that should be used for analytics when liking in the feed,
  /// this is only useful when you have analytics enabled for your app.
  final String? analyticsLocation;

  ///Your navigator key
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Widget descendant.
  final Widget child;

  @override
  StreamFeedCoreState createState() => StreamFeedCoreState();

  /// Use this method to get the current [StreamFeedCoreState] instance
  static StreamFeedCoreState of(BuildContext context) {
    StreamFeedCoreState? streamFeedState;

    streamFeedState = context.findAncestorStateOfType<StreamFeedCoreState>();

    assert(
      streamFeedState != null,
      'You must have a StreamFeed widget at the top of your widget tree',
    );

    return streamFeedState!;
  }
}

/// State class associated with [StreamFeedCore].
class StreamFeedCoreState extends State<StreamFeedCore>
    with WidgetsBindingObserver {
  /// Initialized client used throughout the application.
  StreamFeedClient get client => widget.client;

  Timer? _disconnectTimer;

  @override
  Widget build(BuildContext context) => widget.child;

  /// The current user
  UserClient? get user => client.currentUser;

  /// The current user
  ReactionsClient get reactions => client.reactions;

  StreamAnalytics? get analyticsClient => widget.analyticsClient;
  NavigatorState? get navigator => widget.navigatorKey?.currentState;

  /// Add a new reaction to the feed.
  Future<Reaction> onAddReaction(
      {Map<String, Object>? data,
      required String kind,
      required EnrichedActivity activity,
      List<FeedId>? targetFeeds,
      required String feedGroup}) async {
    final reaction = await reactions.add(kind, activity.id!,
        targetFeeds: targetFeeds, data: data);
    await trackAnalytics(
        label: kind, foreignId: activity.foreignId, feedGroup: feedGroup);
    return reaction;
  }

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
        label: 'post', foreignId: activity.foreignId, feedGroup: feedGroup);
    return addedActivity;
  }

  /// Remove reaction from the feed.
  Future<void> onRemoveReaction(
      {required String kind,
      required EnrichedActivity activity,
      required String id,
      required String feedGroup}) async {
    await reactions.delete(id);
    await trackAnalytics(
        label: 'un$kind', foreignId: activity.foreignId, feedGroup: feedGroup);
  }

  ///Add child reaction
  Future<Reaction> onAddChildReaction(
      {required String kind,
      required Reaction reaction,
      Map<String, Object>? data,
      String? userId,
      List<FeedId>? targetFeeds}) async {
    print('onAddChildReaction');
    final childReaction = await reactions.addChild(kind, reaction.id!,
        data: data, userId: userId, targetFeeds: targetFeeds);
    return childReaction;
  }

  /// Remove child reaction
  Future<void> onRemoveChildReaction(
      {required String id, String? kind, Reaction? reaction}) async {
    await reactions.delete(id);
  }

  ///Track analytics
  Future<void> trackAnalytics(
      {required String label,
      required foreignId,
      required String feedGroup}) async {
    analyticsClient != null
        ? await analyticsClient!.trackEngagement(Engagement(
            content: Content(foreignId: FeedId.fromId(foreignId)),
            label: label,
            feedId: FeedId.fromId(feedGroup)))
        : print('warning: analytics: not enabled'); //TODO:logger
  }

  ///Get reactions form the activity
  Future<List<Reaction>> getReactions(
    LookupAttribute lookupAttr,
    String lookupValue, {
    Filter? filter,
    int? limit,
    String? kind,
    EnrichmentFlags? flags,
  }) async {
    print('FILTER');
    return await reactions.filter(lookupAttr, lookupValue,
        filter: filter, limit: limit, kind: kind, flags: flags);
  }

  ///Get enriched activities from the feed
  Future<List<EnrichedActivity>> getEnrichedActivities({
    required String feedGroup,
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    EnrichmentFlags? flags,
    String? ranking,
    String? userId,
  }) async =>
      await client.flatFeed(feedGroup, userId).getEnrichedActivities(
            limit: limit,
            offset: offset,
            session: session,
            filter: filter,
            flags: flags,
            ranking: ranking,
          );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
