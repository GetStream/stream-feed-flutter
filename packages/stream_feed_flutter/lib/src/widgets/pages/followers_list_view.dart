import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

typedef FollowingListViewBuilder = Widget Function(User model);

/// Displays a list of users the current user is following
class FollowingListView extends StatelessWidget {
  final String handleJsonKey;
  final String nameJsonKey;
  final FollowingListViewBuilder? builder;
  const FollowingListView(
      {Key? key,
      this.handleJsonKey = 'handle',
      this.nameJsonKey = 'name',
      this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = FeedProvider.of(context).bloc;
    return FutureBuilder<List<User>>(
      future: bloc.followingUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              final displayName = user.data?[handleJsonKey] as String? ??
                  user.data?[nameJsonKey] as String?;
              return builder?.call(user) ??
                  ListTile(
                      leading: Avatar(
                        user: user,

                        // onUserTap: onUserTap,
                        size: UserBarTheme.of(context).avatarSize,
                      ),
                      title: Text(displayName ?? 'unknown'));
            },
          );
        }
      },
    );
  }
}

/// Displays a list of followers for the current user
class FollowersListView extends StatelessWidget {
  final String handleJsonKey;
  final String nameJsonKey;
  final FollowingListViewBuilder? builder;
  const FollowersListView(
      {Key? key,
      this.handleJsonKey = 'handle',
      this.nameJsonKey = 'name',
      this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = FeedProvider.of(context).bloc;
    return FutureBuilder<List<User>>(
      future: bloc.followersUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              final displayName = user.data?[handleJsonKey] as String? ??
                  user.data?[nameJsonKey] as String?;
              return builder?.call(user) ??
                  ListTile(
                      leading: Avatar(
                        user: user,

                        // onUserTap: onUserTap,
                        size: UserBarTheme.of(context).avatarSize,
                      ),
                      title: Text(displayName ?? 'unknown'));
              // ListTile(
              //   title: Text(displayName ?? 'unknown'),
              // );
            },
          );
        }
      },
    );
  }
}



class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FollowingListView(),
      ),
    );
  }
}

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const FollowersListView(),
      ),
    );
  }
}
