
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FollowStatsWidget extends StatelessWidget {
  const FollowStatsWidget({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  Widget build(BuildContext context) {
    final bloc = FeedProvider.of(context).bloc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user?.followersCount ?? bloc.currentUser!.followersCount}',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Followers',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${user?.followingCount ?? bloc.currentUser!.followingCount}',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              'Following',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ],
    );
  }
}
