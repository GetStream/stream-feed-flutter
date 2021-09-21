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

As you can see, by default the `feedGroup` is `user`. If you have would like to use this widget for any other feed you've created in the dashboard you'll need to specify that feed's ID as the `feedGroup`.

## Properties

Let's go through the properties seen in [constructor](#constructor) and describe their purpose.

### Builders

`onHashtagTap`, `onMentionTap`, and `onUserTap` are callbacks that allow you to customize what happens when you tap a hashtag, mention, or user in an activity. 

`activityFooterBuilder`, `activityContentBuilder`, and `activityHeaderBuilder` are Widget builders that allow you to build the widgets representing an activity to your own specification.

`onErrorWidget`, `onProgressWidget`, and `onEmptyWidget` are Widget builders that allow you to customize the UI according to specific events - an error, loading, and when there are no activities to display.

### Filters and Flags

```dart
/// The filter to use for the request
final Filter? filter;

/// The flags to use for the request
final EnrichmentFlags? flags;
```

A `Filter` allows you to specify what kinds of activities should be displayed. An example of a `filter` is:

```dart
// TODO: Filter example
```

`EnrichmentFlag`s indicate to the API that activities should be enriched with additional information, like user reactions and count. Read more about activity enrichment [here](https://getstream.io/activity-feeds/docs/flutter-dart/enrichment/).

### Other Properties

* `transitionType` - An experimental enum that customizes the type of animation used when navigating to and from activities. Can be `material`, `cupertino`, or `sharedAxisTransition`.
* `limit` - The limit of activities to fetch
* `offset` - The offset of activities to fetch. By specifying the offset, you retrieve a subset of records starting with the offset value. Offset normally works with length , which determines how many records to retrieve starting from the offset.
* `session` - <!--TODO: session -->
* `ranking`- <!--TODO: ranking -->

Check out our [pub.dev documentation]() for more information on the remaining properties.

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