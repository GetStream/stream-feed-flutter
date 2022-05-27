import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import '../mocks.dart';

void main() {
  late MockStreamFeedClient mockClient;
  late MockReactions mockReactions;
  late LookupAttribute lookupAttr;
  late String lookupValue;
  late Filter filter;
  late int limit;
  late String kind;
  late List<Reaction> reactions;
  late String activityId;
  late GenericFeedBloc bloc;
  late MockReactionsManager mockReactionsManager;
  late MockActivitiesManager mockActivitiesManager;
  late MockGroupedActivitiesManager mockGroupedActivitiesManager;
  late String feedGroup;
  late MockFlatFeed mockFeed;
  late MockAggregatedFeed mockAggregatedFeed;
  late MockFlatFeed mockSecondFeed;
  late Activity activity;
  late MockStreamUser mockUser;
  late String userId;
  late MockStreamUser mockSecondUser;
  late String secondUserId;
  late GenericEnrichedActivity<String, String, String, String> enrichedActivity;
  late Activity addedActivity;
  late List<Follow> following;

  tearDown(() => bloc.dispose());

  setUp(() {
    mockFeed = MockFlatFeed();
    mockAggregatedFeed = MockAggregatedFeed();
    mockSecondFeed = MockFlatFeed();
    mockReactions = MockReactions();
    mockReactionsManager = MockReactionsManager();
    mockActivitiesManager = MockActivitiesManager();
    mockGroupedActivitiesManager = MockGroupedActivitiesManager();
    mockClient = MockStreamFeedClient();
    lookupAttr = LookupAttribute.activityId;
    lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
    filter = Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');

    limit = 5;
    kind = 'like';
    activityId = 'activityId';
    userId = 'john-doe';
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

    activity = const Activity(actor: 'test', verb: 'post', object: 'test');

    addedActivity = const Activity(
      id: 'test',
      actor: 'test',
      verb: 'post',
      object: 'test',
    );

    enrichedActivity = const GenericEnrichedActivity(
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
    when(() => mockClient.flatFeed('timeline')).thenReturn(mockFeed);
    when(() => mockClient.flatFeed('user')).thenReturn(mockFeed);
    when(() => mockClient.aggregatedFeed('user'))
        .thenReturn(mockAggregatedFeed);
    when(() => mockClient.flatFeed('user', userId)).thenReturn(mockFeed);
    when(() => mockClient.flatFeed('user', secondUserId)).thenReturn(mockFeed);
    when(() => mockFeed.addActivity(activity))
        .thenAnswer((invocation) async => addedActivity);
    when(() => mockClient.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn(userId);
    when(() => mockSecondUser.id).thenReturn(secondUserId);
    when(() => mockUser.ref).thenReturn('test');
    bloc = GenericFeedBloc(
      client: mockClient,
      reactionsManager: mockReactionsManager,
      activitiesManager: mockActivitiesManager,
      groupedActivitiesManager: mockGroupedActivitiesManager,
    );
    when(() => mockFeed.getEnrichedActivityDetail(addedActivity.id!))
        .thenAnswer((_) async => enrichedActivity);
  });

  group('ReactionBloc', () {
    test('queryReactions', () async {
      bloc = GenericFeedBloc(client: mockClient);
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
      final activitiesManager = ActivitiesManager();
      const addedReaction = Reaction(id: '1');
      activitiesManager.init(feedGroup);
      bloc = GenericFeedBloc(
        client: mockClient,
        activitiesManager: activitiesManager,
        reactionsManager: mockReactionsManager,
      );
      expect(bloc.activitiesManager.hasValue(feedGroup), true);
      when(() => mockReactionsManager.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsManager.getReactions(activityId), reactions);
      when(() => mockReactions.add(
            kind,
            activityId,
          )).thenAnswer((_) async => addedReaction);

      await bloc.onAddReaction(
        activity: GenericEnrichedActivity(id: activityId),
        feedGroup: feedGroup,
        kind: kind,
      );
      verify(() => mockReactions.add(
            kind,
            activityId,
          )).called(1);
      await expectLater(
          bloc.getActivitiesStream(feedGroup),
          emits([
            GenericEnrichedActivity(id: activityId, reactionCounts: const {
              'like': 1
            }, ownReactions: const {
              'like': [addedReaction]
            }, latestReactions: const {
              'like': [addedReaction]
            })
          ]));

      //TODO: test reaction Stream
    });

    test('onRemoveReaction', () async {
      final controller = ActivitiesManager();

      const reactionId = 'reactionId';
      const reaction = Reaction(id: reactionId);
      controller.init(feedGroup);
      bloc = GenericFeedBloc(
        client: mockClient,
        activitiesManager: controller,
        reactionsManager: mockReactionsManager,
      );
      when(() => mockReactionsManager.getReactions(activityId))
          .thenAnswer((_) => reactions);
      expect(bloc.reactionsManager.getReactions(activityId), reactions);
      when(() => mockReactions.delete(reactionId))
          .thenAnswer((invocation) => Future.value());

      await bloc.onRemoveReaction(
        activity:
            GenericEnrichedActivity(id: activityId, reactionCounts: const {
          'like': 1
        }, ownReactions: const {
          'like': [reaction]
        }, latestReactions: const {
          'like': [reaction]
        }),
        feedGroup: feedGroup,
        kind: kind,
        reaction: reaction,
      );
      verify(() => mockReactions.delete(reactionId)).called(1);
      await expectLater(
          bloc.getActivitiesStream(feedGroup),
          emits([
            GenericEnrichedActivity(
                id: activityId,
                reactionCounts: const {'like': 0},
                ownReactions: const {'like': []},
                latestReactions: const {'like': []})
          ]));

      //TODO: test reaction Stream
    });

    test(
        '''When we call queryPaginatedReactions and loadMorePaginatedReactions, the stream gets updated with the new paginated results''',
        () async {
      // final controller = ReactionsManager()..init(feedGroup);
      // bloc.reactionsManager = controller;

      const keyField = 'q29npdvqjr99';
      const idLtField = 'f168f547-b59f-11ec-85ff-0a2d86f21f5d';
      const limitField = '10';
      const nextParamsString =
          '/api/v1.0/enrich/feed/user/gordon/?api_key=$keyField&id_lt=$idLtField&limit=$limitField';
      final nextParams = parseNext(nextParamsString);

      bloc = GenericFeedBloc(
        client: mockClient,
      );

      // FIRST RESULT

      const reactionsFirstResult = [Reaction(id: '1'), Reaction(id: '2')];

      when(() => mockReactions.paginatedFilter(
            lookupAttr,
            lookupValue,
            filter: filter,
            limit: limit,
            kind: kind,
          )).thenAnswer(
        (_) async => const PaginatedReactions(
          next: nextParamsString,
          results: reactionsFirstResult,
        ),
      );

      await bloc.queryPaginatedReactions(
        lookupAttr,
        lookupValue,
        filter: filter,
        limit: limit,
        kind: kind,
      );

      verify(() => mockReactions.paginatedFilter(
            lookupAttr,
            lookupValue,
            filter: filter,
            limit: limit,
            kind: kind,
          )).called(1);

      expect(
        bloc.getReactions(lookupValue),
        reactionsFirstResult,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getReactionsStream(lookupValue),
        emits(reactionsFirstResult),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsReactions(lookupValue: lookupValue),
        nextParams,
        reason: 'paginated params are updated with the latest value',
      );

      // SECOND RESULT

      const reactionsSecondResult = [
        Reaction(id: '2'), // purposely contains a duplicate for testing
        Reaction(id: '3'),
        Reaction(id: '4'),
      ];

      when(() => mockReactions.paginatedFilter(
            lookupAttr,
            lookupValue,
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).thenAnswer(
        (_) {
          return Future.value(
            const PaginatedReactions(next: '', results: reactionsSecondResult),
          );
        },
      );

      await bloc.loadMoreReactions(
        lookupValue,
        lookupAttr: lookupAttr,
        limit: nextParams.limit,
      );

      verify(() => mockReactions.paginatedFilter(
            lookupAttr,
            lookupValue,
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).called(1);

      // Make sure all activities in the list are unique.
      final allReactions =
          {...reactionsFirstResult, ...reactionsSecondResult}.toList();

      expect(
        bloc.getReactions(lookupValue),
        allReactions,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getReactionsStream(lookupValue),
        emits(allReactions),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsReactions(lookupValue: lookupValue),
        null,
        reason: 'paginated params are null',
      );
    });

    group('child reactions', () {
      test('onAddChildReaction', () async {
        final reactionManager = ReactionsManager();
        const parentId = 'parentId';
        const childId = 'childId';
        final now = DateTime.now();
        final reactedActivity = GenericEnrichedActivity(
          id: 'id',
          time: now,
          actor: const User(
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing fresbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
        );
        reactionManager.init(reactedActivity.id!);
        bloc = GenericFeedBloc(
            client: mockClient, reactionsManager: reactionManager);
        expect(bloc.reactionsManager.hasValue(reactedActivity.id!), true);
        final parentReaction = Reaction(
            id: parentId, kind: 'comment', activityId: reactedActivity.id);
        final childReaction =
            Reaction(id: childId, kind: 'like', activityId: reactedActivity.id);

        when(() => mockReactions.addChild('like', parentId))
            .thenAnswer((_) async => childReaction);
        await bloc.onAddChildReaction(
            kind: 'like',
            lookupValue: reactedActivity.id!,
            reaction: parentReaction);

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
        final reactionsManager = ReactionsManager();
        final now = DateTime.now();
        const childId = 'childId';
        const parentId = 'parentId';
        final reactedActivity = GenericEnrichedActivity(
          id: 'id',
          time: now,
          actor: const User(data: {
            'name': 'Rosemary',
            'handle': '@rosemary',
            'subtitle': 'likes playing fresbee in the park',
            'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
          }),
        );
        const childReaction = Reaction(id: childId, kind: 'like');
        final parentReaction = Reaction(
          id: parentId,
          kind: 'comment',
          activityId: reactedActivity.id,
          childrenCounts: const {'like': 1},
          latestChildren: const {
            'like': [childReaction]
          },
          ownChildren: const {
            'like': [childReaction]
          },
        );

        bloc = GenericFeedBloc(
            client: mockClient, reactionsManager: reactionsManager);

        reactionsManager.init(reactedActivity.id!);
        expect(bloc.reactionsManager.hasValue(reactedActivity.id!), true);
        when(() => mockReactions.delete(childId))
            .thenAnswer((_) async => Future.value());

        await bloc.onRemoveChildReaction(
            kind: 'like',
            lookupValue: reactedActivity.id!,
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
        '''When we await onAddActivityGroup the stream gets updated with the new expected value''',
        () async {
      final manager = GroupedActivitiesManager()..init(feedGroup);
      bloc = GenericFeedBloc(
        client: mockClient,
        groupedActivitiesManager: manager,
      );

      const enrichedActivity = Group<EnrichedActivity>(id: '1');
      when(() => mockAggregatedFeed.addActivity(activity))
          .thenAnswer((invocation) async => addedActivity);

      when(() =>
              mockAggregatedFeed.getEnrichedActivityDetail(addedActivity.id!))
          .thenAnswer((_) async => enrichedActivity);

      await bloc.onAddActivityGroup(
        feedGroup: 'user',
        verb: 'post',
        object: 'test',
      );
      verify(() => mockAggregatedFeed.addActivity(activity)).called(1);
      verify(() =>
              mockAggregatedFeed.getEnrichedActivityDetail(addedActivity.id!))
          .called(1);
      await expectLater(bloc.getGroupedActivitiesStream(feedGroup),
          emits([enrichedActivity]));
    });

    test(
        '''When we await onAddActivity the stream gets updated with the new expected value''',
        () async {
      final manager = ActivitiesManager()..init(feedGroup);
      bloc = GenericFeedBloc(
        client: mockClient,
        activitiesManager: manager,
      );

      await bloc.onAddActivity(
        feedGroup: 'user',
        verb: 'post',
        object: 'test',
        userId: 'test',
      );
      verify(() => mockFeed.addActivity(activity)).called(1);
      verify(() => mockFeed.getEnrichedActivityDetail(addedActivity.id!))
          .called(1);
      await expectLater(
          bloc.getActivitiesStream(feedGroup), emits([enrichedActivity]));
    });

    test(
        '''When we call queryPaginatedEnrichedActivities and loadMoreEnrichedActivities, the stream gets updated with the new paginated results''',
        () async {
      final manager = ActivitiesManager()..init(feedGroup);
      bloc = GenericFeedBloc(client: mockClient, activitiesManager: manager);

      const keyField = 'q29npdvqjr99';
      const idLtField = 'f168f547-b59f-11ec-85ff-0a2d86f21f5d';
      const limitField = '10';
      const nextParamsString =
          '/api/v1.0/enrich/feed/user/gordon/?api_key=$keyField&id_lt=$idLtField&limit=$limitField';
      final nextParams = parseNext(nextParamsString);

      // FIRST RESULT

      const enrichedActivitiesFirstResult = [
        EnrichedActivity(id: '1'),
        EnrichedActivity(id: '2')
      ];

      when(() => mockFeed.getPaginatedEnrichedActivities()).thenAnswer(
        (_) {
          return Future.value(
            const PaginatedActivities(
              next: nextParamsString,
              results: enrichedActivitiesFirstResult,
            ),
          );
        },
      );

      await bloc.queryPaginatedEnrichedActivities(feedGroup: feedGroup);

      verify(() =>
              mockClient.flatFeed(feedGroup).getPaginatedEnrichedActivities())
          .called(1);
      verify(() => mockFeed.getPaginatedEnrichedActivities()).called(1);

      expect(
        bloc.getActivities(feedGroup),
        enrichedActivitiesFirstResult,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getActivitiesStream(feedGroup),
        emits(enrichedActivitiesFirstResult),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsActivities(feedGroup: feedGroup),
        nextParams,
        reason: 'paginated params are updated with the latest value',
      );

      // SECOND RESULT

      const enrichedActivitiesSecondResult = [
        EnrichedActivity(id: '2'), // purposely contains a duplicate for testing
        EnrichedActivity(id: '3'),
        EnrichedActivity(id: '4'),
      ];

      when(() => mockFeed.getPaginatedEnrichedActivities(
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).thenAnswer(
        (_) {
          return Future.value(
            const PaginatedActivities(
              next: '',
              results: enrichedActivitiesSecondResult,
            ),
          );
        },
      );

      await bloc.loadMoreEnrichedActivities(feedGroup: feedGroup);

      verify(
          () => mockClient.flatFeed(feedGroup).getPaginatedEnrichedActivities(
                filter: nextParams.idLT,
                limit: nextParams.limit,
              )).called(1);
      verify(() => mockFeed.getPaginatedEnrichedActivities(
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).called(1);

      // Make sure all activities in the list are unique.
      final allActivities = {
        ...enrichedActivitiesFirstResult,
        ...enrichedActivitiesSecondResult
      }.toList();

      expect(
        bloc.getActivities(feedGroup),
        allActivities,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getActivitiesStream(feedGroup),
        emits(allActivities),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsActivities(feedGroup: feedGroup),
        null,
        reason: 'paginated params are null',
      );
    });

    test(
        '''When we call queryPaginatedGroupedActivities and loadMorePaginatedGroupedActivities, the stream gets updated with the new paginated results''',
        () async {
      final manager = ActivitiesManager()..init(feedGroup);
      bloc = GenericFeedBloc(client: mockClient, activitiesManager: manager);
      const keyField = 'q29npdvqjr99';
      const idLtField = 'f168f547-b59f-11ec-85ff-0a2d86f21f5d';
      const limitField = '10';
      const nextParamsString =
          '/api/v1.0/enrich/feed/user/gordon/?api_key=$keyField&id_lt=$idLtField&limit=$limitField';
      final nextParams = parseNext(nextParamsString);

      // FIRST RESULT

      const groupedActivitiesFirstResult = [
        Group<EnrichedActivity>(id: '1'),
        Group<EnrichedActivity>(id: '2')
      ];

      when(() => mockAggregatedFeed.getPaginatedActivities()).thenAnswer(
        (_) async => const PaginatedActivitiesGroup(
          next: nextParamsString,
          results: groupedActivitiesFirstResult,
        ),
      );
      await bloc.queryPaginatedGroupedActivities(feedGroup: feedGroup);

      verify(() => mockAggregatedFeed.getPaginatedActivities()).called(1);

      expect(
        bloc.getGroupedActivities(feedGroup),
        groupedActivitiesFirstResult,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getGroupedActivitiesStream(feedGroup),
        emits(groupedActivitiesFirstResult),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsGroupedActivites(feedGroup: feedGroup),
        nextParams,
        reason: 'paginated params are updated with the latest value',
      );

      // // SECOND RESULT

      const groupedActivitiesSecondResult = [
        Group<EnrichedActivity>(
            id: '2'), // purposely contains a duplicate for testing
        Group<EnrichedActivity>(id: '3'),
        Group<EnrichedActivity>(id: '4'),
      ];

      when(() => mockAggregatedFeed.getPaginatedActivities(
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).thenAnswer(
        (_) async => const PaginatedActivitiesGroup(
          next: '',
          results: groupedActivitiesSecondResult,
        ),
      );

      await bloc.loadMoreGroupedActivities(feedGroup: feedGroup);

      verify(() => mockAggregatedFeed.getPaginatedActivities(
            filter: nextParams.idLT,
            limit: nextParams.limit,
          )).called(1);

      // Make sure all activities in the list are unique.
      final allGroupedActivities = {
        ...groupedActivitiesFirstResult,
        ...groupedActivitiesSecondResult
      }.toList();

      expect(
        bloc.getGroupedActivities(feedGroup),
        allGroupedActivities,
        reason: 'getActivities retrieves the latest activities',
      );
      expect(
        bloc.getGroupedActivitiesStream(feedGroup),
        emits(allGroupedActivities),
        reason: 'stream is updated with the latest activities',
      );
      expect(
        bloc.paginatedParamsGroupedActivites(feedGroup: feedGroup),
        null,
        reason: 'paginated params are null',
      );
    });
  });

  group('Follows', () {
    test('isFollowingUser', () async {
      when(() => mockClient.flatFeed('timeline')).thenReturn(mockFeed);
      when(() => mockFeed.following(
            limit: 1,
            offset: 0,
            filter: [
              FeedId.id('user:2'),
            ],
          )).thenAnswer((_) async => following);

      final isFollowing = await bloc.isFollowingFeed(followerId: '2');
      expect(isFollowing, false);
    });

    test('followFlatFeed', () async {
      when(() => mockClient.flatFeed('timeline')).thenReturn(mockFeed);
      when(() => mockClient.flatFeed('user', '2')).thenReturn(mockSecondFeed);
      when(() => mockFeed.follow(mockSecondFeed))
          .thenAnswer((_) => Future.value());

      await bloc.followFeed(followeeId: '2');
      verify(() => mockFeed.follow(mockSecondFeed)).called(1);
    });

    test('unfollowFlatFeed', () async {
      when(() => mockClient.flatFeed('timeline')).thenReturn(mockFeed);
      when(() => mockClient.flatFeed('user', '2')).thenReturn(mockSecondFeed);
      when(() => mockFeed.unfollow(mockSecondFeed))
          .thenAnswer((_) => Future.value());

      await bloc.unfollowFeed(unfolloweeId: '2');
      verify(() => mockFeed.unfollow(mockSecondFeed)).called(1);
    });
  });
}
