import 'dart:io';

import 'package:stream_feed/stream_feed.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  // '7j7exnksc4nxy399fdxvjqyqsqdahax3nfgtp27pumpc7sfm9um688pzpxjpjbf2';
// gp6e8sxxzud6
  var client = StreamClient.connect(apiKey!, secret: secret);
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
}
