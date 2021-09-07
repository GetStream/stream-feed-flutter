import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/activities_bloc.dart';

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
class StreamFeedProvider extends InheritedWidget {
  /// Constructor used for creating a new instance of [StreamFeedCore].
  ///
  /// [StreamFeedCore] is a stateful widget which reacts to system events and
  /// updates Stream's connection status accordingly.
  StreamFeedProvider({
    Key? key,
    required this.client,
    required Widget child,
    this.enableAnalytics = false,
    // required this.feedGroup,
    this.navigatorKey,
    this.analyticsLocation,
    this.analyticsClient,
  }) : super(key: key, child: child);

  /// Instance of Stream Feed Client containing information about the current
  /// application.
  final StreamFeedClient client;

  ///Analytics client
  final StreamAnalytics? analyticsClient;

  ///wether or not you want to track analytics in your app (can be useful for customised feeds via ML)
  final bool enableAnalytics;

  /// The location that should be used for analytics when liking in the feed,
  /// this is only useful when you have analytics enabled for your app.
  final String? analyticsLocation;

  ///Your navigator key
  final GlobalKey<NavigatorState>? navigatorKey;

  /// The current user
  // StreamUser? get user => client.currentUser;

  // The current user
  ReactionsClient get reactions => client.reactions;



  ///Track analytics
  Future<void> trackAnalytics({
    required String label,
    required String feedGroup,
    String? foreignId,
  }) async {
    analyticsClient != null
        ? await analyticsClient!.trackEngagement(Engagement(
            content: Content(foreignId: FeedId.fromId(foreignId)),
            label: label,
            feedId: FeedId.fromId(feedGroup),
          ))
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
    return await reactions.filter(
      lookupAttr,
      lookupValue,
      filter: filter,
      limit: limit,
      kind: kind,
      flags: flags,
    );
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

  static StreamFeedProvider of(BuildContext context) {
    final StreamFeedProvider? result =
        context.dependOnInheritedWidgetOfExactType<StreamFeedProvider>();
    assert(result != null, 'No StreamFeedProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StreamFeedProvider old) =>
      navigatorKey != old.navigatorKey ||
      analyticsClient != old.analyticsClient ||
      analyticsLocation != old.analyticsLocation ||
      enableAnalytics != old.enableAnalytics;
}
