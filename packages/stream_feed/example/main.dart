import 'dart:io';

import 'package:stream_feed/stream_feed.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  var client = StreamClient.connect(apiKey!, secret: secret); //Token(token!)
  final chris = client.flatFeed('user', 'chris');

// Add an Activity; message is a custom field - tip: you can add unlimited custom fields!
  await chris.addActivity(Activity(
      actor: 'chris',
      verb: 'add',
      object: 'picture:10',
      foreignId: 'picture:10',
      extraData: {'message': 'Beautiful bird!'}));

// Create a following relationship between Jack's "timeline" feed and Chris' "user" feed:
  final jack = client.flatFeed('timeline', 'jack');
  await jack.follow(chris);

// Read Jack's timeline and Chris' post appears in the feed:
  final results = await jack.getActivities(limit: 10);

// Remove an Activity by referencing it's Foreign Id:
  await chris.removeActivityByForeignId('picture:10');

  // Instantiate a feed using feed group 'user' and user id '1'
  var user1 = client.flatFeed('user', '1');

// Create an activity object
  var activity = Activity(actor: 'User:1', verb: 'pin', object: 'Place:42');

// Add an activity to the feed
  final pinActivity = await user1.addActivity(activity);

// Instantiate a feed for feed group 'user', user id '1'
// and a security token generated server side
  final userFeed = client.flatFeed('user', '1');

// Create a bit more complex activity
  activity =
      Activity(actor: 'User:1', verb: 'run', object: 'Exercise:42', extraData: {
    'course': const {'name': 'Golden Gate park', 'distance': 10},
    'participants': const ['Thierry', 'Tommaso'],
    'started_at': DateTime.now().toIso8601String(),
    'foreign_id': 'run:1',
    'location': const {
      'type': 'point',
      'coordinates': [37.769722, -122.476944]
    }
  });

  await user1.addActivity(activity);

  // Get 5 activities with id less than the given UUID (Faster - Recommended!)
  var response = await userFeed.getActivities(
      limit: 5,
      filter: Filter().idLessThan("e561de8f-00f1-11e4-b400-0cc47a024be0"));
// Get activities from 5 to 10 (Pagination-based - Slower)
  response = await userFeed.getActivities(offset: 0, limit: 5);
// Get activities sorted by rank (Ranked Feeds Enabled):
  // response = await userFeed.getActivities(limit: 5, ranking: "popularity");

  // Remove an activity by its id
  await user1.removeActivityById(pinActivity.id!);

// Remove activities foreign_id 'run:1'
  await user1.removeActivityByForeignId('run:1');
}
