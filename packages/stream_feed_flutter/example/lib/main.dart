import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  final appId = env['appId'];
  final frontendToken = env['frontendToken'];
  // final clientForScret = StreamFeedClient.connect(
  //   apiKey!,
  //   secret: secret,
  //   runner: Runner.server,
  // );
  final client = StreamFeedClient.connect(apiKey!,
      token: Token(frontendToken!) //clientForScret.frontendToken('sachaid'),
      );
  await client.setUser({
    'name': 'Rosemary',
    'handle': '@rosemary',
    'subtitle': 'likes playing fresbee in the park',
    'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
  });

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  MyApp({required this.client});
  final StreamFeedClient client;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', client: client),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, this.title, required this.client}) : super(key: key);
  final StreamFeedClient client;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlatFeed"),
      ),
      body: StreamFeedCore(
        client: client,
        child: FlatActivityListPage(
          feedGroup: 'user',
          onHashtagTap: (hashtag) => print('hashtag pressed: $hashtag'),
          onUserTap: (user) => print('hashtag pressed: ${user!.toJson()}'),
          onMentionTap: (mention) => print('hashtag pressed: $mention'),
        ),
      ),
    );
  }
}
