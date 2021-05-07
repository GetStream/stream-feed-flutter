import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';
import 'app_user.dart';
import 'extension.dart';

class PeopleScreen extends StatefulWidget {
  final StreamUser currentUser;

  const PeopleScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _PeopleScreenState createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final users = List.from(appUsers)
      ..removeWhere((it) => it.id == widget.currentUser.id);
    final _client = context.client;

    final followDialog = CupertinoAlertDialog(
      title: Text('Follow User?'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, true),
          child: Text("Yes"),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: Navigator.of(context).pop,
          child: Text("No"),
        ),
      ],
    );

    return Container(
      child: Center(
        child: ListView.separated(
          itemCount: users.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final user = users[index];
            return InkWell(
              onTap: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => followDialog,
                );
                if (result != null) {
                  context.showSnackBar('Following User...');

                  final currentUserFeed =
                      _client.flatFeed('timeline', widget.currentUser.id);
                  final selectedUserFeed = _client.flatFeed('user', user.id);
                  await currentUserFeed.follow(selectedUserFeed);

                  context.showSnackBar('Followed User');
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(user.name[0]),
                ),
                title: Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
