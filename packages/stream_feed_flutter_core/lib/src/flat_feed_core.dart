import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FlatFeedCore extends StatelessWidget {
  const FlatFeedCore(
      {Key? key, required this.feedGroup, required this.onSuccess})
      : super(key: key);

  final OnSuccessActivities onSuccess;

  final String feedGroup;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StreamFeedCore.of(context)
            .getEnrichedActivities(feedGroup: feedGroup),
        builder: (BuildContext context,
            AsyncSnapshot<List<EnrichedActivity>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, idx) =>
                    onSuccess(context, snapshot.data!, idx));
            //TODO: no activity to display widget
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return ErrorStateWidget();
          } else {
            return ProgressStateWidget();
          }
        });
  }
}
