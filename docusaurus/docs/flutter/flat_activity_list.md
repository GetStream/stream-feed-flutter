# `FlatActivityList()`

A Widget for displaying a list of activities

## Background

Activities are fundamental to Stream Feed. In Stream Feeds, an item in a feed is called an `activity`. In its simplest form, an `activity` consists of an `actor`, a `verb`, and an `object`. It tells the story of a person performing an action on or with an object.

Read more about activities [here]().

## Constructor

Let's take a look at the constructor for `FlatActivityList()`:
```dart
  const FlatActivityListPage({
    Key? key,
    this.feedGroup = 'user',
    this.onHashtagTap,
    this.onMentionTap,
    this.onUserTap,
    this.activityFooterBuilder,
    this.activityContentBuilder,
    this.activityHeaderBuilder,
    this.limit,
    this.offset,
    this.session,
    this.filter,
    this.flags,
    this.ranking,
    this.handleJsonKey = 'handle',
    this.nameJsonKey = 'name',
    this.onProgressWidget = const ProgressStateWidget(),
    this.onErrorWidget = const ErrorStateWidget(),
    this.onEmptyWidget =
        const EmptyStateWidget(message: 'No activities to display'),
    this.onActivityTap,
    this.transitionType = TransitionType.material,
  }) : super(key: key);
```

## Basic Example

Below is a basic example of the `FlatActivityList()` widget. It uses the [FlatFeedCore]() widget to build a list of [ActivityWidget]()s, which in turn uses a `FutureBuilder()` to fetch the activities. It must be wrapped in a [StreamFeedCore]() widget in order to work.

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
    this.title,
    required this.client,
    required this.navigatorKey,
  }) : super(key: key);

  final StreamFeedClient client;
  final String? title;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Avatar(),
        ),
        title: const Text('FlatFeed'),
      ),
      body: StreamFeedCore(
        client: client,
        navigatorKey: navigatorKey,
        child: FlatActivityListPage(
          nameJsonKey: 'full_name',
          flags: EnrichmentFlags()
              .withReactionCounts()
              .withOwnChildren()
              .withOwnReactions(),
          feedGroup: 'timeline',
          onHashtagTap: (hashtag) => debugPrint('hashtag pressed: $hashtag'),
          onUserTap: (user) => debugPrint('hashtag pressed: ${user!.toJson()}'),
          onMentionTap: (mention) => debugPrint('hashtag pressed: $mention'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NewPostScreen(),
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
```

If there are no activities in your feed group, you will get a blank screen saying there are no activities. Otherwise, you will see a list of `ActivityWidget()`s.