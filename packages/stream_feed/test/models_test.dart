import 'dart:convert';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  prepareTest();
  
  test('EnrichedActivity', () {
    final reaction1 = Reaction(
        id: 'test',
        kind: 'test',
        activityId: 'test',
        userId: 'test',
        parent: 'test',
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        targetFeeds: [FeedId('slug', 'userId')],
        user: const {'test': 'test'},
        targetFeedsExtraData: const {'test': 'test'},
        data: const {'test': "test"},
        // latestChildren: {
        //   "test": [reaction2]
        // },
        childrenCounts: const {'test': 1});
    final enrichedActivity = EnrichedActivity(
      id: 'test',
      actor: const EnrichableField('test'),
      object: const EnrichableField('test'),
      verb: 'test',
      target: const EnrichableField("test"),
      to: const ['test'],
      foreignId: 'test',
      time: DateTime.parse('2001-09-11T00:01:02.000'),
      analytics: const {'test': 'test'},
      extraContext: const {'test': 'test'},
      origin: const EnrichableField('test'),
      score: 1.0,
      extraData: const {'test': 'test'},
      reactionCounts: const {'test': 1},
      ownReactions: {
        'test': [reaction1]
      },
      latestReactions: {
        'test': [reaction1]
      },
    );
    final enrichedActivityJson = json.decode(
        '{"id":"test", "actor": "test","object": "test", "verb": "test","target": "test", "to":["test"], "foreign_id": "test", "time": "2001-09-11T00:01:02.000","analytics": {"test": "test"},"extra_context": {"test": "test"},"origin":"test","score":1.0,"reaction_counts": {"test": 1},"own_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]},"latest_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]}, "extra_data": {"test": "test"}}');
    final enrichedActivityFromJson =
        EnrichedActivity.fromJson(enrichedActivityJson);
    expect(enrichedActivityFromJson, enrichedActivity);
  });
  test('Activity', () {
    final activity = Activity(
        target: 'test',
        foreignId: 'test',
        id: 'test',
        analytics: const {'test': 'test'},
        extraContext: const {'test': 'test'},
        origin: 'test',
        score: 1.0,
        extraData: const {'test': 'test'},
        actor: 'test',
        verb: 'test',
        object: 'test',
        to: <FeedId>[FeedId('slug', 'id')],
        time: DateTime.parse('2001-09-11T00:01:02.000'));
    final r = json.decode(
        '{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}');

    final activityJson = Activity.fromJson(r);
    expect(activityJson, activity);
  });

  test('Group', () {
    final group = Group(
      id: 'test',
      group: 'test',
      activities: [
        Activity(
            target: 'test',
            foreignId: 'test',
            id: 'test',
            analytics: const {'test': 'test'},
            extraContext: const {'test': 'test'},
            origin: 'test',
            score: 1.0,
            extraData: const {'test': 'test'},
            actor: 'test',
            verb: 'test',
            object: 'test',
            to: <FeedId>[FeedId('slug', 'id')],
            time: DateTime.parse('2001-09-11T00:01:02.000'))
      ],
      actorCount: 1,
      createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
      updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
    );
    final groupJson = json.decode(
        '{"id": "test", "group": "test", "activities": [{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}], "actor_count": 1, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000"}');

    // expect(groupJson, matcher)
    final groupFromJson =
        Group.fromJson(groupJson, (e) => Activity.fromJson(e));
    expect(groupFromJson, group);
  });

  test('NotificationGroup', () {
    final notificationGroup = NotificationGroup(
      id: 'test',
      group: 'test',
      activities: [
        Activity(
            target: 'test',
            foreignId: 'test',
            id: 'test',
            analytics: const {'test': 'test'},
            extraContext: const {'test': 'test'},
            origin: 'test',
            score: 1.0,
            extraData: const {'test': 'test'},
            actor: 'test',
            verb: 'test',
            object: 'test',
            to: <FeedId>[FeedId('slug', 'id')],
            time: DateTime.parse('2001-09-11T00:01:02.000'))
      ],
      actorCount: 1,
      createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
      updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
      isRead: true,
      isSeen: true,
    );
    final notificationGroupJson = json.decode(
        '{"id": "test", "group": "test", "activities": [{"id": "test", "actor": "test", "verb": "test", "object": "test", "foreign_id": "test", "target": "test", "time": "2001-09-11T00:01:02.000", "origin": "test", "to": ["slug:id"], "score": 1.0, "analytics": {"test": "test"}, "extra_context": {"test": "test"}, "test": "test"}], "actor_count": 1, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000","is_read":true,"is_seen":true}');

    final notificationGroupFromJson = NotificationGroup.fromJson(
        notificationGroupJson, (e) => Activity.fromJson(e));
    expect(notificationGroupFromJson, notificationGroup);
  });
  test('CollectionEntry', () {
    final entry = CollectionEntry(
        id: 'test',
        collection: 'test',
        foreignId: 'test',
        data: const {'test': 'test'},
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'));
    final entryJson = json.decode(
        '{"id": "test", "collection": "test", "foreign_id": "test", "data": {"test": "test"}, "created_at": "2001-09-11T00:01:02.000", "updated_at": "2001-09-11T00:01:02.000"}');

    final entryFromJson = CollectionEntry.fromJson(entryJson);
    expect(entry, entryFromJson);
  });

  test('PaginatedReactions', () {
    final reaction1 = Reaction(
        id: 'test',
        kind: 'test',
        activityId: 'test',
        userId: 'test',
        parent: 'test',
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        targetFeeds: [FeedId('slug', 'userId')],
        user: const {'test': 'test'},
        targetFeedsExtraData: const {'test': 'test'},
        data: const {'test': 'test'},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: const {'test': 1});
    final enrichedActivity = EnrichedActivity(
      id: 'test',
      actor: const EnrichableField('test'),
      object: const EnrichableField('test'),
      verb: 'test',
      target: const EnrichableField('test'),
      to: const ['test'],
      foreignId: 'test',
      time: DateTime.parse('2001-09-11T00:01:02.000'),
      analytics: const {'test': 'test'},
      extraContext: const {'test': 'test'},
      origin: const EnrichableField('test'),
      score: 1.0,
      extraData: const {'test': 'test'},
      reactionCounts: const {'test': 1},
      ownReactions: {
        'test': [reaction1]
      },
      latestReactions: {
        'test': [reaction1]
      },
    );
    final reaction = Reaction(
        id: 'test',
        kind: 'test',
        activityId: 'test',
        userId: 'test',
        parent: 'test',
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        targetFeeds: [FeedId('slug', 'userId')],
        user: const {'test': 'test'},
        targetFeedsExtraData: const {'test': 'test'},
        data: const {'test': 'test'},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: const {'test': 1});
    final paginatedReactions =
        PaginatedReactions('test', [reaction], enrichedActivity, 'duration');

    final paginatedReactionsJson = json.decode(
        '{"next": "test", "results": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}], "duration": "duration", "activity": {"id":"test", "actor": "test","object": "test", "verb": "test","target": "test", "to":["test"], "foreign_id": "test", "time": "2001-09-11T00:01:02.000","analytics": {"test": "test"},"extra_context": {"test": "test"},"origin":"test","score":1.0,"reaction_counts": {"test": 1},"own_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]},"latest_reactions": { "test": [{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}]}, "extra_data": {"test": "test"}}}');
    final paginatedReactionsFromJson =
        PaginatedReactions.fromJson(paginatedReactionsJson);
    expect(paginatedReactionsFromJson, paginatedReactions);
  });
  test('User', () {
    final user = User(
        id: 'test',
        data: const {'test': 'test'},
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        followersCount: 1,
        followingCount: 1);
    final userJson = json.decode(
        '{"id": "test", "data": {"test": "test"}, "created_at": "2001-09-11T00:01:02.000","updated_at": "2001-09-11T00:01:02.000","followers_count": 1, "following_count": 1}');

    final userFromJson = User.fromJson(userJson);
    expect(userFromJson, user);
  });

  test('Follow', () {
    const follow = Follow('feedId', 'targetId');
    final followJson =
        json.decode('{"feed_id": "feedId", "target_id": "targetId"}');

    expect(follow, Follow.fromJson(followJson));
  });
  test('Unfollow', () {
    const follow = UnFollow('feedId', 'targetId', true);
    final followJson = json.decode(
        '{"feed_id": "feedId", "target_id": "targetId","keep_history":true}');

    expect(follow, UnFollow.fromJson(followJson));
  });

  test('ActivityUpdate', () {
    final activityUpdate = ActivityUpdate(
        id: 'test',
        foreignId: 'test',
        time: DateTime.parse('2001-09-11T00:01:02.000'),
        set: const {'hey': 'hey'},
        unset: const ['test']);
    final activityUpdateJson = json.decode(
        '{"id": "test", "foreign_id": "test", "time": "2001-09-11T00:01:02.000", "set": {"hey": "hey"}, "unset": ["test"]}');

    final activityUpdateFromJson = ActivityUpdate.fromJson(activityUpdateJson);
    expect(activityUpdateFromJson, activityUpdate);
  });

  test('Reaction', () {
    final reaction2 = Reaction(
        id: 'test',
        kind: 'test',
        activityId: 'test',
        userId: 'test',
        parent: 'test',
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        targetFeeds: [FeedId('slug', 'userId')],
        user: const {'test': 'test'},
        targetFeedsExtraData: const {'test': 'test'},
        data: const {'test': 'test'},
        childrenCounts: const {'test': 1});
    final reaction = Reaction(
        id: 'test',
        kind: 'test',
        activityId: 'test',
        userId: 'test',
        parent: 'test',
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        targetFeeds: [FeedId('slug', 'userId')],
        user: const {'test': 'test'},
        targetFeedsExtraData: const {'test': 'test'},
        data: const {'test': 'test'},
        // latestChildren: {
        //   "test": [reaction2]
        // },//TODO: test this
        childrenCounts: const {'test': 1});

    final reactionJson = json.decode(
        '{"id": "test","kind": "test", "activity_id": "test", "user_id": "test", "parent": "test",  "updated_at": "2001-09-11T00:01:02.000","created_at": "2001-09-11T00:01:02.000", "target_feeds": ["slug:userId"], "user": {"test": "test"}, "target_feeds_extra_data": {"test": "test"}, "data": {"test": "test"},"children_counts": {"test": 1}}');

    final reactionFromJson = Reaction.fromJson(reactionJson);
    expect(reactionFromJson, reaction);
  });

  test('Image', () {
    const image = Image(
        image: 'test',
        url: 'test',
        secureUrl: 'test',
        width: 'test',
        height: 'test',
        type: 'test',
        alt: 'test');
    final imageJson = json.decode(
        '{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}');

    final imageFromJson = Image.fromJson(imageJson);
    expect(imageFromJson, image);
  });

  test('Video', () {
    const video = Video(
      image: 'test',
      url: 'test',
      secureUrl: 'test',
      width: 'test',
      height: 'test',
      type: 'test',
      alt: 'test',
    );

    final videoJson = json.decode(
        '{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}');

    final videoFromJson = Video.fromJson(videoJson);
    expect(videoFromJson, video);
  });
  test('Audio', () {
    const audio = Audio(
      audio: 'test',
      url: 'test',
      secureUrl: 'test',
      type: 'test',
    );
    final audioJson = json.decode(
        '{"audio": "test", "url": "test", "secure_url": "test", "type": "test"}');
    final audioFromJson = Audio.fromJson(audioJson);
    expect(audioFromJson, audio);
  });

  test('OpenGraphData', () {
    const openGraphData = OpenGraphData(
      title: 'test',
      type: 'test',
      url: 'test',
      site: 'test',
      siteName: 'test',
      description: 'test',
      determiner: 'test',
      locale: 'test',
      images: [
        Image(
            image: 'test',
            url: 'test',
            secureUrl: 'test',
            width: 'test',
            height: 'test',
            type: 'test',
            alt: 'test')
      ],
      videos: [
        Video(
          image: 'test',
          url: 'test',
          secureUrl: 'test',
          width: 'test',
          height: 'test',
          type: 'test',
          alt: 'test',
        )
      ],
      audios: [
        Audio(
          audio: 'test',
          url: 'test',
          secureUrl: 'test',
          type: 'test',
        )
      ],
    );
    final openGraphDataJson = json.decode(
        '{"title": "test", "type": "test", "url": "test", "site": "test", "site_name": "test", "description": "test", "determiner": "test", "locale": "test", "images": [{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}], "videos": [{"image": "test", "url": "test", "secure_url": "test", "width": "test", "height": "test", "type": "test", "alt": "test"}], "audios": [{"audio": "test", "url": "test", "secure_url": "test", "type": "test"}]}');
    final openGraphDataFromJson = OpenGraphData.fromJson(openGraphDataJson);
    expect(openGraphDataFromJson, openGraphData);
  });
}
