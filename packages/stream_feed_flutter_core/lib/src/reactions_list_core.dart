import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';
//TODO: other things to add to core FollowListCore
class ReactionsListCore extends StatelessWidget {
  const ReactionsListCore({
    Key? key,
    required this.feedGroup,
    required this.onSuccess,
    this.lookupAttr = LookupAttribute.activityId,
    required this.lookupValue,
    this.filter,
    this.kind,
    this.limit,
  }) : super(key: key);

  final OnSuccessReactions onSuccess;
  final LookupAttribute lookupAttr;
  final String lookupValue;
  final Filter? filter;
  final int? limit;
  final String? kind;

  final String feedGroup;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: StreamFeedCore.of(context).getReactions(lookupAttr, lookupValue,
            filter: filter, limit: limit, kind: kind),
        builder:
            (BuildContext context, AsyncSnapshot<List<Reaction>> snapshot) {
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
