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
        child: Card(
          child: CommentItem(
            user: User(data: {
              'name': 'Rosemary',
              'subtitle': 'likes playing fresbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            }),
            reaction: Reaction(
              createdAt: DateTime.now(),
              kind: 'comment',
              data: {
                'text':
                    'Woohoo Snowboarding is awesome! #snowboarding #winter @sacha',
              },
            ),
            onMentionTap: (String? mention) {
              print(mention);
            },
            onHashtagTap: (String? hashtag) {
              print(hashtag);
            },
          ),
        ),
      ),
    );
  }
}
