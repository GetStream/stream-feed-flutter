import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:stream_feed_flutter_core/src/states/states.dart';
import 'package:stream_feed_flutter_core/src/typedefs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

//TODO: other things to add to core: FollowListCore, UserListCore
class ReactionListCore extends StatelessWidget {
  const ReactionListCore({
    Key? key,
    required this.feedGroup,
    required this.onSuccess,
    required this.lookupValue,
    this.onErrorWidget = const ErrorStateWidget(),
    this.onProgressWidget = const ProgressStateWidget(),
    this.onEmptyWidget = const EmptyStateWidget(),
    this.lookupAttr = LookupAttribute.activityId,
    this.filter,
    this.kind,
    this.limit,
  }) : super(key: key);

  final OnSuccessReactions onSuccess;
  final Widget onErrorWidget;
  final Widget onProgressWidget;
  final Widget onEmptyWidget;

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
          if (snapshot.hasError) {
            return onErrorWidget; //snapshot.error
          }
          if (!snapshot.hasData) {
            return onProgressWidget;
          }
          final reactions = snapshot.data!;
          if (reactions.isEmpty) {
            return onEmptyWidget;
          }
          return ListView.builder(
            itemCount: reactions.length,
            itemBuilder: (context, idx) => onSuccess(
              context,
              snapshot.data!,
              idx,
            ),
          );
        });
  }
}
