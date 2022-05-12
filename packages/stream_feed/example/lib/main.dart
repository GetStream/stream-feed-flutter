// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:stream_feed/stream_feed.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  final appId = env['appId'];
  final clientWithSecret = StreamFeedClient(
    apiKey!,
    secret: secret,
    runner: Runner.server,
  );

  final chris = clientWithSecret.flatFeed('user', 'chris');

  // Add an Activity; message is a custom field
  // Tip: you can add unlimited custom fields!
  final addedPicture = await chris.addActivity(
    const Activity(
      actor: 'chris',
      verb: 'add',
      object: 'picture:10',
      foreignId: 'picture:10',
      extraData: {'message': 'Beautiful bird!'},
    ),
  );

  // Create a following relationship between Jack's "timeline" feed and Chris'
  // "user" feed:
  final jack = clientWithSecret.flatFeed('timeline', 'jack');
  await jack.follow(chris);

// Read Jack's timeline and Chris' post appears in the feed:
  final results = await jack.getActivities(limit: 10);

// Remove an Activity by referencing it's Foreign Id:
  await chris.removeActivityByForeignId('picture:10');

  // Instantiate a feed using feed group 'user' and user id '1'
  final user1 = clientWithSecret.flatFeed('user', '1');

// Create an activity object
  var activity =
      const Activity(actor: 'User:1', verb: 'pin', object: 'Place:42');

// Add an activity to the feed
  final pinActivity = await user1.addActivity(activity);

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
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
  );

// Get activities from 5 to 10 (Pagination-based - Slower)
  response = await user1.getActivities(offset: 0, limit: 5);
// Get activities sorted by rank (Ranked Feeds Enabled):
  // response = await userFeed.getActivities(limit: 5, ranking: "popularity");//must be enabled

// Server-side
  var client = StreamFeedClient(
    apiKey,
    secret: secret,
    appId: appId,
    runner: Runner.server,
    options: const StreamHttpClientOptions(location: Location.usEast),
  );

  final userToken = client.frontendToken('user.id');

// Client-side
  client = StreamFeedClient(
    apiKey,
    appId: appId,
  );

  // Remove an activity by its id
  await user1.removeActivityById(addedPicture.id!);

// Remove activities foreign_id 'run:1'
  await user1.removeActivityByForeignId('run:1');

  final now = DateTime.now();

  activity = Activity(
      actor: '1',
      verb: 'like',
      object: '3',
      time: now,
      foreignId: 'like:3',
      extraData: const {
        'popularity': 100,
      });

// first time the activity is added
  final like = await user1.addActivity(activity);

// send the update to the APIs
  user1.updateActivityById(id: like.id!,
      // update the popularity value for the activity
      set: {
        'popularity': 10,
      });

  // partial update by activity ID
  await user1.updateActivityById(id: exercise.id!, set: {
    'course.distance': 12,
    'shares': {
      'facebook': '...',
      'twitter': '...',
    },
  }, unset: [
    'location',
    'participants'
  ]);

// partial update by foreign ID
// user1.updateActivityByForeignId(
//   foreignId: 'product:123',
//   time: DateTime.parse(('2016-11-10T13:20:00.000000'),
//   set: {
//     ...
//   },
//   unset: [
//     ...
//   ]
// );

//Batching Partial Updates TODO
  // final now = DateTime.now();
  final firstActivity = Activity(
    actor: '1',
    verb: 'add',
    object: '1',
    foreignId: 'activity_1',
    time: DateTime.now(),
  );

// Add activity to activity feed:
  final firstActivityAdded = await user1.addActivity(firstActivity);

  final secondActivity = Activity(
      actor: '1', verb: 'add', object: '1', foreignId: 'activity_2', time: now);

  final secondActivityAdded = await user1.addActivity(secondActivity);

  //Following Feeds
  // timeline:timeline_feed_1 follows user:user_42:
  final timelineFeed1 =
      clientWithSecret.flatFeed('timeline', 'timeline_feed_1');
  final user42feed = clientWithSecret.flatFeed('user', 'user_42');
  await timelineFeed1.follow(user42feed);

// Follow feed without copying the activities:
  await timelineFeed1.follow(user42feed, activityCopyLimit: 0);

  //Unfollowing feeds
  // Stop following feed user_42 - purging history:
  await timelineFeed1.unfollow(user42feed);

// Stop following feed user_42 but keep history of activities:
  await timelineFeed1.unfollow(user42feed, keepHistory: true);

//Reading Feed Followers
  // List followers
  await user1.followers(limit: 10, offset: 10);
  // Retrieve last 10 feeds followed by user_feed_1
  await user1.following(offset: 0, limit: 10);

// Retrieve 10 feeds followed by user_feed_1 starting from the 11th
  await user1.following(offset: 10, limit: 10);

// Check if user1 follows specific feeds
  await user1.following(
      offset: 0,
      limit: 2,
      filter: [FeedId.id('user:42'), FeedId.id('user:43')]);

  // get follower and following stats of the feed
  await clientWithSecret.flatFeed('user', 'me').followStats();

// get follower and following stats of the feed but also filter with given slugs
// count by how many timelines follow me
// count by how many markets are followed
  await clientWithSecret
      .flatFeed('user', 'me')
      .followStats(followerSlugs: ['timeline'], followingSlugs: ['market']);
//Realtime
  final frontendToken = clientWithSecret.frontendToken('john-doe');

//Use Case: Mentions
  // Add the activity to Eric's feed and to Jessica's notification feed
  activity = Activity(
    actor: 'user:Eric',
    extraData: const {
      'message': "@Jessica check out getstream.io it's awesome!",
    },
    verb: 'tweet',
    object: 'tweet:id',
    to: [FeedId.id('notification:Jessica')],
  );

  final tweet = await user1.addActivity(activity);

  // add a like reaction to the activity with id activityId
  await clientWithSecret.reactions.add('like', tweet.id!, userId: 'userId');

// adds a comment reaction to the activity with id activityId
  await clientWithSecret.reactions.add('comment', tweet.id!,
      data: {'text': 'awesome post!'}, userId: 'userId');

// for server side auth, userId is required
  final comment = await clientWithSecret.reactions.add('comment', tweet.id!,
      data: {'text': 'awesome post!'}, userId: 'userId');

// first let's read current user's timeline feed and pick one activity
  final activities =
      await clientWithSecret.flatFeed('user', '1').getActivities();

// then let's add a like reaction to that activity
  final otherLike = await clientWithSecret.reactions
      .add('like', activities.first.id!, userId: 'userId');

// retrieve all kind of reactions for an activity
  await clientWithSecret.reactions.filter(
      LookupAttribute.activityId, '5de5e4ba-add2-11eb-8529-0242ac130003');

// retrieve first 10 likes for an activity
  await clientWithSecret.reactions.filter(
      LookupAttribute.activityId, '5de5e4ba-add2-11eb-8529-0242ac130003',
      kind: 'like', limit: 10);

// retrieve the next 10 likes using the id_lt param
  await clientWithSecret.reactions.filter(
    LookupAttribute.activityId,
    '5de5e4ba-add2-11eb-8529-0242ac130003',
    kind: 'like',
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
  );

  // await clientWithSecret.reactions
  //     .update(comment.id!, data: {'text': 'love it!'});

// read bob's timeline and include most recent reactions to all activities and
// their total count
  await clientWithSecret.flatFeed('timeline', 'bob').getEnrichedActivities(
        flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
      );

// read bob's timeline and include most recent reactions to all activities and
// her own reactions
  await clientWithSecret.flatFeed('timeline', 'bob').getEnrichedActivities(
        flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
      );

// adds a comment reaction to the activity and notifies Thierry's notification
// feed
  await clientWithSecret.reactions.add(
      'comment', '5de5e4ba-add2-11eb-8529-0242ac130003',
      data: {'text': '@thierry great post!'},
      userId: 'userId',
      targetFeeds: [FeedId.id('notification:thierry')]);

  // adds a like to the previously created comment
  await clientWithSecret.reactions
      .addChild('like', comment.id!, userId: 'userId');
  await clientWithSecret.reactions.delete(comment.id!);
//Adding Collections
  // await client.collections.add(
  //   'food',
  //   {'name': 'Cheese Burger', 'rating': '4 stars'},
  //   entryId: 'cheese-burger',
  // );//will throw an error if entry-id already exists

// if you don't have an id on your side, just use null as the ID and Stream will
// generate a unique ID
  final entry = await clientWithSecret.collections
      .add('food', {'name': 'Cheese Burger', 'rating': '4 stars'});
  await clientWithSecret.collections.get('food', entry.id!);
  await clientWithSecret.collections.update(
      entry.copyWith(data: {'name': 'Cheese Burger', 'rating': '1 star'}));
  await clientWithSecret.collections.delete('food', entry.id!);

  // first we add our object to the food collection
  final cheeseBurger = await clientWithSecret.collections.add('food', {
    'name': 'Cheese Burger',
    'ingredients': ['cheese', 'burger', 'bread', 'lettuce', 'tomato'],
  });

// the object returned by .add can be embedded directly inside of an activity
  await user1.addActivity(Activity(
    actor: createUserReference('userId'),
    verb: 'grill',
    object: cheeseBurger.ref,
  ));

// if we now read the feed, the activity we just added will include the entire
// full object
  await user1.getEnrichedActivities();

// we can then update the object and Stream will propagate the change to all
// activities
  await clientWithSecret.collections.update(cheeseBurger.copyWith(data: {
    'name': 'Amazing Cheese Burger',
    'ingredients': ['cheese', 'burger', 'bread', 'lettuce', 'tomato'],
  }));

  // First create a collection entry with upsert api
  await clientWithSecret.collections.upsert('food', [
    const CollectionEntry(id: 'cheese-burger', data: {'name': 'Cheese Burger'}),
  ]);

// Then create a user
  await clientWithSecret.user('john-doe').getOrCreate({
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male',
  });

// Since we know their IDs we can create references to both without reading from
// APIs
  final cheeseBurgerRef =
      clientWithSecret.collections.entry('food', 'cheese-burger').ref;
  final johnDoeRef = clientWithSecret.user('john-doe').ref;

// And then add an activity with these references
  await clientWithSecret.flatFeed('user', 'john').addActivity(Activity(
        actor: johnDoeRef,
        verb: 'eat',
        object: cheeseBurgerRef,
      ));

  client = StreamFeedClient(apiKey);
// ensure the user data is stored on Stream
  await client.setUser(
    const User(
      data: {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male'
      },
    ),
    frontendToken,
  );

  // create a new user, if the user already exist an error is returned
  // await client.user('john-doe').create({
  //   'name': 'John Doe',
  //   'occupation': 'Software Engineer',
  //   'gender': 'male'
  // });

// get or create a new user, if the user already exist the user is returned
  await client.user('john-doe').getOrCreate({
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male'
  });

//retrieving users
  await client.user('john-doe').get();

  await client.user('john-doe').update({
    'name': 'Jane Doe',
    'occupation': 'Software Engineer',
    'gender': 'female'
  });

  //removing users
  await client.user('john-doe').delete();

  // Read the personalized feed for a given user
  var params = {'user_id': 'john-doe', 'feed_slug': 'timeline'};

  // await clientWithSecret.personalization
  //     .get('personalized_feed', params: params);

//Our data science team will typically tell you which endpoint to use
  params = {
    'user_id': 'john-doe',
    'source_feed_slug': 'timeline',
    'target_feed_slug': 'user'
  };

  // await client.personalization
  //     .get('discovery_feed', params: params);
  final analytics = StreamAnalytics(apiKey, secret: secret);
  analytics.setUser(id: 'id', alias: 'alias');
  await analytics.trackEngagement(
    Engagement(
      // the label for the engagement, ie click, retweet etc.
      label: 'click',
      content: Content(
          // the ID of the content that the user clicked
          foreignId: FeedId.id('tweet:34349698')),
      // score between 0 and 100 indicating the importance of this event
      // IE. a like is typically a more significant indicator than a click
      score: 2,
      // (optional) the position in a list of activities
      position: 3,
      boost: 2,

      // (optional) the feed the user is looking at
      feedId: FeedId('user', 'thierry'),
      // (optional) the location in your app. ie email, profile page etc
      location: 'profile_page',
    ),
  );

  await analytics.trackImpression(
    Impression(
      feedId: FeedId('timeline', 'tom'),
      location: 'profile_page',
      contentList: [
        Content(
          data: const {
            'foreign_id': 'post:42',
            'actor': {'id': 'user:2353540'},
            'verb': 'share',
            'object': {'id': 'song:34349698'},
          },
          foreignId: FeedId.id('post:42'),
        )
      ],
    ),
  );

  const imageURI = 'test/assets/test_image.jpeg';

  // uploading an image from the filesystem
  final imageUrl = await client.images.upload(AttachmentFile(path: imageURI));

  await client.images.getCropped(
    imageUrl!,
    const Crop(50, 50),
  );

  await client.images.getResized(
    imageUrl,
    const Resize(50, 50),
  );

// deleting an image using the url returned by the APIs
  await client.images.delete(imageUrl);

  const fileURI = 'test/assets/example.pdf';
  // uploading a file from the filesystem
  final fileUrl = await client.files.upload(AttachmentFile(path: fileURI));

// deleting a file using the url returned by the APIs
  await client.files.delete(fileUrl!);

  final preview = await client.og('http://www.imdb.com/title/tt0117500/');
}
