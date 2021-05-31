import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title!"),
      ),
      body: Center(
          child: ReactionList(
        onReactionTap: (reaction) => print(reaction),
        onUserTap: (user) => print(user),
        onMentionTap: (mention) => print("mention $mention"),
        onHashtagTap: (hashtag) => print("hashtag $hashtag"),
        reactions: [
          Reaction(
            user: User(
              data: {
                'name': 'Sloan Humfrey',
                'profile_image': 'https://picsum.photos/id/237/200/300',
              },
            ),
            createdAt: DateTime.now(),
            kind: 'comment',
            data: {
              'text':
                  'Woohoo Snowboarding is awesome! #snowboarding #winter @sacha',
            },
          ),
        ],
      )),
    );
  }
}
