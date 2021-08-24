import 'package:example/app_user.dart';
import 'package:example/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed/stream_feed.dart';

//ignore: public_member_api_docs
class PeopleScreen extends StatefulWidget {
  //ignore: public_member_api_docs
  const PeopleScreen({
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  //ignore: public_member_api_docs
  final StreamUser currentUser;

  @override
  _PeopleScreenState createState() => _PeopleScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<StreamUser>('currentUser', currentUser));
  }
}

class _PeopleScreenState extends State<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final users = List<AppUser>.from(appUsers)
      ..removeWhere((it) => it.id == widget.currentUser.id);
    final _client = context.client;

    final followDialog = CupertinoAlertDialog(
      title: const Text('Follow User?'),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: Navigator.of(context).pop,
          child: const Text('No'),
        ),
      ],
    );

    return Center(
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
