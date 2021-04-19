frontendToken# Official Flutter packages for [Stream Feed](https://getstream.io/activity-feeds/)

<p align="center">
  <a href="https://github.com/GetStream/stream-feed-flutter/actions?query=workflow%Build"><img alt="Build status" src="https://github.com/GetStream/stream-feed-flutter/workflows/Build/badge.svg"></a>
  <a href="https://codecov.io/gh/GetStream/stream-feed-flutter"><img src="https://codecov.io/gh/GetStream/stream-feed-flutter/branch/master/graph/badge.svg?token=ht6M92zRXx" alt="codecov"></a>
</p>


[stream-dart](https://github.com/GetStream/stream-dart) is the official Dart client for [Stream](https://getstream.io/), a web service for building scalable newsfeeds and activity streams.

You can sign up for a Stream account at https://getstream.io/get_started.

### Installation

#### Install from pub

Next step is to add stream_chat_flutter to your dependencies, to do that just open pubspec.yaml and add it inside the dependencies section.

```yaml
dependencies:
  flutter:
    sdk: flutter

  stream_feed_dart: ^0.0.1
```
#### Using with Flutter

This package can be integrated into Flutter applications. Remember to not expose the App Secret in your Flutter web apps, mobile apps, or other non-trusted environments like desktop apps.

### Usage

### API client setup Node + Browser

If you want to use the API client directly on your web/mobile app you need to generate a user token server-side and pass it.

#### Server-side token generation

```dart

// Instantiate a new client (server side)
  const apiKey = 'gp6e8sxxzud6';
  const secret =
      '7j7exnksc4nxy399fdxvjqyqsqdahax3nfgtp27pumpc7sfm9um688pzpxjpjbf2';

  // Instantiate a new client (server side)
  var client = StreamClient.connect(apiKey, secret: secret);
// Optionally supply the app identifier and an options object specifying the data center to use and timeout for requests (15s)
client = StreamClient.connect(apiKey,
      secret: secret,
      appId: 'yourapid',
      options: StreamHttpClientOptions(
          location: Location.usEast, connectTimeout: Duration(seconds: 15)));

// Create a token for user with id "the-user-id"
  final userToken = client.frontendToken('the-user-id');
```

> :warning: for security reasons, you should not expose your client side only if you use Dart serverside..


#### Client API init

```dart
 //Instantiate new client with a user token
var client = StreamClient.connect(apiKey, token: Token('userToken'));
```

#### Examples

```dart
 // Instantiate a feed object server side
var user1 = client.flatFeed('user', '1');

// Get activities from 5 to 10 (slow pagination)
final activities = user1.getActivities(limit: 5, offset: 5);
// Filter on an id less than a given UUID
final filtered_activities = user1.getActivities(
      limit: 5,
      filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0')

// All API calls are performed asynchronous and return a Promise object
  user1
      .getActivities(
          limit: 5,
          filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'))
      .then((value) => /* on success */
          print(value))
      .onError((error,
              stackTrace) => /* on failure, reason.error contains an explanation */
          print(error));

// Create a new activity
final activity = Activity( actor: '1', verb: 'tweet', object: '1', foreignId: 'tweet:1' );
final added_activity = await user1.addActivity(activity);
// Create a bit more complex activity
final complex_activity = Activity(
    actor: '1',
    verb: 'run',
    object: '1',
    foreignId: 'run:1',
    extraData: {
      'course': {'name': 'Golden Gate park', 'distance': 10},
      'participants': ['Thierry', 'Tommaso'],
      'started_at': DateTime.now().toIso8601String(),
    },
  );
final added_complex_activity = user1.addActivity(complex_activity);

// Remove an activity by its id
await user1.removeActivityById('e561de8f-00f1-11e4-b400-0cc47a024be0');
// or remove by the foreign id
await user1.removeActivityByForeignId('tweet:1');

// mark a notification feed as read
  await notification1.getActivities(
    marker: ActivityMarker().allRead(),
  );


// mark a notification feed as seen
await notification1.getActivities(
    marker: ActivityMarker().allSeen(),
);

// Follow another feed
await user1.follow(client.flatFeed('flat', '42'));

// Stop following another feed
await user1.unfollow(client.flatFeed('flat', '42'));

// Stop following another feed while keeping previously published activities
// from that feed
await user1.unfollow(client.flatFeed('flat', '42'), keepHistory: true);

  // Follow another feed without copying the history
  await user1.follow(client.flatFeed('flat', '42'), activityCopyLimit: 0);

// List followers, following
  await user1.getFollowers(limit: 10, offset: 10);
  await user1.getFollowed(limit: 10, offset: 0);


 await user1.follow(client.flatFeed('flat', '42'));

// adding multiple activities
  const activities = [
    Activity(actor: '1', verb: 'tweet', object: '1'),
    Activity(actor: '2', verb: 'tweet', object: '3'),
  ];
  await user1.addActivities(activities);

 // specifying additional feeds to push the activity to using the to param
// especially useful for notification style feeds
  final to = FeedId.fromIds(['user:2', 'user:3']);
  final activityTo = Activity(
    to: to,
    actor: '1',
    verb: 'tweet',
    object: '1',
    foreignId: 'tweet:1',
  );
  await user1.addActivity(activityTo);


// adding one activity to multiple feeds
  final feeds = FeedId.fromIds(['flat:1', 'flat:2', 'flat:3', 'flat:4']);
  final activityTarget = Activity(
    actor: 'User:2',
    verb: 'pin',
    object: 'Place:42',
    target: 'Board:1',
  );

// ⚠️ server-side only!
  await client.batch.addToMany(activityTarget, feeds!);

  // Batch create follow relations (let flat:1 follow user:1, user:2 and user:3 feeds in one single request)
  const follows = [
    Follow('flat:1', 'user:1'),
    Follow('flat:1', 'user:2'),
    Follow('flat:1', 'user:3'),
  ];

// ⚠️ server-side only!
  await client.batch.followMany(follows);

// Updating parts of an activity
set = {
  'product.price': 19.99,
  shares: {
    facebook: '...',
    twitter: '...',
  },
};
unset = ['daily_likes', 'popularity'];
// ...by ID
client.activityPartialUpdate({
  id: '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4',
  set: set,
  unset: unset,
});
// ...or by combination of foreign ID and time
client.activityPartialUpdate({
  foreignID: 'product:123',
  time: '2016-11-10T13:20:00.000000',
  set: set,
  unset: unset,
});

// ⚠️ server-side only!
// Create redirect urls
impression = {
  content_list: ['tweet:1', 'tweet:2', 'tweet:3'],
  user_data: 'tommaso',
  location: 'email',
  feed_id: 'user:global',
};
engagement = {
  content: 'tweet:2',
  label: 'click',
  position: 1,
  user_data: 'tommaso',
  location: 'email',
  feed_id: 'user:global',
};
events = [impression, engagement];
redirectUrl = client.createRedirectUrl('http://google.com', 'user_id', events);

// update the 'to' fields on an existing activity
// client.feed("user", "ken").function (foreign_id, timestamp, new_targets, added_targets, removed_targets)
// new_targets, added_targets, and removed_targets are all arrays of feed IDs
// either provide only the `new_targets` parameter (will replace all targets on the activity),
// OR provide the added_targets and removed_targets parameters
// NOTE - the updateActivityToTargets method is not intended to be used in a browser environment.
client.feed('user', 'ken').updateActivityToTargets('foreign_id:1234', timestamp, ['feed:1234']);
client.feed('user', 'ken').updateActivityToTargets('foreign_id:1234', timestamp, null, ['feed:1234']);
client.feed('user', 'ken').updateActivityToTargets('foreign_id:1234', timestamp, null, null, ['feed:1234']);
```

### Realtime (Faye)

Stream uses [Faye](http://faye.jcoglan.com) for realtime notifications. Below is quick guide to subscribing to feed changes

```dart
const { connect } = require('getstream');

// ⚠️ userToken is generated server-side (see previous section)
const client = connect('YOUR_API_KEY', userToken, 'APP_ID');
const user1 = client.feed('user', '1');

// subscribe to the changes
const subscription = user1.subscribe(function (data) {
  console.log(data);
});
// now whenever something changes to the feed user 1
// the callback will be called

// To cancel a subscription you can call cancel on the
// object returned from a subscribe call.
// This will remove the listener from this channel.
subscription.cancel();
```

Docs are available on [GetStream.io](http://getstream.io/docs/?language=js).

#### Dart version requirements

This API Client project requires Dart v2.12 at a minimum.

See the [github action configuration](.github/workflows/build.yaml) for details of how it is built, tested and packaged.

## Contributing

See extensive at [test documentation](test/README.md) for your changes.

You can find generic API documentation enriched by code snippets from this package at http://getstream.io/docs/?language=dart

### Copyright and License Information

Project is licensed under the [BSD 3-Clause](LICENSE).