import 'dart:convert';
import 'dart:typed_data';

import 'package:stream_feed/src/core/models/activity.dart';
import 'package:stream_feed/src/core/models/event.dart';
import 'package:stream_feed/src/core/models/follow_relation.dart';
import 'package:stream_feed/src/core/models/follow_stats.dart';
import 'package:stream_feed/src/core/models/followers.dart';
import 'package:stream_feed/src/core/models/following.dart';
import 'package:stream_feed/src/core/models/group.dart';
import 'package:stream_feed/src/core/models/paginated_reactions.dart';
import 'package:stream_feed/src/core/models/personalized_feed.dart';
import 'package:stream_feed/src/core/models/thumbnail.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/utc_converter.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('EnrichmentFlags', () {
    test('combination', () {
      final flags = EnrichmentFlags()
          .withReactionCounts()
          .withOwnReactions()
          .withRecentReactions();
      expect(flags.params, {
        'with_reaction_counts': true,
        'with_own_reactions': true,
        'with_recent_reactions': true
      });
    });

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

  test('Followers', () {
    final followers = Followers(feed: FeedId.id('user:jessica'));
    expect(Followers.fromJson(const {'feed': 'user:jessica'}), followers);
  });

  test('Followings', () {
    final followers = Following(feed: FeedId.id('user:jessica'));
    expect(Following.fromJson(const {'feed': 'user:jessica'}), followers);
  });

  group('FollowStats', () {
    final followStats = FollowStats(
      following: Following(feed: FeedId.id('user:jessica'), count: 0),
      followers: Followers(feed: FeedId.id('user:jessica'), count: 1),
    );

    test('fromJson', () {
      final followStatsJson = json.decode(fixture('follow_stats.json'));
      final followStatsFromJson = FollowStats.fromJson(followStatsJson);
      expect(followStatsFromJson, followStats);
    });

    test('toJson simple', () {
      final toJson = followStats.toJson();
      expect(
          toJson, {'followers': 'user:jessica', 'following': 'user:jessica'});
    });

    test('toJson slugs', () {
      final followStatsSlugs = FollowStats(
        following: Following(
          feed: FeedId.id('user:jessica'),
          slugs: const ['user', 'news'],
        ),
        followers: Followers(
          feed: FeedId.id('user:jessica'),
          slugs: const ['timeline'],
        ),
      );

      final toJson = followStatsSlugs.toJson();
      expect(toJson, {
        'followers': 'user:jessica',
        'following': 'user:jessica',
        'followers_slugs': 'timeline',
        'following_slugs': 'user,news',
      });
    });
  });

  group('RealtimeMessage', () {
    test('fromJson', () {
      final fromJson = RealtimeMessage<String, String, String, String>.fromJson(
          jsonFixture('realtime_message.json'));

      expect(
        fromJson,
        RealtimeMessage<String, String, String, String>(
          feed: FeedId.fromId('reward:1'),
          newActivities: [
            GenericEnrichedActivity<String, String, String, String>(
              actor: 'reward:1',
              id: 'f3de8328-be2d-11eb-bb18-128a130028af',
              extraData: const {
                'message':
                    "@Jessica check out getstream.io it's so dang awesome.",
              },
              target: 'test',
              origin: 'test',
              object: 'tweet:id',
              time: DateTime.parse('2021-05-26T14:23:33.918391'),
              to: const ['notification:jessica'],
              verb: 'tweet',
            ),
          ],
        ),
      );
    });

    test('issue-89', () {
      final fixture = RealtimeMessage<User, String, String?, String?>.fromJson(
        jsonFixture('realtime_message_issue89.json'),
      );
      expect(
        fixture,
        RealtimeMessage<User, String, String?, String?>(
          feed: FeedId.fromId('task:32db0f46-3593-4e14-aa57-f05af4887260'),
          newActivities: [
            GenericEnrichedActivity(
              foreignId: null,
              id: 'cff95542-c979-11eb-8080-80005abdd229',
              object: 'task_situation_updated to true',
              time: DateTime.parse('2021-06-09T23:24:18.238189'),
              verb: 'updated',
              actor: User(
                createdAt: DateTime.parse('2021-04-13T22:53:19.670051Z'),
                updatedAt: DateTime.parse('2021-04-13T22:53:19.670051Z'),
                id: 'eTHVBnEm0FQB2HeaRKVlEfVf58B3personal',
                data: const {
                  'gender': 'Male',
                  'name': 'Rickey Lee',
                  'photo':
                      'https://firebasestorage.googleapis.com/v0/b/fire-snab.appspot.com/o/profile-image-placeholder.png?alt=media&token=b17598bb-a510-4167-8354-ab75642ba89e'
                },
              ),
              extraData: const {
                'createdTask': {
                  'id': '32db0f46-3593-4e14-aa57-f05af4887260',
                  'title': 'KeyPack',
                  'isFinished': true
                },
                'group': 'updated_2021-06-09',
              },
            )
          ],
        ),
      );
    });
  });

  test('EnrichedActivity issue 61', () {
    final enrichedActivity =
        GenericEnrichedActivity<User, String, String, String?>.fromJson(
      jsonFixture('enriched_activity_issue61.json'),
    );
    expect(enrichedActivity.latestReactions, isNotNull);
    expect(enrichedActivity.ownReactions, isNotNull);
    expect(enrichedActivity.reactionCounts, isNotNull);
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
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      // latestChildren: {
      //   "test": [reaction2]
      // },
      childrenCounts: const {'test': 1},
    );

    final enrichedActivity = GenericEnrichedActivity(
      id: 'test',
      actor: 'test',
      object: 'test',
      verb: 'test',
      target: 'test',
      to: const ['test'],
      foreignId: 'test',
      time: DateTime.parse('2001-09-11T00:01:02.000'),
      analytics: const {'test': 'test'},
      extraContext: const {'test': 'test'},
      origin: 'test',
      score: 1,
      extraData: const {'test': null},
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
        GenericEnrichedActivity<String, String, String, String>.fromJson(
            enrichedActivityJson);
    expect(enrichedActivityFromJson, enrichedActivity);
    // we will never get “extra_data” from the api
    //that's why it's not explicit in the json fixture
    // all the extra data other than the default fields in json will ultimately
    // gets collected as a field extra_data of type Map
    expect(enrichedActivityFromJson.extraData, {'test': null});
  });

  test('EnrichedActivity with CollectionEntry object', () {
    final reaction1 = Reaction(
      id: 'test',
      kind: 'test',
      activityId: 'test',
      userId: 'test',
      parent: 'test',
      createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
      updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
      targetFeeds: [FeedId('slug', 'userId')],
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      // latestChildren: {
      //   "test": [reaction2]
      // },
      childrenCounts: const {'test': 1},
    );

    final enrichedActivity = GenericEnrichedActivity(
      id: 'test',
      actor: 'test',
      object: CollectionEntry(
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        collection: 'test',
        id: 'test',
        data: const {'test': 'test'},
        updatedAt: DateTime.parse('2001-09-11T00:01:03.000'),
        foreignId: 'test',
      ),
      verb: 'test',
      target: 'test',
      to: const ['test'],
      foreignId: 'test',
      time: DateTime.parse('2001-09-11T00:01:02.000'),
      analytics: const {'test': 'test'},
      extraContext: const {'test': 'test'},
      origin: 'test',
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

    final enrichedActivityJson =
        json.decode(fixture('enriched_activity_collection_entry.json'));
    final enrichedActivityFromJson = GenericEnrichedActivity<String,
        CollectionEntry, String, String>.fromJson(
      enrichedActivityJson,
    );
    expect(enrichedActivityFromJson, enrichedActivity);
    // we will never get “extra_data” from the api
    //that's why it's not explicit in the json fixture
    // all the extra data other than the default fields in json will ultimately
    // gets collected as a field extra_data of type Map
    expect(enrichedActivityFromJson.extraData, {'test': 'test'});
  });

  group('Activity', () {
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
      time: DateTime.parse('2001-09-11T00:01:02.000'),
    );
    final r = json.decode(fixture('activity.json'));

    test('fromJson', () {
      final activityJson = Activity.fromJson(r);
      expect(activityJson, activity);
    });

    test('copyWith', () {
      final activityCopiedWith =
          activity.copyWith(extraData: {'popularity': 10});
      expect(activityCopiedWith.extraData, {'popularity': 10});
    });
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
          time: DateTime.parse('2001-09-11T00:01:02.000'),
        ),
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

  group('NotificationGroup', () {
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
            time: DateTime.parse('2001-09-11T00:01:02.000'),
          ),
        ],
        actorCount: 1,
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
        isRead: true,
        isSeen: true,
        unread: 0,
        unseen: 1);

    test('fromJson', () {
      final notificationGroupJson =
          json.decode(fixture('notification_group.json'));
      final notificationGroupFromJson = NotificationGroup.fromJson(
          notificationGroupJson,
          (e) => Activity.fromJson(e as Map<String, dynamic>?));

      expect(notificationGroupFromJson, notificationGroup);
    });

    test('toJson', () {
      expect(notificationGroup.toJson((activity) => activity.toJson()), {
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
        'updated_at': '2001-09-11T00:01:02.000',
        'is_read': true,
        'is_seen': true,
        'unread': 0,
        'unseen': 1,
      });
    });
  });

  group('CollectionEntry', () {
    final entry = CollectionEntry(
        id: 'test',
        collection: 'test',
        foreignId: 'test',
        data: const {'test': 'test'},
        createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
        updatedAt: DateTime.parse('2001-09-11T00:01:02.000'));

    test('ref', () {
      expect(entry.ref, 'SO:test:test');
    });

    test('fromJson', () {
      final entryJson = json.decode(fixture('collection_entry.json'));
      final entryFromJson = CollectionEntry.fromJson(entryJson);
      expect(entry, entryFromJson);
    });

    test('copyWith', () {
      final entryCopiedWith = entry.copyWith(data: {
        'name': 'Cheese Burger',
        'rating': '4 stars',
      });

      expect(entryCopiedWith.data, {
        'name': 'Cheese Burger',
        'rating': '4 stars',
      });
    });

    test('toJson', () {
      expect(entry.toJson(), {
        'id': 'test',
        'collection': 'test',
        'foreign_id': 'test',
        'data': {'test': 'test'},
        'created_at': '2001-09-11T00:01:02.000',
        'updated_at': '2001-09-11T00:01:02.000'
      });
    });
  });

  test('Content', () {
    final content = Content(foreignId: FeedId.fromId('tweet:34349698'));
    expect(content.toJson(), {'foreign_id': 'tweet:34349698'});
  });

  group('Engagement', () {
    final engagement = Engagement(
      content: Content(foreignId: FeedId.id('tweet:34349698')),
      label: 'click',
      userData: const UserData('test', 'test'),
      feedId: FeedId('user', 'thierry'),
    );

    final json = {
      'user_data': {'id': 'test', 'alias': 'test'},
      'feed_id': 'user:thierry',
      'content': {'foreign_id': 'tweet:34349698'},
      'label': 'click',
      'score': null
    };

    test('fromJson', () {
      final engagementFromJson = Engagement.fromJson(json);
      expect(engagementFromJson, engagement);
    });

    test('toJson', () {
      expect(engagement.toJson(), json);
    });
  });

  group('Impression', () {
    final impression = Impression(
      contentList: [
        Content(
          foreignId: FeedId.fromId('tweet:34349698'),
        )
      ],
      userData: const UserData('test', 'test'),
      feedId: FeedId('flat', 'tommaso'),
      location: 'profile_page',
    );

    final json = {
      'user_data': {'id': 'test', 'alias': 'test'},
      'feed_id': 'flat:tommaso',
      'location': 'profile_page',
      'content_list': [
        {'foreign_id': 'tweet:34349698'}
      ]
    };
    test('fromJson', () {
      final impressionFromJson = Impression.fromJson(json);
      expect(impressionFromJson, impression);
    });

    test('toJson', () {
      expect(impression.toJson(), json);
    });
  });

  test('PersonalizedFeed', () {
    final json = {
      'limit': 25,
      'offset': 0,
      'version': 'user_1_1619210635',
      'next': '',
      'results': [],
      'duration': '419.81ms'
    };
    final personalizedFeed =
        PersonalizedFeed<String, String, String, String>.fromJson(json);

    expect(
      personalizedFeed,
      const PersonalizedFeed<String, String, String, String>(
        limit: 25,
        offset: 0,
        version: 'user_1_1619210635',
        next: '',
        results: [],
        duration: '419.81ms',
      ),
    );
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
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      // latestChildren: {
      //   "test": [reaction2]
      // },//TODO: test this
      childrenCounts: const {'test': 1},
    );
    final enrichedActivity = GenericEnrichedActivity(
      id: 'test',
      actor: 'test',
      object: 'test',
      verb: 'test',
      target: 'test',
      to: const ['test'],
      foreignId: 'test',
      time: DateTime.parse('2001-09-11T00:01:02.000'),
      analytics: const {'test': 'test'},
      extraContext: const {'test': 'test'},
      origin: 'test',
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
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      // latestChildren: {
      //   "test": [reaction2]
      // },//TODO: test this
      childrenCounts: const {'test': 1},
    );
    final paginatedReactions =
        PaginatedReactions('test', [reaction], enrichedActivity, 'duration');

    final paginatedReactionsJson =
        json.decode(fixture('paginated_reactions.json'));
    final paginatedReactionsFromJson =
        PaginatedReactions<String, String, String, String>.fromJson(
            paginatedReactionsJson);
    expect(paginatedReactionsFromJson, paginatedReactions);
    expect(
        paginatedReactions.toJson(
          (json) => json,
          (json) => json,
          (json) => json,
          (json) => json,
        ),
        {
          'next': 'test',
          'results': [
            {
              'kind': 'test',
              'activity_id': 'test',
              'user_id': 'test',
              'parent': 'test',
              'created_at': '2001-09-11T00:01:02.000',
              'target_feeds': ['slug:userId'],
              'user': {
                'id': 'test',
                'data': {'test': 'test'}
              },
              'target_feeds_extra_data': {'test': 'test'},
              'data': {'test': 'test'}
            }
          ],
          'duration': 'duration',
          'activity': {
            'actor': 'test',
            'verb': 'test',
            'target': 'test',
            'object': 'test',
            'origin': 'test',
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

  group('ActivityMarker', () {
    test('allRead', () {
      final allRead = ActivityMarker()
        ..read(['id1', 'id2'])
        ..allRead();
      expect(allRead.params, {'mark_read': 'true'});
    });

    test('allSeen', () {
      final allSeen = ActivityMarker()
        ..seen(['id1', 'id2'])
        ..allSeen();
      expect(allSeen.params, {'mark_seen': 'true'});
    });

    test("seen 'id1', 'id2'", () {
      final seen = ActivityMarker()..seen(['id1', 'id2']);
      expect(seen.params, {'mark_seen': 'id1,id2'});
    });

    test("read 'id1', 'id2'", () {
      final seen = ActivityMarker()..read(['id1', 'id2']);
      expect(seen.params, {'mark_read': 'id1,id2'});
    });
  });

  test('Follow', () {
    const converter = DateTimeUTCConverter();
    final followJson = {
      'feed_id': 'timeline:feedId',
      'target_id': 'user:userId',
      'created_at': '2021-05-14T19:58:27.274792063Z',
      'updated_at': '2021-05-14T19:58:27.274792063Z'
    };
    final follow = Follow(
        feedId: 'timeline:feedId',
        targetId: 'user:userId',
        createdAt: converter.fromJson('2021-05-14T19:58:27.274792063Z'),
        updatedAt: converter.fromJson('2021-05-14T19:58:27.274792063Z'));

    expect(follow, Follow.fromJson(followJson));
    expect(follow.toJson(), {
      'feed_id': 'timeline:feedId',
      'target_id': 'user:userId',
      'created_at': '2021-05-14T19:58:27-00:00',
      'updated_at': '2021-05-14T19:58:27-00:00'
    });
  });

  test('FollowRelation', () {
    const follow = FollowRelation(source: 'feedId', target: 'targetId');
    final followJson =
        json.decode('{"source": "feedId", "target": "targetId"}');

    expect(follow, FollowRelation.fromJson(followJson));
    expect(follow.toJson(), {'source': 'feedId', 'target': 'targetId'});
  });

  group('Unfollow', () {
    const unfollow = UnFollowRelation(
        source: 'feedId', target: 'targetId', keepHistory: true);

    test('fromFollow', () {
      const follow = FollowRelation(source: 'feedId', target: 'targetId');
      final unfollowFromFollow = UnFollowRelation.fromFollow(follow, true);
      expect(unfollowFromFollow, unfollow);
    });

    test('fromJson', () {
      final unfollowJson = json.decode(fixture('unfollow_relation.json'));
      expect(unfollow, UnFollowRelation.fromJson(unfollowJson));
    });

    test('toJson', () {
      expect(unfollow.toJson(),
          {'source': 'feedId', 'target': 'targetId', 'keep_history': true});
    });
  });

  group('ActivityUpdate', () {
    group('withForeignId', () {
      final foreignIdActivity = ActivityUpdate.withForeignId(
        foreignId: 'test',
        time: DateTime.parse('2001-09-11T00:01:02.000'),
        set: const {'hey': 'hey'},
        unset: const ['test'],
      );

      test('fromJson', () {
        final activityUpdateJson =
            json.decode(fixture('activity_update_with_foreign_id.json'));
        final activityUpdateFromJson =
            ActivityUpdate.fromJson(activityUpdateJson);
        expect(activityUpdateFromJson, foreignIdActivity);
      });

      test('toJson', () {
        expect(foreignIdActivity.toJson(), {
          'foreign_id': 'test',
          'time': '2001-09-11T00:01:02.000',
          'set': {'hey': 'hey'},
          'unset': ['test']
        });
      });

      test('equality', () {
        final activityUpdateWithForeignId = ActivityUpdate.withForeignId(
          foreignId: 'id',
          time: DateTime.parse('2001-09-11T00:01:02.000'),
          set: const {'hey': 'hey'},
          unset: const ['test'],
        );
        expect(
          activityUpdateWithForeignId,
          ActivityUpdate.withForeignId(
            foreignId: 'id',
            time: DateTime.parse('2001-09-11T00:01:02.000'),
            set: const {'hey': 'hey'},
            unset: const ['test'],
          ),
        );
      });
    });

    group('withId', () {
      final idActivity = ActivityUpdate.withId(
        id: 'test',
        set: const {'hey': 'hey'},
        unset: const ['test'],
      );

      test('fromJson', () {
        final activityUpdateJson =
            json.decode(fixture('activity_update_with_id.json'));
        final activityUpdateFromJson =
            ActivityUpdate.fromJson(activityUpdateJson);
        expect(activityUpdateFromJson, idActivity);
      });

      test('toJson', () {
        expect(idActivity.toJson(), {
          'id': 'test',
          'set': {'hey': 'hey'},
          'unset': ['test']
        });
      });

      test('equality', () {
        final activityUpdateWithId = ActivityUpdate.withId(
          id: 'id',
          set: const {'hey': 'hey'},
          unset: const ['test'],
        );
        expect(
          activityUpdateWithId,
          ActivityUpdate.withId(
            id: 'id',
            set: const {'hey': 'hey'},
            unset: const ['test'],
          ),
        );
      });
    });
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

  group('Thumbnail', () {
    test('params', () {
      const resize = Thumbnail(10, 10);
      expect(resize.params,
          {'resize': 'clip', 'crop': 'center', 'w': 10, 'h': 10});
    });

    test('Width should be a positive number', () {
      expect(
          () => Thumbnail(-1, 10),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Width should be a positive number')));
    });

    test('Height should be a positive number', () {
      expect(
          () => Thumbnail(10, -1),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'Height should be a positive number')));
    });
  });

  group('Reaction', () {
    final reaction2 = Reaction(
      id: 'test',
      kind: 'test',
      activityId: 'test',
      userId: 'test',
      parent: 'test',
      createdAt: DateTime.parse('2001-09-11T00:01:02.000'),
      updatedAt: DateTime.parse('2001-09-11T00:01:02.000'),
      targetFeeds: [FeedId('slug', 'userId')],
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      childrenCounts: const {'test': 1},
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
      user: const User(id: 'test', data: {'test': 'test'}),
      targetFeedsExtraData: const {'test': 'test'},
      data: const {'test': 'test'},
      // latestChildren: {
      //   "test": [reaction2]
      // },//TODO: test this
      childrenCounts: const {'test': 1},
    );

    test('copyWith', () {
      final reactionCopiedWith =
          reaction.copyWith(data: {'text': 'awesome post!'});
      expect(reactionCopiedWith.data, {'text': 'awesome post!'});
    });

    test('fromJson', () {
      final reactionJson = json.decode(fixture('reaction.json'));
      final reactionFromJson = Reaction.fromJson(reactionJson);
      expect(reactionFromJson, reaction);
    });

    test('toJson', () {
      expect(reaction.toJson(), {
        'kind': 'test',
        'activity_id': 'test',
        'user_id': 'test',
        'parent': 'test',
        'created_at': '2001-09-11T00:01:02.000',
        'target_feeds': ['slug:userId'],
        'user': {
          'id': 'test',
          'data': {'test': 'test'}
        },
        'target_feeds_extra_data': {'test': 'test'},
        'data': {'test': 'test'}
      });
    });
  });
  group('OG', () {
    test('Image', () {
      const image = OgImage(
          image: 'test',
          url: 'test',
          secureUrl: 'test',
          width: 'test',
          height: 'test',
          type: 'test',
          alt: 'test');
      final imageJson = json.decode(fixture('image.json'));
      final imageFromJson = OgImage.fromJson(imageJson);
      expect(imageFromJson, image);
    });

    group('OG', () {
      test('Image', () {
        const image = OgImage(
            image: 'test',
            url: 'test',
            secureUrl: 'test',
            width: 'test',
            height: 'test',
            type: 'test',
            alt: 'test');
        final imageJson = json.decode(fixture('image.json'));
        final imageFromJson = OgImage.fromJson(imageJson);
        expect(imageFromJson, image);
      });

      test('Video', () {
        const video = OgVideo(
          image: 'test',
          url: 'test',
          secureUrl: 'test',
          width: 'test',
          height: 'test',
          type: 'test',
          alt: 'test',
        );

        final videoJson = json.decode(fixture('video.json'));
        final videoFromJson = OgVideo.fromJson(videoJson);
        expect(videoFromJson, video);
      });

      test('Audio', () {
        const audio = OgAudio(
          audio: 'test',
          url: 'test',
          secureUrl: 'test',
          type: 'test',
        );
        final audioJson = json.decode(fixture('audio.json'));
        final audioFromJson = OgAudio.fromJson(audioJson);
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
            OgImage(
                image: 'test',
                url: 'test',
                secureUrl: 'test',
                width: 'test',
                height: 'test',
                type: 'test',
                alt: 'test')
          ],
          videos: [
            OgVideo(
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
            OgAudio(
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
            {
              'audio': 'test',
              'url': 'test',
              'secure_url': 'test',
              'type': 'test'
            }
          ]
        });
      });

      test('activity attachment', () {
        const openGraph = OpenGraphData(
            title:
                "'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'",
            url:
                'https://www.rollingstone.com/music/music-news/nicki-minaj-cancels-north-american-tour-with-future-714315/',
            description:
                'Why choose one when you can wear both? These energizing pairings stand out from the crowd',
            images: [
              OgImage(
                image:
                    'https://www.rollingstone.com/wp-content/uploads/2018/08/GettyImages-1020376858.jpg',
              )
            ]);

        expect(
            openGraph,
            OpenGraphData.fromJson(
              const {
                'description':
                    'Why choose one when you can wear both? These energizing pairings stand out from the crowd',
                'title':
                    "'Queen' rapper rescheduling dates to 2019 after deciding to &#8220;reevaluate elements of production on the 'NickiHndrxx Tour'",
                'url':
                    'https://www.rollingstone.com/music/music-news/nicki-minaj-cancels-north-american-tour-with-future-714315/',
                'images': [
                  {
                    'image':
                        'https://www.rollingstone.com/wp-content/uploads/2018/08/GettyImages-1020376858.jpg',
                  },
                ],
              },
            ));
      });
    });

    group('AttachmentFile', () {
      const path = 'testPath';
      const name = 'testFile';
      final bytes = Uint8List.fromList([]);
      const size = 0;

      test('should throw if `path` or `bytes` is not provided', () {
        expect(() => AttachmentFile(), throwsA(isA<AssertionError>()));
      });

      test('toJson', () {
        final attachmentFile = AttachmentFile(
          path: path,
          name: name,
          bytes: bytes,
          size: size,
        );

        expect(attachmentFile.toJson(), {
          'path': 'testPath',
          'name': 'testFile',
          'bytes': '',
          'size': 0,
        });
      });

      test('fromJson', () {
        final file = json.decode(fixture('attachment_file.json'));
        final attachmentFile = AttachmentFile.fromJson(file);

        expect(attachmentFile.path, path);
        expect(attachmentFile.name, name);
        expect(attachmentFile.bytes, bytes);
        expect(attachmentFile.size, size);
      });
    });
  });
}
