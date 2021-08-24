import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/utils/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({
    Key? key,
    required this.feedGroup,
    required this.notificationBuilder,
    this.limit,
    this.offset,
    this.session,
    this.filter,
    this.flags,
    this.ranking,
    this.userId,
    this.marker,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const ProgressStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No notifications to display'),
  }) : super(key: key);

  final String feedGroup;
  final int? limit;
  final int? offset;
  final String? session;
  final Filter? filter;
  final EnrichmentFlags? flags;
  final String? ranking;
  final String? userId;
  final ActivityMarker? marker;
  final NotificationBuilder notificationBuilder;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

  @override
  Widget build(BuildContext context) {
    return NotificationFeedCore(
      //twitter behavior: 30s delay to mark before marking new notifications as seen
      feedGroup: feedGroup,
      limit: limit,
      offset: offset,
      session: session,
      filter: filter,
      marker: marker,
      flags: flags,
      onProgressWidget: onProgressWidget,
      onErrorWidget: onErrorWidget,
      onEmptyWidget: onEmptyWidget,
      notificationsBuilder: (context, notifications, idx) =>
          notificationBuilder(context, notifications[idx]),
    );
  }
}
