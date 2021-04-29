import 'dart:io';

import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  final client = StreamClient.connect(apiKey!, secret: secret); //Token(token!)
  final chris = client.flatFeed('user', 'chris');

// Add an Activity; message is a custom field - tip: you can add unlimited custom fields!
  final addedPicture = await chris.addActivity(Activity(
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
  final user1 = client.flatFeed('user', '1');

// Create an activity object
  var activity = Activity(actor: 'User:1', verb: 'pin', object: 'Place:42');

// Add an activity to the feed
  final pinActivity = await user1.addActivity(activity);
  print('HEY ${pinActivity.id}');

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

  final exercise = await user1.addActivity(activity);

  // Get 5 activities with id less than the given UUID (Faster - Recommended!)
  var response = await user1.getActivities(
      limit: 5,
      filter: Filter().idLessThan("e561de8f-00f1-11e4-b400-0cc47a024be0"));
// Get activities from 5 to 10 (Pagination-based - Slower)
  response = await user1.getActivities(offset: 0, limit: 5);
// Get activities sorted by rank (Ranked Feeds Enabled):
  // response = await userFeed.getActivities(limit: 5, ranking: "popularity");//must be enabled

  // Remove an activity by its id
  await user1.removeActivityById(addedPicture.id!);

// Remove activities foreign_id 'run:1'
  await user1.removeActivityByForeignId('run:1');

  // partial update by activity ID
  // await user1.updateActivityById(ActivityUpdate(id:pinActivity.id!, set:{
  //   // 'product.price': 19.99,
  //   'shares': {'facebook': '...', 'twitter': '...'},
  // }));

// partial update by foreign ID
// client.activityPartialUpdate({
//   foreign_id: 'product:123',
//   time: '2016-11-10T13:20:00.000000',
//   set: {
//     ...
//   },
//   unset: [
//     ...
//   ]
// })

//Batching Partial Updates TODO
final now = DateTime.now();
  final first_activity = Activity(
    actor: '1',
    verb: 'add',
    object: '1',
    foreignId: 'activity_1',
    time: DateTime.now(),
  );

// Add activity to activity feed:
  final firstActivityAdded = await user1.addActivity(first_activity);

  final second_activity = Activity(
      actor: '1',
      verb: 'add',
      object: '1',
      foreignId: 'activity_2',
      time: now);

  final secondActivityAdded = await user1.addActivity(second_activity);
  
}
