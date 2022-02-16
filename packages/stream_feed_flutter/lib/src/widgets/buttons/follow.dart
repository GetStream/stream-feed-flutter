import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

/// A button to follow or unfollow a user
class FollowButton extends StatefulWidget {
  const FollowButton({Key? key, this.user}) : super(key: key);
  final User? user;

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: FeedProvider.of(context)
          .bloc
          .isFollowingFeed(followerId: widget.user!.id!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        } else {
          return OutlinedButton(
            child: Text(snapshot.data! ? 'Unfollow' : 'Follow'),
            onPressed: () async {
              if (snapshot.data!) {
                await FeedProvider.of(context)
                    .bloc
                    .unfollowFeed(unfolloweeId: widget.user!.id!);
                setState(() {});
              } else {
                await FeedProvider.of(context)
                    .bloc
                    .followFeed(followeeId: widget.user!.id!);
                setState(() {});
              }
            },
          );
        }
      },
    );
  }
}
