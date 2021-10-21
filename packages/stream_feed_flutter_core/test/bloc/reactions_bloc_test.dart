import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockReactions mockReactions;
  late MockStreamAnalytics mockStreamAnalytics;
  late LookupAttribute lookupAttr;
  late String lookupValue;
  late Filter filter;
  late int limit;
  late String kind;
  late List<Reaction> reactions;
  late String activityId;
  late List<FeedId> targetFeeds;
  late Map<String, String> data;
  late FeedBloc bloc;
  late MockReactionsControllers mockReactionControllers;
  late String feedGroup;
  late MockFeedAPI mockFeed;
  late MockFeedAPI mockSecondFeed;
  late Activity activity;
  late MockStreamUser mockUser;
  late String userId;
  late MockStreamUser mockSecondUser;
  late String secondUserId;
  late EnrichedActivity<String, String, String, String> enrichedActivity;
  late Activity addedActivity;
  late List<Follow> following;

  tearDown(() => bloc.dispose());

  setUp(() {
    mockFeed = MockFeedAPI();
    mockSecondFeed = MockFeedAPI();
    mockReactions = MockReactions();
    mockReactionControllers = MockReactionsControllers();
    mockStreamAnalytics = MockStreamAnalytics();
    mockClient = MockStreamFeedClient();
    lookupAttr = LookupAttribute.activityId;
    lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    filter = Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');

    limit = 5;
    kind = 'like';
    activityId = 'activityId';
    userId = 'john-doe';
    targetFeeds = <FeedId>[];
    data = {'text': 'awesome post!'};
    feedGroup = 'user';
    reactions = [
      Reaction(
        id: 'id',
        kind: 'like',
        activityId: activityId,
        childrenCounts: const {
          'like': 0,
        },
        latestChildren: const {'like': []},
        ownChildren: const {'like': []},
      )
    ];
    when(() => mockClient.reactions).thenReturn(mockReactions);

    activity = const Activity(
      actor: 'test',
      verb: 'post',
      object: 'test',
    );

    addedActivity = const Activity(
      id: 'test',
      actor: 'test',
      verb: 'post',
      object: 'test',
    );

    enrichedActivity = const EnrichedActivity(
      id: 'test',
      actor: 'test',
      verb: 'post',
      object: 'test',
    );

    following = [];

    mockUser = MockStreamUser();
    userId = '1';
    mockSecondUser = MockStreamUser();
    secondUserId = '2';
    when(() => mockClient.flatFeed('user', 'test')).thenReturn(mockFeed);
    when(() => mockClient.flatFeed('user', userId)).thenReturn(mockFeed);
    when(() => mockClient.flatFeed('user', secondUserId)).thenReturn(mockFeed);
    when(() => mockFeed.addActivity(activity))
        .thenAnswer((invocation) async => addedActivity);
    when(() => mockClient.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn(userId);
    when(() => mockSecondUser.id).thenReturn(secondUserId);
    when(() => mockUser.ref).thenReturn('test');
    bloc = FeedBloc(client: mockClient);
    when(() =>
        mockFeed.getEnrichedActivityDetail<String, String, String, String>(
            addedActivity.id!)).thenAnswer((_) async => enrichedActivity);
    when(() => mockFeed.follow(mockSecondFeed))
        .thenAnswer((_) => Future.value());
    when(() => mockFeed.unfollow(mockSecondFeed))
        .thenAnswer((_) => Future.value());
    when(() => mockFeed.following(
          limit: 1,
          offset: 0,
          filter: [
            FeedId.id('user:$userId'),
          ],
        )).thenAnswer((_) async => following);
  });

  group('ReactionBloc', () {
    test('queryReactions', () async {
      when(() => mockReactions.filter(
            lookupAttr,
            lookupValue,
            filter: filter,
            limit: limit,
            kind: kind,
          )).thenAnswer((_) async => reactions);
      await bloc.queryReactions(
        lookupAttr,
        lookupValue,
        filter: filter,
        limit: limit,
        kind: kind,
      );
      verify(() => mockReactions.filter(lookupAttr, lookupValue,
          filter: filter, limit: limit, kind: kind)).called(1);
      await expectLater(bloc.getReactionsStream(lookupValue), emits(reactions));
    });

    test('onAddReaction', () async {
      final addedReaction = Reaction();
      bloc.reactionsControllers = mockReactionControllers;
      when(() => mockReactionControllers.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsControllers.getReactions(activityId), reactions);
      when(() => mockReactions.add(
            kind,
            activityId,
          )).thenAnswer((_) async => addedReaction);

      await bloc.onAddReaction(
          activity: EnrichedActivity(id: activityId),
          feedGroup: feedGroup,
          kind: kind);
      verify(() => mockReactions.add(
            kind,
            activityId,
          )).called(1);
      await expectLater(
          bloc.activitiesStream,
          emits([
            EnrichedActivity(id: activityId, reactionCounts: const {
              'like': 1
            }, ownReactions: {
              'like': [addedReaction]
            }, latestReactions: {
              'like': [addedReaction]
            })
          ]));

      //TODO: test reaction Stream
    });
    test('onRemoveReaction', () async {
      const reactionId = 'reactionId';
      final reaction = Reaction(id: reactionId);
      bloc.reactionsControllers = mockReactionControllers;
      when(() => mockReactionControllers.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsControllers.getReactions(activityId), reactions);
      when(() => mockReactions.delete(reactionId))
          .thenAnswer((invocation) => Future.value());

      await bloc.onRemoveReaction(
        activity: EnrichedActivity(id: activityId, reactionCounts: const {
          'like': 1
        }, ownReactions: {
          'like': [reaction]
        }, latestReactions: {
          'like': [reaction]
        }),
        feedGroup: feedGroup,
        kind: kind,
        reaction: reaction,
      );
      verify(() => mockReactions.delete(reactionId)).called(1);
      await expectLater(
          bloc.activitiesStream,
          emits([
            EnrichedActivity(
                id: activityId,
                reactionCounts: const {'like': 0},
                ownReactions: const {'like': []},
                latestReactions: const {'like': []})
          ]));

      //TODO: test reaction Stream
    });

    group('child reactions', () {
      test('onAddChildReaction', () async {
        final controller = ReactionsControllers();
        const parentId = 'parentId';
        const childId = 'childId';
        final now = DateTime.now();
        final reactedActivity = EnrichedActivity(
          id: 'id',
          time: now,
          actor: User(data: const {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          }),
        );
        controller.init(reactedActivity.id!);
        bloc.reactionsControllers = controller;
        expect(bloc.reactionsControllers.hasValue(reactedActivity.id!), true);
        final parentReaction = Reaction(
            id: parentId, kind: 'comment', activityId: reactedActivity.id);
        final childReaction =
            Reaction(id: childId, kind: 'like', activityId: reactedActivity.id);

        when(() => mockReactions.addChild('like', parentId))
            .thenAnswer((_) async => childReaction);
        await bloc.onAddChildReaction(
            kind: 'like', activity: reactedActivity, reaction: parentReaction);

        verify(() => mockClient.reactions.addChild(
              'like',
              parentId,
            )).called(1);
        await expectLater(
            bloc.getReactionsStream(reactedActivity.id!),
            emits([
              Reaction(
                id: parentId,
                kind: 'comment',
                activityId: reactedActivity.id,
                childrenCounts: const {'like': 1},
                latestChildren: {
                  'like': [childReaction]
                },
                ownChildren: {
                  'like': [childReaction]
                },
              )
            ]));

        //TODO: test reaction Stream
      });

      test('onRemoveChildReaction', () async {
        final controller = ReactionsControllers();
        final now = DateTime.now();
        const childId = 'childId';
        const parentId = 'parentId';
        final reactedActivity = EnrichedActivity(
          id: 'id',
          time: now,
          actor: const User(data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          }),
        );
        final childReaction = Reaction(id: childId, kind: 'like');
        final parentReaction = Reaction(
          id: parentId,
          kind: 'comment',
          activityId: reactedActivity.id,
          childrenCounts: const {'like': 1},
          latestChildren: {
            'like': [childReaction]
          },
          ownChildren: {
            'like': [childReaction]
          },
        );

        controller.init(reactedActivity.id!);
        bloc.reactionsControllers = controller;
        expect(bloc.reactionsControllers.hasValue(reactedActivity.id!), true);
        when(() => mockReactions.delete(childId))
            .thenAnswer((_) async => Future.value());
        await bloc.onRemoveChildReaction(
            kind: 'like',
            activity: reactedActivity,
            parentReaction: parentReaction,
            childReaction: childReaction);

        verify(() => mockClient.reactions.delete(childId)).called(1);

        await expectLater(
            bloc.getReactionsStream(reactedActivity.id!),
            emits([
              Reaction(
                id: parentId,
                kind: 'comment',
                activityId: reactedActivity.id,
                childrenCounts: const {'like': 0},
                latestChildren: const {'like': []},
                ownChildren: const {'like': []},
              )
            ]));
      });
    });
  });

  group('Activities', () {
    test(
        '''When we await onAddActivity the stream gets updated with the new expected value''',
        () async {
      await bloc.onAddActivity(
        feedType: FeedType.flat,
        feedGroup: 'user',
        verb: 'post',
        object: 'test',
        userId: 'test',
      );
      verify(() => mockFeed.addActivity(activity)).called(1);
      verify(() => mockFeed.getEnrichedActivityDetail(addedActivity.id!))
          .called(1);
      await expectLater(bloc.activitiesStream, emits([enrichedActivity]));
    });
  });

  group('currentUser', () {
    test('currentUser matches', () {
      expect(bloc.currentUser, mockUser);
    });
  });

  group('Follows', () {
    test('isFollowingUser', () async {
      final isFollowing = await bloc.isFollowingUser('2');
      expect(isFollowing, false);
    });

    test('followUser', () async {
      await bloc.followUser(mockSecondFeed);
      verify(() => mockFeed.follow(mockSecondFeed)).called(1);
    });

    test('unfollowUser', () async {
      await bloc.unfollowUser(mockSecondFeed);
      verify(() => mockFeed.unfollow(mockSecondFeed)).called(1);
    });
  });
}
