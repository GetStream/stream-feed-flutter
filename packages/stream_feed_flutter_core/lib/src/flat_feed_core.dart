import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FlatFeedCore extends StatelessWidget {
  const FlatFeedCore(
      {Key? key,
      required this.feedGroup,
      required this.onSuccess,
      this.onErrorWidget = const ErrorStateWidget(),
      this.onProgressWidget = const ProgressStateWidget(),
      this.onEmptyWidget =
          const EmptyStateWidget(message: 'No activties to display')})
      : super(key: key);

  final OnSuccessActivities onSuccess;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

  final String feedGroup;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EnrichedActivity>>(
      future: StreamFeedCore.of(context)
          .getEnrichedActivities(feedGroup: feedGroup),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return onErrorWidget; //TODO: snapshot.error / do we really want backend error here?
        }
        if (!snapshot.hasData) {
          return onProgressWidget;
        }
        final activities = snapshot.data!;
        if (activities.isEmpty) {
          return onEmptyWidget;
        }
        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, idx) => onSuccess(
            context,
            activities,
            idx,
          ),
        );
      },
    );
  }
}
