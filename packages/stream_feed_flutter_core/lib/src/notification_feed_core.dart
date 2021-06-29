import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class NotificationFeedCore extends StatelessWidget {
  const NotificationFeedCore(
      {Key? key,
      required this.feedGroup,
      required this.onSuccess,
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
          const EmptyStateWidget(message: 'No notifications to display')})
      : super(key: key);

  final OnSuccessNotifications onSuccess;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

  final String feedGroup;
  final int? limit;
  final int? offset;
  final String? session;
  final Filter? filter;
  final EnrichmentFlags? flags;
  final String? ranking;
  final String? userId;
  final ActivityMarker? marker;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NotificationGroup<EnrichedActivity>>>(
      future: StreamFeedCore.of(context)
          .getEnrichedNotifications(feedGroup: feedGroup),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
        }
        if (!snapshot.hasData) {
          return onProgressWidget;
        }
        final notifications = snapshot.data!;
        if (notifications.isEmpty) {
          return onEmptyWidget;
        }
        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, idx) => onSuccess(
            context,
            notifications,
            idx,
          ),
        );
      },
    );
  }
}
