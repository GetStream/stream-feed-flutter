import 'package:stream_feed/stream_feed.dart';

main() async {
  const apiKey = 'gp6e8sxxzud6';
  const secret =
      '7j7exnksc4nxy399fdxvjqyqsqdahax3nfgtp27pumpc7sfm9um688pzpxjpjbf2';

  var client = StreamClient.connect(apiKey, secret: secret);

  var user1 = client.flatFeed('user', '1');
  final activity = Activity(
    actor: "user.id",
    verb: 'tweet',
    object: '1',
    extraData: {
      'course': {'name': 'Golden Gate park', 'distance': 10},
      'participants': ['Thierry', 'Tommaso'],
      'started_at': DateTime.now().toIso8601String(),
    },
  );
  final addedComplexActivity = await user1.addActivity(activity);

// Remove an activity by its id
  await user1.removeActivityById('e561de8f-00f1-11e4-b400-0cc47a024be0');
// or remove by the foreign id
  await user1.removeActivityByForeignId('tweet:1');

  // mark a notification feed as read
  final notification1 = client.notificationFeed('notification', '1');

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
}
