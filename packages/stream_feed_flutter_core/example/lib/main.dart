import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('key');
  const userToken = String.fromEnvironment('user_token');
  final client = StreamFeedClient(
    apiKey,
    token: const Token(userToken),
  );

  await client.setUser(
    const User(
      id: 'GroovinChip',
      data: {
        'handle': '@GroovinChip',
        'first_name': 'Reuben',
        'last_name': 'Turner',
        'full_name': 'Reuben Turner',
        'profile_image': 'https://avatars.githubusercontent.com/u/4250470?v=4',
      },
    ),
    const Token(userToken),
  );

  runApp(
    MaterialApp(
      builder: (context, child) => FeedProvider(
        bloc: FeedBloc(
          client: client,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: FlatFeedCore(
          feedGroup: 'user',
          userId: client.currentUser!.id,
          feedBuilder: (BuildContext context, activities, int index) {
            return InkWell(
              child: ListTile(
                title: Text('${activities[index].actor!.data!['handle']}'),
                subtitle:  Text('${activities[index].object}'),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Scaffold(
                      body: ReactionListCore(
                        lookupValue: activities[index].id!,
                        reactionsBuilder: (context, reactions, idx) => Text(
                          '${reactions[index].data?['text']}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
