# Official Core [Flutter SDK](https://getstream.io/activity-feeds/sdk/flutter/tutorial/) for [Stream Feeds](https://getstream.io/activity-feeds/)

> The official Flutter core components for Stream Feeds, a service for
> building activity feeds.

**🔗 Quick Links**

- [Register](https://getstream.io/activity-feeds/try-for-free) to get an API key for Stream Activity Feeds
- [Tutorial](https://getstream.io/activity-feeds/sdk/flutter/tutorial/) to learn how to setup a timeline feed, follow other feeds and post new activities.
- [Stream Activity Feeds UI Kit](https://getstream.io/activity-feeds/ui-kit/) to jumpstart your design with notifications and social feeds

#### Install from pub <a href="https://pub.dartlang.org/packages/stream_feed_flutter_core"><img alt="Pub" src="https://img.shields.io/pub/v/stream_feed_flutter_core.svg"></a>

Next step is to add `stream_feed_flutter_core` to your dependencies, to do that just open pubspec.yaml and add it inside the dependencies section. 

```yaml
dependencies:
  flutter:
    sdk: flutter

  stream_feed_flutter_core: ^[latest-version]
```

Then run `flutter packages get`

This package requires no custom setup on any platform since it does not depend on any platform-specific dependency.


### Changelog

Check out the [changelog on pub.dev](https://pub.dev/packages/stream_feed_flutter_core/changelog) to see the latest changes in the package.

## Usage

This package provides business logic to fetch common things required for integrating Stream Feeds into your application.
The core package allows more customisation and hence provides business logic but no UI components.


A simple example:

```dart
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
  const apiKey = 'API-KEY';
  const userToken = 'USER-TOKEN';
  final client = StreamFeedClient(
    apiKey,
    token: const Token(userToken),
  );

  runApp(
    MaterialApp(
      /// Wrap your application in a `FeedProvider`. This requires a `FeedBloc`.
      /// The `FeedBloc` is used to perform various Stream Feed operations.
      builder: (context, child) => FeedProvider(
        bloc: FeedBloc(client: client),
        child: child!,
      ),
      home: Scaffold(
        /// Returns `Activities`s for the given `feedGroup` in the `feedBuilder`.
        body: FlatFeedCore(
          feedGroup: 'user',
          feedBuilder: (BuildContext context, activities, int index) {
            return InkWell(
              child: Column(children: [
                Text("${activities[index].actor}"),
                Text("${activities[index].object}"),
              ]),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Scaffold(
                      /// Returns `Reaction`s for the given
                      /// `lookupValue` in the `reactionsBuilder`.
                      body: ReactionListCore(
                        lookupValue: activities[index].id!,
                        reactionsBuilder: (context, reactions, idx) =>
                            Text("${reactions[index].data?["text"]}"),
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
```

## Docs

This package provides business logic to fetch common things required for integrating Stream Feed into your application.
The core package allows more customisation and hence provides business logic but no UI components.
Use stream_feed for the low-level client.

The package primarily contains three types of classes:

1) Business Logic Components
2) Core Components

### Business Logic Components

These components allow you to have the maximum and lower-level control of the queries being executed.
The BLoCs we provide are:

1) FeedBloc

### Core Components

Core components usually are an easy way to fetch data associated with Stream Feed which are decoupled from UI and often expose UI builders.
Data fetching can be controlled with the controllers of the respective core components.

1) FlatFeedCore (Fetch a list of activities)
2) ReactionListCore (Fetch a list of reactions)
3) FeedProvider (Inherited widget providing bloc to the widget tree)

## Contributing

We welcome code changes that improve this library or fix a problem,
please make sure to follow all best practices and add tests if applicable before submitting a Pull Request on Github.
We are pleased to merge your code into the official repository.
Make sure to sign our [Contributor License Agreement (CLA)](https://docs.google.com/forms/d/e/1FAIpQLScFKsKkAJI7mhCr7K9rEIOpqIDThrWxuvxnwUq2XkHyG154vQ/viewform) first.
See our license file for more details.