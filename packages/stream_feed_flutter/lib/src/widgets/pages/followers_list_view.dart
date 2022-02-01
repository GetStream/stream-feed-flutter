
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class FollowingListView extends StatefulWidget {
  const FollowingListView({Key? key}) : super(key: key);

  @override
  _FollowingListViewState createState() => _FollowingListViewState();
}

class _FollowingListViewState extends State<FollowingListView> {
  @override
  Widget build(BuildContext context) {
    final bloc = FeedProvider.of(context).bloc;
    return FutureBuilder<List<Follow>>(
      future:
          bloc.client.flatFeed('timeline', bloc.currentUser!.id).following(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].feedId),
              );
            },
          );
        }
      },
    );
  }
}

class FollowersListView extends StatelessWidget {
  const FollowersListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = FeedProvider.of(context).bloc;
    return FutureBuilder<List<Follow>>(
      future: bloc.client.flatFeed('user', bloc.currentUser!.id).followers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final feedName = snapshot.data![index].feedId.split(':').last;
              return ListTile(
                title: Text(feedName),
              );
            },
          );
        }
      },
    );
  }
}