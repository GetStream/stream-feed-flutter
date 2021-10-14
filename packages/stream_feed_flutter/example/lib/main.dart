
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

Future<void> main() async {
  const secret = String.fromEnvironment('secret');
  const apiKey = String.fromEnvironment('apiKey');
  const appId = String.fromEnvironment('appId');
  const frontendToken = String.fromEnvironment('frontendToken');
  final clientForScret = StreamFeedClient.connect(
    apiKey,
    secret: secret,
    runner: Runner.server,
  );
  final client = StreamFeedClient.connect(
    apiKey,
    token: clientForScret.frontendToken('sachaid'), //Token(frontendToken!)
  );
  await client.setUser({
    'name': 'Rosemary',
    'handle': '@rosemary',
    'subtitle': 'likes playing fresbee in the park',
    'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
  });
  final _navigatorKey = GlobalKey<NavigatorState>();
  runApp(MyApp(client: client, navigatorKey: _navigatorKey));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client, required this.navigatorKey})
      : super(key: key);
  final StreamFeedClient client;
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return StreamFeedApp(
      bloc: DefaultFeedBloc(client: client),
      navigatorKey: navigatorKey,
      // title: 'Flutter Demo',//TODO: pass down those props
      // navigatorKey: _navigatorKey,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlatFeed"),
      ),
      body: FlatActivityListPage(
        flags: EnrichmentFlags()
            .withReactionCounts()
            .withOwnChildren()
            .withOwnReactions(),
        feedGroup: 'user',
        onHashtagTap: (hashtag) => print('hashtag pressed: $hashtag'),
        onUserTap: (user) => print('hashtag pressed: ${user!.toJson()}'),
        onMentionTap: (mention) => print('hashtag pressed: $mention'),
      ),
    );
  }
}
