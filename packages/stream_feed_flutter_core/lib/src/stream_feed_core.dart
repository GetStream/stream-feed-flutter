import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

/// Widget used to provide information about the chat to the widget tree.
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
  const StreamFeedCore(
      {Key? key,
      required this.client,
      required this.child,
      this.trackAnalytics = false,
      // required this.feedGroup,
      this.analyticsLocation,
      this.analyticsClient})
      : super(key: key);

  /// Instance of Stream Feed Client containing information about the current
  /// application.
  final StreamFeedClient client;

  final StreamAnalytics? analyticsClient;

  ///wether or not you want to track analytics in your app (can be useful for customised feeds via ML)
  final bool trackAnalytics;

  /// The location that should be used for analytics when liking in the feed,
  /// this is only useful when you have analytics enabled for your app.
  final String? analyticsLocation;

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

  StreamAnalytics? get analyticsClient => widget.analyticsClient;

  Future<void> onAddReaction(
      {Map<String, Object>? data,
      required String kind,
      required EnrichedActivity activity,
      List<FeedId>? targetFeeds,
      required String feedGroup}) async {
    await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    await trackAnalytics(label: kind, activity: activity, feedGroup: feedGroup);
  }

  Future<void> onRemoveReaction(
      {required String kind,
      required EnrichedActivity activity,
      required String id,
      required String feedGroup}) async {
    await client.reactions.delete(id);
    await trackAnalytics(
        label: 'un$kind', activity: activity, feedGroup: feedGroup);
  }

  Future<void> trackAnalytics(
      {required String label,
      required EnrichedActivity activity,
      required String feedGroup}) async {
    await analyticsClient!.trackEngagement(Engagement(
        content: Content(foreignId: FeedId.fromId(activity.foreignId)),
        label: label,
        feedId: FeedId.fromId(feedGroup)));
  }

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
      await client.flatFeed(feedGroup, userId).getEnrichedActivities();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  StreamSubscription? _eventSubscription;

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _eventSubscription?.cancel();
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
