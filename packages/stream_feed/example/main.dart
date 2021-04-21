import 'dart:io';

import 'package:stream_feed/stream_feed.dart';

Future<void> main() async {
  const apiKey = 'gp6e8sxxzud6';
  const secret =
      '7j7exnksc4nxy399fdxvjqyqsqdahax3nfgtp27pumpc7sfm9um688pzpxjpjbf2';

  var client = StreamClient.connect(apiKey, secret: secret);

  final chris = client.flatFeed('user', 'chris');

  // Add an Activity; message is a custom field
  // - tip: you can add unlimited custom fields!
  await chris.addActivity(
    const Activity(
      actor: 'chris',
      verb: 'add',
      object: 'picture:10',
      foreignId: 'picture:10',
      extraData: {
        'message': 'Beautiful Bird!',
      },
    ),
  );
  // Create a following relationship
  // between Jack's "timeline" feed and Chris' "user" feed:
  final jack = client.flatFeed('timeline', 'jack');
  await jack.follow(chris);

  // Read Jack's timeline and Chris' post appears in the feed:
  var activities = await jack.getActivities(limit: 10);

  // Remove an Activity by referencing it's foreign_id
  await chris.removeActivityByForeignId('picture:10');

  /* -------------------------------------------------------- */

  // Instantiate a feed object
  final userFeed = client.flatFeed('user', '1');

  // Add an activity to the feed, where actor, object
  // and target are references to objects
  // (`Eric`, `Hawaii`, `Places to Visit`)
  var activity = const Activity(
    actor: 'user:1',
    verb: 'pin',
    object: 'place:42',
    target: 'board:1',
  );
  await userFeed.addActivity(activity);

  // Create a bit more complex activity
  activity = Activity(
    actor: 'user:1',
    verb: 'run',
    object: 'exercise:42',
    foreignId: 'run:1',
    extraData: {
      'course': const {
        'name': 'Golden gate park',
        'distance': 10,
      },
      'participants': const ['Thierry', 'Tommaso'],
      'started_at': DateTime.now().toIso8601String(),
      'location': const {
        'type': 'point',
        'coordinates': [37.769722, -122.476944]
      }
    },
  );
  await userFeed.addActivity(activity);

  // Remove an activity by its id
  await userFeed.removeActivityById('e561de8f-00f1-11e4-b400-0cc47a024be0');

  // Remove activities with foreign_id 'run:1'
  await userFeed.removeActivityByForeignId('run:1');

  activity = Activity(
    actor: '1',
    verb: 'like',
    object: '3',
    time: DateTime.now(),
    foreignId: 'like:3',
    extraData: const {'popularity': 100},
  );

  // first time the activity is added
  await userFeed.addActivity(activity);

  // update the popularity value for the activity
  activity = activity.copyWith(
    extraData: {'popularity': 10},
  );

  await client.batch.updateActivity(activity);

  /* -------------------------------------------------------- */

  // partial update by activity ID

  // prepare the set operations
  final set = {
    'product.price': 19.99,
    'shares': {
      'facebook': '...',
      'twitter': '...',
    }
  };

  // prepare the unset operations
  final unset = ['daily_likes', 'popularity'];

  const id = '54a60c1e-4ee3-494b-a1e3-50c06acb5ed4';
  final update = ActivityUpdate.withId(id, set, unset);
  await userFeed.updateActivityById(update);

  const foreignID = 'product:123';
  final timestamp = DateTime.now();
  final activityUpdate = ActivityUpdate.withForeignId(
    foreignID,
    timestamp,
    set,
    unset,
  );
  await userFeed.updateActivityByForeignId(update);

  final add = <FeedId>[];
  final remove = <FeedId>[];
  await userFeed.updateActivityToTargets(update, add, remove);

  final newTargets = <FeedId>[];
  await userFeed.replaceActivityToTargets(update, newTargets);

  /* -------------------------------------------------------- */
  final now = DateTime.now();
  final firstActivity = await userFeed.addActivity(
    Activity(
      actor: '1',
      verb: 'like',
      object: '3',
      time: now,
      foreignId: 'like:3',
    ),
  );

  final secondActivity = await userFeed.addActivity(
    Activity(
      actor: '1',
      verb: 'like',
      object: '3',
      time: now,
      foreignId: 'like:3',
      extraData: const {'extra': 'extra_value'},
    ),
  );

  // foreign ID and time are the same for both activities
  // hence only one activity is created and first and second IDs are equal
  // firstActivity.id == secondActivity.id

  /* -------------------------------------------------------- */

  // Get 5 activities with id less than the given UUID (Faster - Recommended!)
  var response = await userFeed.getActivities(
    limit: 5,
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
  );

  // Get activities from 5 to 10 (Pagination-based - Slower)
  response = await userFeed.getActivities(limit: 5, offset: 0);

  // Get activities sorted by rank (Ranked Feeds Enabled):
  response = await userFeed.getActivities(limit: 5, ranking: 'popularity');

  /* -------------------------------------------------------- */

  // timeline:timeline_feed_1 follows user:user_42
  final user = client.flatFeed('user', 'user_42');
  final timeline = client.flatFeed('timeline', 'timeline_feed_1');
  await timeline.follow(user);

  // follow feed without copying the activities:
  await timeline.follow(user, activityCopyLimit: 0);

  /* -------------------------------------------------------- */

  // Stop following feed user:user_42
  await timeline.unfollow(user);

  // Stop following feed user:user_42 but keep history of activities
  await timeline.unfollow(user, keepHistory: true);

  // list followers
  final followers = await userFeed.followers(limit: 10, offset: 0);
  for (final follow in followers) {
    print('${follow.source} -> ${follow.target}');
  }

  // Retrieve last 10 feeds followed by user_feed_1
  var followed = await userFeed.following(limit: 10, offset: 0);

  // Retrieve 10 feeds followed by user_feed_1 starting from the 11th
  followed = await userFeed.following(limit: 10, offset: 10);

  // Check if user_feed_1 follows specific feeds
  followed = await userFeed.following(limit: 2, offset: 0, feedIds: [
    FeedId.id('user:42'),
    FeedId.id('user:43'),
  ]);

  /* -------------------------------------------------------- */

  final notifications = client.notificationFeed('notifications', '1');
  // Mark all activities in the feed as seen
  var activityGroups = await notifications.getActivities(
    marker: ActivityMarker().allSeen(),
  );
  for (final group in activityGroups) {
    // ...
  }

  // Mark some activities as read via specific Activity Group Ids
  activityGroups = await notifications.getActivities(
    marker: ActivityMarker().read([
      'groupID1',
      'groupID2',
    ]),
  );

  /* -------------------------------------------------------- */

  // Add an activity to the feed,
  // where actor, object and target are references to objects -
  // adding your ranking method as a parameter (in this case, "popularity"):
  activity = const Activity(
    actor: 'user:1',
    verb: 'pin',
    object: 'place:42',
    target: 'board:1',
    extraData: {'popularity': 5},
  );
  await userFeed.addActivity(activity);

  // Get activities sorted by the ranking method
  // labelled 'activity_popularity' (Ranked Feeds
  // Enabled)
  response = await userFeed.getActivities(
    limit: 5,
    ranking: 'activity_popularity',
  );

  /* -------------------------------------------------------- */

  // Add the activity to Eric's feed and to Jessica's notification feed
  activity = Activity(
    actor: 'user:eric',
    verb: 'tweet',
    object: 'tweet:id',
    to: <FeedId>[FeedId.id('notification:jessica')],
    extraData: const {
      'message': "@Jessica check out getstream.io it's so dang awesome.",
    },
  );
  await userFeed.addActivity(activity);

  // The TO field ensures the activity is send to
  // the player, match and team feed
  activity = Activity(
    actor: 'player:suarez',
    verb: 'foul',
    object: 'player:ramos',
    to: <FeedId>[FeedId.id('team:barcelona'), FeedId.id('match:1')],
    extraData: const {
      'match': {'name': 'El Classico', 'id': 10}
    },
  );
  await userFeed.addActivity(activity);

  /* -------------------------------------------------------- */

  // Batch following many feeds
  // Let timeline:1 will follow user:1, user:2 and user:3
  final follows = <Follow>[
    const Follow('timeline:1', 'user:1'),
    const Follow('timeline:1', 'user:2'),
    const Follow('timeline:1', 'user:3'),
  ];
  await client.batch.followMany(follows);

  // copy only the last 10 activities from every feed
  await client.batch.followMany(follows, activityCopyLimit: 10);

  /* -------------------------------------------------------- */

  activities = <Activity>[
    const Activity(
      actor: 'user:1',
      verb: 'tweet',
      object: 'tweet:1',
    ),
    const Activity(
      actor: 'user:2',
      verb: 'watch',
      object: 'movie:1',
    ),
  ];
  await userFeed.addActivities(activities);

  /* -------------------------------------------------------- */

  // adds 1 activity to many feeds in one request
  activity = const Activity(
    actor: 'user:2',
    verb: 'pin',
    object: 'place:42',
    target: 'board:1',
  );

  final feeds = <FeedId>[
    FeedId('timeline', '1'),
    FeedId('timeline', '2'),
    FeedId('timeline', '3'),
    FeedId('timeline', '4'),
  ];

  await client.batch.addToMany(activity, feeds);

  /* -------------------------------------------------------- */

  // retrieve two activities by ID
  await client.batch.getActivitiesById([
    '01b3c1dd-e7ab-4649-b5b3-b4371d8f7045',
    'ed2837a6-0a3b-4679-adc1-778a1704852',
  ]);

  // retrieve an activity by foreign ID and time
  await client.batch.getActivitiesByForeignId(<ForeignIdTimePair>[
    ForeignIdTimePair('foreignId1', DateTime.now()),
    ForeignIdTimePair('foreignId2', DateTime.now()),
  ]);

  /* -------------------------------------------------------- */

  // connect to the us-east region
  client = StreamClient.connect(
    apiKey,
    secret: secret,
    options: const StreamHttpClientOptions(location: Location.usEast),
  );

  /* -------------------------------------------------------- */

  // add a like reaction to the activity with id activityId
  final like = await client.reactions.add('like', activity.id!, 'john-doe');

  // adds a comment reaction to the activity with id activityId
  final comment = await client.reactions.add(
    'comment',
    activity.id!,
    'john-doe',
    data: {'text': 'awesome post!'},
  );

  /* -------------------------------------------------------- */

  // first let's read current user's timeline feed and pick one activity
  response = await client.flatFeed('timeline', 'mike').getActivities();
  activity = response.first;

  // then let's add a like reaction to that activity
  await client.reactions.add('like', activity.id!, 'john-doe');

  /* -------------------------------------------------------- */

  // adds a comment reaction to the activity
  // and notify Thierry's notification feed
  await client.reactions.add(
    'comment',
    activity.id!,
    'john-doe',
    targetFeeds: <FeedId>[FeedId.id('notification:thierry')],
  );

  /* -------------------------------------------------------- */

  // read bob's timeline and include most recent reactions
  // to all activities and their total count
  await client.flatFeed('timeline', 'bob').getEnrichedActivities(
        flags: EnrichmentFlags().withRecentReactions().withReactionCounts(),
      );

  // read bob's timeline and include most recent reactions
  // to all activities and her own reactions
  await client.flatFeed('timeline', 'bob').getEnrichedActivities(
        flags: EnrichmentFlags()
            .withOwnReactions()
            .withRecentReactions()
            .withReactionCounts(),
      );

  /* -------------------------------------------------------- */

  // retrieve all kind of reactions for an activity
  var reactions = await client.reactions.filter(
    LookupAttribute.activityId,
    'ed2837a6-0a3b-4679-adc1-778a1704852d',
  );

  // retrieve first 10 likes for an activity
  reactions = await client.reactions.filter(
    LookupAttribute.activityId,
    'ed2837a6-0a3b-4679-adc1-778a1704852d',
    limit: 10,
    kind: 'like',
  );

  // retrieve the next 10 likes using the id_lt param
  reactions = await client.reactions.filter(
    LookupAttribute.activityId,
    'ed2837a6-0a3b-4679-adc1-778a1704852d',
    filter: Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0'),
    kind: 'like',
  );

  /* -------------------------------------------------------- */

  // adds a like to the previously created comment
  final reaction = await client.reactions.addChild(
    'like',
    comment.id!,
    'john-doe',
  );

  /* -------------------------------------------------------- */

  await client.reactions.update(
    reaction.id,
    data: {'text': 'love it!'},
  );

  /* -------------------------------------------------------- */

  await client.reactions.delete(reaction.id!);

  /* -------------------------------------------------------- */

  await client.collections.add(
    'food',
    {
      'name': 'Cheese Burger',
      'rating': '4 stars',
    },
    entryId: 'cheese-burger',
  );

  // if you don't have an id on your side, just use null as the ID
  // and Stream will generate a
  // unique ID
  await client.collections.add(
    'food',
    {
      'name': 'Cheese Burger',
      'rating': '4 stars',
    },
  );

  /* -------------------------------------------------------- */

  final collection = await client.collections.get('food', 'cheese-burger');

  /* -------------------------------------------------------- */

  await client.collections.delete('food', 'cheese-burger');

  /* -------------------------------------------------------- */

  await client.collections.update('food', 'cheese-burger', {
    'name': 'Cheese Burger',
    'rating': '1 Star',
  });

  /* -------------------------------------------------------- */

  await client.collections.upsert('visitor', <CollectionEntry>[
    const CollectionEntry(id: '123', data: {
      'name': 'john',
      'favorite_color': 'blue',
    }),
    const CollectionEntry(id: '124', data: {
      'name': 'jane',
      'favorite_color': 'purple',
      'interests': ['fashion', 'jazz'],
    }),
  ]);

  /* -------------------------------------------------------- */

  // select the entries with ID 123 and 124 from items collection
  final objects = await client.collections.select('items', ['123', '124']);

  /* -------------------------------------------------------- */

  // delete the entries with ID 123 and 124 from visitor collection
  await client.collections.deleteMany('visitor', ['123', '124']);

  /* -------------------------------------------------------- */

  // first we add our object to the food collection
  final cheeseBurger = await client.collections.add(
    'food',
    {
      'name': 'Cheese Burger',
      'ingredients': [
        'cheese',
        'burger',
        'bread',
        'lettuce',
        'tomato',
      ],
    },
    entryId: '123',
  );

  // the object returned by .add can be embedded directly inside of an activity
  await userFeed.addActivity(
    Activity(
      actor: createUserReference('john-doe'),
      verb: 'grill',
      object: createCollectionReference(
        cheeseBurger.collection,
        cheeseBurger.id,
      ),
    ),
  );

  // if we now read the feed, the activity we just added
  // will include the entire full object
  await userFeed.getEnrichedActivities();

  // we can then update the object
  // and Stream will propagate the change to all activities
  await client.collections.update(cheeseBurger.collection, cheeseBurger.id, {
    'name': 'Amazing Cheese Burger',
    'ingredients': ['cheese', 'burger', 'bread', 'lettuce', 'tomato'],
  });

  /* -------------------------------------------------------- */

  // First create a collection entry with upsert api
  await client.collections.upsert('food', <CollectionEntry>[
    const CollectionEntry(data: {'name': 'Cheese Burger'})
  ]);

  // Then create a user
  await client.users.create('john-doe', {
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male',
  });

  // Since we know their IDs
  // we can create references to both without reading from APIs
  final cheeseBurgerRef = createCollectionReference('food', 'cheese-burger');
  final johnDoeRef = createUserReference('john-doe');

  await client.flatFeed('user', 'john').addActivity(
        Activity(
          actor: johnDoeRef,
          verb: 'eat',
          object: cheeseBurgerRef,
        ),
      );

  /* -------------------------------------------------------- */

  // create a new user, if the user already exist an error is returned
  await client.users.create('john-doe', {
    'name': 'John Doe',
    'occupation': 'Software Engineer',
    'gender': 'male',
  });

  // get or create a new user, if the user already exist the user is returned
  await client.users.create(
    'john-doe',
    {
      'name': 'John Doe',
      'occupation': 'Software Engineer',
      'gender': 'male',
    },
    getOrCreate: true,
  );

  /* -------------------------------------------------------- */

  await client.users.get('123');

  /* -------------------------------------------------------- */

  await client.users.delete('123');

  /* -------------------------------------------------------- */

  await client.users.update('123', {
    'name': 'Jane Doe',
    'occupation': 'Software Engineer',
    'gender': 'female',
  });

  /* -------------------------------------------------------- */

  final image = File('...');
  var multipartFile = await MultipartFile.fromFile(
    image.path,
    filename: 'my-photo',
    contentType: MediaType('image', 'jpeg'),
  );
  await client.images.upload(multipartFile);

  final file = File('...');
  multipartFile = await MultipartFile.fromFile(
    file.path,
    filename: 'my-file',
  );
  await client.files.upload(multipartFile);

  /* -------------------------------------------------------- */

  // deleting an image using the url returned by the APIs
  await client.images.delete('imageUrl');

  // deleting a file using the url returned by the APIs
  await client.files.delete('fileUrl');

  /* -------------------------------------------------------- */

  // create a 50x50 thumbnail and crop from center
  await client.images.getCropped(
    'imageUrl',
    const Crop(50, 50),
  );

  // create a 50x50 thumbnail using clipping (keeps aspect ratio)
  await client.images.getResized(
    'imageUrl',
    const Resize(50, 50),
  );

  /* -------------------------------------------------------- */

  final urlPreview = await client.og(
    'http://www.imdb.com/title/tt0117500/',
  );
}
