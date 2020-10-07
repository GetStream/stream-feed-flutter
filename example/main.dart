import 'package:stream_feed_dart/stream_feed.dart';

main() async {
  final client = StreamClient.connect(
    '9wbdt7vucby6',
    'bksn37r6k7j5p75mmy6znts47j9f9pc49bmw3jjyd7rshg2enbcnq666d2ryfzs8',
  );

  final batch = client.batch;
  // batch.addToMany(
  //   Activity(
  //     actor: 'User:2',
  //     object: 'Place:42',
  //     verb: 'pin',
  //   ),
  //   [
  //     FeedId('timeline', '123'),
  //     FeedId('timeline', '789'),
  //   ],
  // );
  // batch.getActivitiesById(['ef696c12-69ab-11e4-8080-80003644b625']);

  final reactions = client.reactions;
  // reactions.get('');
  // reactions.update('');
  // reactions.add(
  //   'like',
  //   '65bca63a-7d61-48e8-be9d-c6665a008196',
  //   'bob',
  //   data: {
  //     'extra': 'data',
  //   },
  //   targetFeeds: [
  //     FeedId('timeline', '123'),
  //     FeedId('timeline', '789'),
  //   ],
  // );
  // reactions.addChild(
  //   'comment',
  //   'd35fd62e-ac97-4c0d-9a06-30019aaf05ea',
  //   'bob',
  //   data: {
  //     'extra': 'data',
  //   },
  //   targetFeeds: [
  //     FeedId('timeline', '123'),
  //     FeedId('timeline', '789'),
  //   ],
  // );
  // reactions.get('d35fd62e-ac97-4c0d-9a06-30019aaf05ea');
  // reactions.update(
  //   'd35fd62e-ac97-4c0d-9a06-30019aaf05ea',
  //   data: {'sahil': 'kumar'},
  // );
  // reactions.paginatedFilter(
  //   LookupAttribute.user_id,
  //   'bob',
  // );
  // reactions.filter(LookupAttribute.user_id, 'bob');

  final users = client.users;
  // users.add('sahil-kumar', {
  //   'first_name': 'sahil',
  //   'last_name': 'kumar',
  //   'full_name': 'sahil kumar',
  // });
  // users.get('sahil-kumar');
  // users.update('sahil-kumar', {
  //   'role': 'Flutter Developer',
  // });
  // print(users.ref('sahil-kumar'));
  // users.delete('sahil-kumar');

  final collections = client.collections;
  // collections.add(
  //   'Toothpaste',
  //   {
  //     'name': 'Colgate',
  //     'weight': '200g',
  //     'color': 'white',
  //   },
  //   entryId: 'colgate-200',
  // );
  // collections.upsert(
  //   'Toothpaste',
  //   [
  //     CollectionEntry(
  //       id: 'colgate-300',
  //       data: {
  //         'name': 'Colgate',
  //         'weight': '300g',
  //         'color': 'white',
  //       },
  //     ),
  //   ],
  // );

  // final token = client.frontendToken('sahil-kumar');
  // print(token);

  final chris = client.notificationFeed("notification", "chris");
  // Add an Activity; message is a custom field - tip: you can add unlimited custom fields!
  // final data = await chris.addActivity(
  //   Activity(
  //       actor: 'chris',
  //       verb: 'add',
  //       object: 'picture:10',
  //       foreignId: 'picture:10',
  //       extraData: {'message': 'Beautiful Bird!'}),
  // );

  // print(data);

  // // Create a following relationship between Jack's "timeline" feed and Chris' "user" feed:
  // final jack = client.aggregatedFeed("timeline_aggregated", "jack");
  // await jack.follow(chris);

  // Read Jack's timeline and Chris' post appears in the feed:
  // final response = await jack.getActivities();
  final response = await chris.getEnrichedActivities();

  // client.openGraph('https://github.com/xsahil03x');
}
