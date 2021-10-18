import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

Future<void> main() async {
  const apiKey = String.fromEnvironment('key');
  // Here we are passing in a user token via `dart-define`. In a production
  // application you will want to have authentication and authorization set up,
  // and generate a user token via that process.
  const userToken = String.fromEnvironment('user_token');

  final client = StreamFeedClient.connect(
    apiKey,
    token: const Token(userToken),
  );

  // Here we are setting a default user.
  await client.setUser({
    'name': 'GroovinChip',
    'handle': '@GroovinChip',
    'subtitle': 'Likes building Flutter apps',
    'profile_image': 'https://avatars.githubusercontent.com/u/4250470?v=4',
  });

  final _navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    StreamFeedApp(
      bloc: DefaultFeedBloc(client: client),
      navigatorKey: _navigatorKey,
      home: MobileApp(
        client: client,
      ),
    ),
  );
}

class MobileApp extends StatelessWidget {
  const MobileApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Feed Flutter Sample',
      theme: ThemeData(
        primaryColor: const Color(0xff005fff),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff005fff),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff005fff),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xff005fff),
        ),
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(
        client: client,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            return Avatar(
              user: User(
                data: widget.client.currentUser!.data,
              ),
              onUserTap: (user) {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        title: const Text('Timeline'),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  user: User(
                    data: widget.client.currentUser!.data,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.client.currentUser!.id,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 4),
                Text('${widget.client.currentUser!.data!['handle']}'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${widget.client.currentUser!.followingCount ?? 0} Following'),
                    const SizedBox(width: 8),
                    Text('${widget.client.currentUser!.followersCount ?? 0} Followers'),
                  ],
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 0,
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: [
          FlatActivityListPage(
            flags: EnrichmentFlags()
                .withReactionCounts()
                .withOwnChildren()
                .withOwnReactions(),
            feedGroup: 'user',
            onHashtagTap: (hashtag) => debugPrint('hashtag pressed: $hashtag'),
            onUserTap: (user) =>
                debugPrint('hashtag pressed: ${user!.toJson()}'),
            onMentionTap: (mention) => debugPrint('hashtag pressed: $mention'),
          ),
          const Center(
            child: Text('Notifications'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() => _pageIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Timeline',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bell),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamFeedClient client;

  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final postController = TextEditingController();

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose'),
        actions: [
          ActionChip(
            label: const Text('Post'),
            backgroundColor: const Color(0xff76fff1),
            onPressed: () async {
              if (postController.text.isNotEmpty) {
                try {
                  DefaultFeedBlocProvider.of(context).bloc.onAddActivity(
                    feedGroup: 'user',
                    verb: 'post',
                    object: postController.text,
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  debugPrint(e.toString());
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  user: User(
                    data: widget.client.currentUser?.data,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: postController,
                      autofocus: true,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        hintText: 'What\'s on your mind?',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}