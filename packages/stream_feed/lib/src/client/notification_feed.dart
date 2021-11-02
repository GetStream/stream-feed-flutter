import 'package:stream_feed/src/client/aggregated_feed.dart';
import 'package:stream_feed/src/client/feed.dart' show FeedSubscriber;
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/activity_marker.dart';
import 'package:stream_feed/src/core/models/enriched_activity.dart';
import 'package:stream_feed/src/core/models/enrichment_flags.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';
import 'package:stream_feed/src/core/models/filter.dart';
import 'package:stream_feed/src/core/models/group.dart';
import 'package:stream_feed/src/core/models/notification_feed_meta.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template notificationFeed}
/// Notification Feed Groups extend the "Aggregated Feed Group" concept
/// with additional features that make them well suited to notification systems.
///
/// Notification Feeds contain Activity Groups, each with a seen and read
/// status field.
///
/// These fields can be updated to reflect how a user has interacted with a
/// given notification.
///
/// When retrieved, the Feed includes a real-time count of
/// the total number of unseen and unread Activity Groups (notifications).
///
/// For example, take the notification system on Facebook.
///
/// If you click the notification icon, all notifications get marked as seen.
///
/// However, an individual notification only gets marked as read
/// when you click on it.
///
/// You can create new Notification Feed Groups in the dashboard.
/// {@endtemplate}
class NotificationFeed extends AggregatedFeed {
  ///Initialize a [NotificationFeed] object
  const NotificationFeed(
    FeedId feedId,
    FeedAPI feed, {
    Token? userToken,
    String? secret,
    FeedSubscriber? subscriber,
  }) : super(
          feedId,
          feed,
          userToken: userToken,
          secret: secret,
          subscriber: subscriber,
        );

  /// Retrieves one activity from a feed
  @override
  Future<NotificationGroup<Activity>> getActivityDetail(
      String activityId) async {
    final activities = await getActivities(
        limit: 1,
        filter: Filter()
            .idLessThanOrEqual(activityId)
            .idGreaterThanOrEqual(activityId));
    return activities.first;
  }

  /// Retrieve feed of type notifications
  ///
  /// # Example
  /// Mark all activities in the feed as seen
  /// ```dart
  /// final notifications = client.notificationFeed('notifications', '1');
  /// var activityGroups = await notifications.getActivities(
  ///   marker: ActivityMarker().allSeen(),
  /// );
  /// ```
  ///
  /// {@macro filter}
  @override
  Future<List<NotificationGroup<Activity>>> getActivities({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    final data = (result.data!['results'] as List)
        .map((e) => NotificationGroup.fromJson(
            e, (json) => Activity.fromJson(json as Map<String, dynamic>?)))
        .toList(growable: false);
    return data;
  }

  /// Retrieves unread an unseen count of notification feeds
  Future<NotificationFeedMeta> getUnreadUnseenCounts({
    Filter? filter,
    ActivityMarker? marker,
  }) async {
    final options = {
      'limit': 0,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getActivities(token, feedId, options);
    return NotificationFeedMeta.fromJson(result.data!);
  }

  /// Retrieve activities with reaction enrichment
  ///
  /// {@macro filter}
  @override
  Future<List<NotificationGroup<GenericEnrichedActivity<A, Ob, T, Or>>>>
      getEnrichedActivities<A, Ob, T, Or>({
    int? limit,
    int? offset,
    String? session,
    Filter? filter,
    ActivityMarker? marker,
    EnrichmentFlags? flags,
  }) async {
    final options = {
      'limit': limit ?? Default.limit,
      'offset': offset ?? Default.offset,
      ...filter?.params ?? Default.filter.params,
      ...marker?.params ?? Default.marker.params,
      ...flags?.params ?? Default.enrichmentFlags.params,
    };
    final token = userToken ??
        TokenHelper.buildFeedToken(secret!, TokenAction.read, feedId);
    final result = await feed.getEnrichedActivities(token, feedId, options);
    final data = (result.data['results'] as List)
        .map((e) => NotificationGroup.fromJson(
              e,
              (json) => GenericEnrichedActivity<A, Ob, T, Or>.fromJson(
                json! as Map<String, dynamic>?,
              ),
            ))
        .toList(growable: false);
    return data;
  }
}
