import 'dart:io';

import 'package:stream_feed/stream_feed.dart';

Future<void> main() async {
  final env = Platform.environment;
  final secret = env['secret'];
  final apiKey = env['apiKey'];
  final appId = env['appId'];
  var server = StreamFeedServer(
    apiKey!,
    secret: secret!,
  );

  final chris = server.flatFeed('user', userId: 'chris');

  /// Add an Activity; message is a custom field - tip: you can add unlimited
  /// custom fields!
  final addedPicture = await chris.addActivity(
    const Activity(
      actor: 'chris',
      verb: 'add',
      object: 'picture:10',
      foreignId: 'picture:10',
      extraData: {'message': 'Beautiful bird!'},
    ),
  );

  /// Create a following relationship between Jack's "timeline" feed and Chris'
  /// "user" feed:
  final jack = server.flatFeed('timeline', userId: 'jack');
  await jack.follow(chris.feedId);

  /// Read Jack's timeline and Chris' post appears in the feed:
  await jack.getActivities(limit: 10);

  /// Remove an Activity by referencing it's Foreign Id:
  await chris.removeActivityByForeignId('picture:10');

  /// Instantiate a feed using feed group 'user' and user id '1'.
  final user1 = server.flatFeed('user', userId: '1');

  /// Create an activity object.
  var activity = const Activity(
    actor: 'User:1',
    verb: 'pin',
    object: 'Place:42',
  );

  /// Add an activity to the feed.
  await user1.addActivity(activity);

  /// Create a more complex activity.
  activity = Activity(
    actor: 'User:1',
    verb: 'run',
    object: 'Exercise:42',
    extraData: {
      'course': const {'name': 'Golden Gate park', 'distance': 10},
      'participants': const ['Thierry', 'Tommaso'],
      'started_at': DateTime.now().toIso8601String(),
      'foreign_id': 'run:1',
      'location': const {
        'type': 'point',
        'coordinates': [37.769722, -122.476944]
      }
    },
  );

  final exercise = await user1.addActivity(activity);

  /// Get five activities with id less than the given UUID
  /// (Faster - Recommended!)
  await user1.getActivities(
    limit: 5,
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
  );

  /// Get activities from 5 to 10 (Pagination-based - Slower)/
  await user1.getActivities(offset: 0, limit: 5);

  /// TODO (Sacha): use or remove
  ///
  /// Get activities sorted by rank (Ranked Feeds Enabled):
  /// response = await userFeed.getActivities(limit: 5, ranking: "popularity");//must be enabled

  /// Server-side
  server = StreamFeedServer(
    apiKey,
    secret: secret,
    appId: appId,
    options: const StreamHttpClientOptions(location: Location.usEast),
  );

  final userToken = server.frontendToken('user.id');

  /// Client-side
  var client = StreamFeedClient(apiKey, appId: appId);

  /// Sset the current user.
  await client.setCurrentUser(const User(id: 'user.id'), userToken);

  /// Remove an activity by its id.
  await user1.removeActivityById(addedPicture.id!);

  /// Remove activities bu foreign_id 'run:1'.
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
    },
  );

  /// First time the activity is added.
  final like = await user1.addActivity(activity);

  /// Send the update to the APIs.
  user1.updateActivityById(
    id: like.id!,
    // update the popularity value for the activity
    set: {'popularity': 10},
  );

  /// Partial update by activity ID.
  await user1.updateActivityById(
    id: exercise.id!,
    set: {
      'course.distance': 12,
      'shares': {
        'facebook': '...',
        'twitter': '...',
      },
    },
    unset: ['location', 'participants'],
  );

  /// TODO (Sacha): use or remove
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

  /// Batching Partial Updates
  final firstActivity = Activity(
    actor: '1',
    verb: 'add',
    object: '1',
    foreignId: 'activity_1',
    time: DateTime.now(),
  );

  /// Add activity to activity feed:
  await user1.addActivity(firstActivity);

  final secondActivity = Activity(
      actor: '1', verb: 'add', object: '1', foreignId: 'activity_2', time: now);

  await user1.addActivity(secondActivity);

  /// Following Feeds
  /// timeline:timeline_feed_1 follows user:user_42:
  final timelineFeed1 = server.flatFeed('timeline', userId: 'timeline_feed_1');
  final user42feed = server.flatFeed('user', userId: 'user_42');
  await timelineFeed1.follow(user42feed.feedId);

  /// Follow feed without copying the activities:
  await timelineFeed1.follow(user42feed.feedId, activityCopyLimit: 0);

  /// Unfollowing feeds
  /// Stop following feed user_42 - purging history:
  await timelineFeed1.unfollow(user42feed.feedId);

  /// Stop following feed user_42 but keep history of activities:
  await timelineFeed1.unfollow(user42feed.feedId, keepHistory: true);

  /// Reading Feed Followers
  /// List followers
  await user1.followers(limit: 10, offset: 10);

  /// Retrieve last 10 feeds followed by user_feed_1
  await user1.following(offset: 0, limit: 10);

  /// Retrieve 10 feeds followed by user_feed_1 starting from the 11th
  await user1.following(offset: 10, limit: 10);

  /// Check if user1 follows specific feeds
  await user1.following(
      offset: 0,
      limit: 2,
      filter: [FeedId.id('user:42'), FeedId.id('user:43')]);

  /// Get follower and following stats of the feed
  await server.flatFeed('user', userId: 'me').followStats();

  /// Get follower and following stats of the feed but also filter with given
  /// slugs:
  /// count by how many timelines follow me
  /// count by how many markets are followed
  await server
      .flatFeed('user', userId: 'me')
      .followStats(followerSlugs: ['timeline'], followingSlugs: ['market']);

  /// Realtime
  final frontendToken = server.frontendToken('john-doe');

  /// Use Case: Mentions
  /// Add the activity to Eric's feed and to Jessica's notification feed
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

  /// Add a like reaction to the activity with id activityId.
  await server.reactions.add('like', tweet.id!, userId: 'userId');

  ///Aadds a comment reaction to the activity with id activityId.
  await server.reactions.add('comment', tweet.id!,
      data: {'text': 'awesome post!'}, userId: 'userId');

  /// For server side auth, userId is required
  final comment = await server.reactions.add('comment', tweet.id!,
      data: {'text': 'awesome post!'}, userId: 'userId');

  /// First let's read current user's timeline feed and pick one activity.
  final activities = await server.flatFeed('user', userId: '1').getActivities();

  /// Then let's add a like reaction to that activity.
  await server.reactions.add('like', activities.first.id!, userId: 'userId');

  /// Retrieve all kind of reactions for an activity.
  await server.reactions.filter(
      LookupAttribute.activityId, '5de5e4ba-add2-11eb-8529-0242ac130003');

  /// Retrieve first 10 likes for an activity.
  await server.reactions.filter(
      LookupAttribute.activityId, '5de5e4ba-add2-11eb-8529-0242ac130003',
      kind: 'like', limit: 10);

  /// Retrieve the next 10 likes using the id_lt param.
  await server.reactions.filter(
    LookupAttribute.activityId,
    '5de5e4ba-add2-11eb-8529-0242ac130003',
    kind: 'like',
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
  );

  /// TODO (Sacha): user or remove
  // await clientWithSecret.reactions
  //     .update(comment.id!, data: {'text': 'love it!'});

  /// Read Bob's timeline and include most recent reactions to all activities
  /// and their total count.
  await server.flatFeed('timeline', userId: 'bob').getEnrichedActivities(
        flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
      );

  /// Adds a comment reaction to the activity and notifies Thierry's
  /// notification feed.
  await server.reactions.add('comment', '5de5e4ba-add2-11eb-8529-0242ac130003',
      data: {'text': '@thierry great post!'},
      userId: 'userId',
      targetFeeds: [FeedId.id('notification:thierry')]);

  /// Adds a like to the previously created comment.
  await server.reactions.addChild('like', comment.id!, userId: 'userId');
  await server.reactions.delete(comment.id!);

  /// TODO (Sacha): use or remove
  /// Adding Collections
  // await client.collections.add(
  //   'food',
  //   {'name': 'Cheese Burger', 'rating': '4 stars'},
  //   entryId: 'cheese-burger',
  // ); // will throw an error if entry-id already exists

  /// If you don't have an id on your side, just use null as the ID and Stream
  /// will generate a unique ID.
  final entry = await server.collections
      .add('food', {'name': 'Cheese Burger', 'rating': '4 stars'});
  await server.collections.get('food', entry.id!);
  await server.collections.update(
      entry.copyWith(data: {'name': 'Cheese Burger', 'rating': '1 star'}));
  await server.collections.delete('food', entry.id!);

  /// First we add our object to the food collection.
  final cheeseBurger = await server.collections.add('food', {
    'name': 'Cheese Burger',
    'ingredients': ['cheese', 'burger', 'bread', 'lettuce', 'tomato'],
  });

  /// The object returned by .add can be embedded directly inside of an
  /// activity.
  await user1.addActivity(Activity(
    actor: createUserReference('userId'),
    verb: 'grill',
    object: cheeseBurger.ref,
  ));

  /// If we now read the feed, the activity we just added will include the
  /// entire full object.
  await user1.getEnrichedActivities();

  /// We can then update the object and Stream will propagate the change to all
  /// activities.
  await server.collections.update(cheeseBurger.copyWith(data: {
    'name': 'Amazing Cheese Burger',
    'ingredients': ['cheese', 'burger', 'bread', 'lettuce', 'tomato'],
  }));

  /// First create a collection entry with upsert api.
  await server.collections.upsert('food', [
    const CollectionEntry(id: 'cheese-burger', data: {'name': 'Cheese Burger'}),
  ]);

  /// Then create a user.
  await server.user('john-doe').getOrCreate({
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male',
  });

  /// Since we know their IDs we can create references to both without reading
  /// from APIs
  final cheeseBurgerRef = server.collections.entry('food', 'cheese-burger').ref;
  final johnDoeRef = server.user('john-doe').ref;

  /// And then add an activity with these references.
  await server.flatFeed('user', userId: 'john').addActivity(Activity(
        actor: johnDoeRef,
        verb: 'eat',
        object: cheeseBurgerRef,
      ));

  client = StreamFeedClient(apiKey);

  /// Ensure the user data is stored on Stream.
  await client.setCurrentUser(
    const User(id: 'john-doe'),
    frontendToken,
    extraData: {
      'name': 'John Doe',
      'occupation': 'Software Engineer',
      'gender': 'male'
    },
  );

  /// TODO (Sacha): user or remove
  // create a new user, if the user already exist an error is returned
  // await client.user('john-doe').create({
  //   'name': 'John Doe',
  //   'occupation': 'Software Engineer',
  //   'gender': 'male'
  // });

  /// Get or create a new user, if the user already exist the user is returned.
  await client.user('john-doe').getOrCreate({
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male'
  });

  /// Retrieving users.
  await client.user('john-doe').get();

  await client.user('john-doe').update({
    'name': 'Jane Doe',
    'occupation': 'Software Engineer',
    'gender': 'female'
  });

  /// Removing users.
  await client.user('john-doe').delete();

  /// TODO (Sacha): use or remove.
  /// Read the personalized feed for a given user.
  var params = {'user_id': 'john-doe', 'feed_slug': 'timeline'};
  // await clientWithSecret.personalization
  //     .get('personalized_feed', params: params);

  /// Our data science team will typically tell you which endpoint to use
  params = {
    'user_id': 'john-doe',
    'source_feed_slug': 'timeline',
    'target_feed_slug': 'user'
  };

  final analytics = StreamAnalytics(apiKey, secret: secret)
    ..setUser(id: 'id', alias: 'alias');

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

  /// Uploading an image from the filesystem.
  final imageUrl = await client.images.upload(AttachmentFile(path: imageURI));

  await client.images.getCropped(
    imageUrl!,
    const Crop(50, 50),
  );

  await client.images.getResized(
    imageUrl,
    const Resize(50, 50),
  );

  /// Deleting an image using the url returned by the APIs.
  await client.images.delete(imageUrl);

  const fileURI = 'test/assets/example.pdf';

  /// Uploading a file from the filesystem.
  final fileUrl = await client.files.upload(AttachmentFile(path: fileURI));

  /// Deleting a file using the url returned by the APIs.
  await client.files.delete(fileUrl!);

  /// Preview
  await client.og('http://www.imdb.com/title/tt0117500/');
}
