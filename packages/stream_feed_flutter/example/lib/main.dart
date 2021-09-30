import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

Future<void> main() async {
  final env = Platform.environment;

  final secret = env['secret'];
  final apiKey = env['apiKey'];
  final appId = env['appId'];
  final frontendToken = env['frontendToken'];

  late final Token token;
  if (frontendToken != null) {
    token = Token(frontendToken);
  } else {
    final server = StreamFeedServer(
      apiKey!,
      secret: secret!,
      appId: appId,
    );
    token = server.frontendToken('sachaid');
  }
  final client = StreamFeedClient(apiKey!);

  await client.setCurrentUser(const User(id: 'sachaid'), token, extraData: {
    'name': 'Rosemary',
    'handle': '@rosemary',
    'subtitle': 'likes playing fresbee in the park',
    'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
  });

  runApp(MyApp(client: client));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);
  final StreamFeedClient client;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feeds Demo',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        client: widget.client,
        navigatorKey: _navigatorKey,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    required this.client,
    required this.navigatorKey,
  }) : super(key: key);
  final StreamFeedClient client;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlatFeed"),
      ),
      body: StreamFeedTheme(
        data: StreamFeedThemeData(),
        child: StreamFeedCore(
          client: client,
          navigatorKey: navigatorKey,
          child: FlatActivityListPage(
            flags: EnrichmentFlags()
                .withReactionCounts()
                .withOwnChildren()
                .withOwnReactions(),
            feedGroup: 'FlatFeed',
            onHashtagTap: (hashtag) => print('hashtag pressed: $hashtag'),
            onUserTap: (user) => print('hashtag pressed: ${user!.toJson()}'),
            onMentionTap: (mention) => print('hashtag pressed: $mention'),
            onEmptyWidget: ElevatedButton(
              onPressed: () {
                client.flatFeed('FlatFeed').addActivity(Activity(
                    actor: client.currentUser!.ref,
                    verb: 'verb',
                    object: 'object'));
              },
              child: const Text('Add activity'),
            ),
          ),
        ),
      ),
    );
  }
}
