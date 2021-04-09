import 'dart:convert';

import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/group.dart';
import 'package:stream_feed_dart/src/core/models/paginated.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('EnrichmentFlags', () {
    test('withOwnChildren', () {
      final withOwnChildren = EnrichmentFlags().withOwnChildren();
      expect(withOwnChildren.params, {'with_own_children': true});
    });

    test('withOwnReactions', () {
      final withOwnReactions = EnrichmentFlags().withOwnReactions();
      expect(withOwnReactions.params, {'with_own_reactions': true});
    });

    test('withUserReactions', () {
      final withUserReactions = EnrichmentFlags().withUserReactions('userId');
      expect(withUserReactions.params,
          {'with_own_reactions': true, 'user_id': 'userId'});
    });

    test('withRecentReactions', () {
      final withRecentReactions = EnrichmentFlags().withRecentReactions(10);
      expect(withRecentReactions.params, {'recent_reactions_limit': 10});
    });

    test('reactionKindFilter', () {
      final reactionKindFilter =
          EnrichmentFlags().reactionKindFilter(['kind1', 'kind2']);
      expect(
          reactionKindFilter.params, {'reaction_kinds_filter': 'kind1,kind2'});
    });

    test('withReactionCounts', () {
      final withReactionCounts = EnrichmentFlags().withReactionCounts();
      expect(withReactionCounts.params, {'with_reaction_counts': true});
    });

    test('withUserChildren', () {
      final withUserChildren = EnrichmentFlags().withUserChildren('userId');
      expect(withUserChildren.params,
          {'with_own_children': true, 'user_id': 'userId'});
    });
  });
  group('FeedId', () {
    test('claim', () {
      final feedId = FeedId('slug', 'userId');
      expect(feedId.claim, 'sluguserId');
    });

    test('feedIds', () {
      final feedIds = FeedId.toIds([FeedId('slug', 'userId')]);
      expect(feedIds, ['slug:userId']);
    });
  });
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
        data: const {'test': 'test'},
        // latestChildren: {
        //   "test": [reaction2]
        // },
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
      score: 1,
      extraData: const {'test': 'test'},
      reactionCounts: const {'test': 1},
      ownReactions: {
        'test': [reaction1]
      },
      latestReactions: {
        'test': [reaction1]
      },
    );
    final enrichedActivityJson = json.decode(fixture('enriched_activity.json'));
    final enrichedActivityFromJson =
        EnrichedActivity.fromJson(enrichedActivityJson);
    expect(enrichedActivityFromJson, enrichedActivity);
    // we will never get “extra_data” from the api
    //that's why it's not explicit in the json fixture
    // all the extra data other than the default fields in json will ultimately
    // gets collected as a field extra_data of type Map
    expect(enrichedActivityFromJson.extraData, {'test': 'test'});
  });
  test('Activity', () {
    final activity = Activity(
        target: 'test',
        foreignId: 'test',
        id: 'test',
        analytics: const {'test': 'test'},
        extraContext: const {'test': 'test'},
        origin: 'test',
        score: 1,
        extraData: const {'test': 'test'},
        actor: 'test',
        verb: 'test',
        object: 'test',
        to: <FeedId>[FeedId('slug', 'id')],
        time: DateTime.parse('2001-09-11T00:01:02.000'));
    final r = json.decode(fixture('activity.json'));
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
            score: 1,
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
    final groupJson = json.decode(fixture('group.json'));
    // expect(groupJson, matcher)
    final groupFromJson = Group.fromJson(
        groupJson, (e) => Activity.fromJson(e as Map<String, dynamic>?));
    expect(groupFromJson, group);
    expect(group.toJson((activity) => activity.toJson()), {
      'id': 'test',
      'group': 'test',
      'activities': [
        {
          'id': 'test',
          'actor': 'test',
          'verb': 'test',
          'object': 'test',
          'foreign_id': 'test',
          'target': 'test',
          'time': '2001-09-11T00:01:02.000',
          'origin': 'test',
          'to': ['slug:id'],
          'score': 1.0,
          'analytics': {'test': 'test'},
          'extra_context': {'test': 'test'},
          'test': 'test'
        }
      ],
      'actor_count': 1,
      'created_at': '2001-09-11T00:01:02.000',
      'updated_at': '2001-09-11T00:01:02.000'
    });
  });

  test('ForeignIdTimePair equatable', () {
    final foreignIdTimePair =
        ForeignIdTimePair('foreignID', DateTime(2021, 03, 03));
    final otherForeignIdTimePair =
        ForeignIdTimePair('foreignID', DateTime(2021, 04, 03));
    expect(foreignIdTimePair, otherForeignIdTimePair);
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
            score: 1,
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
    final notificationGroupJson =
        json.decode(fixture('notification_group.json'));
    final notificationGroupFromJson = NotificationGroup.fromJson(
        notificationGroupJson,
        (e) => Activity.fromJson(e as Map<String, dynamic>?));
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
    final entryJson = json.decode(fixture('collection_entry.json'));
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
      score: 1,
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

    final paginatedReactionsJson =
        json.decode(fixture('paginated_reactions.json'));
    final paginatedReactionsFromJson =
        PaginatedReactions.fromJson(paginatedReactionsJson);
    expect(paginatedReactionsFromJson, paginatedReactions);
    expect(paginatedReactions.toJson(), {
      'next': 'test',
      'results': [
        {
          'kind': 'test',
          'activity_id': 'test',
          'user_id': 'test',
          'parent': 'test',
          'created_at': '2001-09-11T00:01:02.000',
          'target_feeds': ['slug:userId'],
          'user': {'test': 'test'},
          'target_feeds_extra_data': {'test': 'test'},
          'data': {'test': 'test'}
        }
      ],
      'duration': 'duration',
      'activity': {
        'actor': 'test',
        'verb': 'test',
        'object': 'test',
        'foreign_id': 'test',
        'time': '2001-09-11T00:01:02.000',
        'test': 'test'
      }
    });
  });

  group('Filter', () {
    test('idGreaterThanOrEqual', () {
      final filter = Filter().idGreaterThanOrEqual('id');
      expect(filter.params, {'id_gte': 'id'});
    });
    test('idGreaterThan', () {
      final filter = Filter().idGreaterThan('id');
      expect(filter.params, {'id_gt': 'id'});
    });

    test('idLessThan', () {
      final filter = Filter().idLessThan('id');
      expect(filter.params, {'id_lt': 'id'});
    });

    test('idLessThanOrEqual', () {
      final filter = Filter().idLessThanOrEqual('id');
      expect(filter.params, {'id_lte': 'id'});
    });
  });
  test('User', () {
    final user = User(
        id: 'test',
        data: const {'test': 'test'},
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        followersCount: 1,
        followingCount: 1);
    final userJson = json.decode(fixture('user.json'));
    final userFromJson = User.fromJson(userJson);
    expect(userFromJson, user);
    expect(user.toJson(), {
      'id': 'test',
      'data': {'test': 'test'}
    });
  });

  test('Follow', () {
    const follow = Follow('feedId', 'targetId');
    final followJson =
        json.decode('{"feed_id": "feedId", "target_id": "targetId"}');

    expect(follow, Follow.fromJson(followJson));
    expect(follow.toJson(), {'feed_id': 'feedId', 'target_id': 'targetId'});
  });
  test('Unfollow', () {
    const follow = UnFollow('feedId', 'targetId', true);
    final followJson = json.decode(fixture('unfollow.json'));
    expect(follow, UnFollow.fromJson(followJson));
  });

  test('ActivityUpdate', () {
    final activityUpdate = ActivityUpdate(
        id: 'test',
        foreignId: 'test',
        time: DateTime.parse('2001-09-11T00:01:02.000'),
        set: const {'hey': 'hey'},
        unset: const ['test']);
    final activityUpdateJson = json.decode(fixture('activity_update.json'));
    final activityUpdateFromJson = ActivityUpdate.fromJson(activityUpdateJson);
    expect(activityUpdateFromJson, activityUpdate);
  });

  test('Location Names', () {
    final locationNames =
        Location.values.map((location) => location.name).toList();
    expect(locationNames, ['us-east', 'dublin', 'singapore', 'tokyo']);
  });

  group('Crop', () {
    test('params', () {
      const crop = Crop(10, 10);
      expect(crop.params, {'crop': 'center', 'w': 10, 'h': 10});
    });
    test('Width should be a positive number', () {
      expect(
          () => Crop(-1, 10),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Width should be a positive number')));
    });

    test('Height should be a positive number', () {
      expect(
          () => Crop(10, -1),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Height should be a positive number')));
    });
  });

  group('Resize', () {
    test('params', () {
      const resize = Resize(10, 10);
      expect(resize.params, {'resize': 'clip', 'w': 10, 'h': 10});
    });
    test('Width should be a positive number', () {
      expect(
          () => Resize(-1, 10),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Width should be a positive number')));
    });

    test('Height should be a positive number', () {
      expect(
          () => Resize(10, -1),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Height should be a positive number')));
    });
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

    final reactionJson = json.decode(fixture('reaction.json'));
    final reactionFromJson = Reaction.fromJson(reactionJson);
    expect(reactionFromJson, reaction);
    expect(reaction.toJson(), {
      'kind': 'test',
      'activity_id': 'test',
      'user_id': 'test',
      'parent': 'test',
      'created_at': '2001-09-11T00:01:02.000',
      'target_feeds': ['slug:userId'],
      'user': {'test': 'test'},
      'target_feeds_extra_data': {'test': 'test'},
      'data': {'test': 'test'}
    });
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
    final imageJson = json.decode(fixture('image.json'));
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

    final videoJson = json.decode(fixture('video.json'));
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
    final audioJson = json.decode(fixture('audio.json'));
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
    final openGraphDataJson = json.decode(fixture('open_graph_data.json'));
    final openGraphDataFromJson = OpenGraphData.fromJson(openGraphDataJson);
    expect(openGraphDataFromJson, openGraphData);
    expect(openGraphData.toJson(), {
      'title': 'test',
      'type': 'test',
      'url': 'test',
      'site': 'test',
      'site_name': 'test',
      'description': 'test',
      'determiner': 'test',
      'locale': 'test',
      'images': [
        {
          'image': 'test',
          'url': 'test',
          'secure_url': 'test',
          'width': 'test',
          'height': 'test',
          'type': 'test',
          'alt': 'test'
        }
      ],
      'videos': [
        {
          'image': 'test',
          'url': 'test',
          'secure_url': 'test',
          'width': 'test',
          'height': 'test',
          'type': 'test',
          'alt': 'test'
        }
      ],
      'audios': [
        {'audio': 'test', 'url': 'test', 'secure_url': 'test', 'type': 'test'}
      ]
    });
  });
}
