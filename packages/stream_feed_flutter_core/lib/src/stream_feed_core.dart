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
  const StreamFeedCore({
    Key? key,
    required this.client,
    required this.child,
    // this.onBackgroundEventReceived,
    // this.backgroundKeepAlive = const Duration(minutes: 1),
  }) : super(key: key);

  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final StreamFeedClient client;

  /// Widget descendant.
  final Widget child;

  @override
  StreamFeedCoreState createState() => StreamFeedCoreState();

  /// Use this method to get the current [StreamFeedCoreState] instance
  static StreamFeedCoreState of(BuildContext context) {
    StreamFeedCoreState? StreamFeedState;

    StreamFeedState = context.findAncestorStateOfType<StreamFeedCoreState>();

    assert(
      StreamFeedState != null,
      'You must have a StreamFeed widget at the top of your widget tree',
    );

    return StreamFeedState!;
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

  Future<Reaction> onAddReaction({
    Map<String, Object>? data,
    required String kind,
    required EnrichedActivity activity,
    List<FeedId>? targetFeeds,
  }) async {
    final reaction = await client.reactions
        .add(kind, activity.id!, targetFeeds: targetFeeds, data: data);
    //TODO: trackAnalytics
    return reaction;
  }

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
