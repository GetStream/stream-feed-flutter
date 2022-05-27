import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('ReactionsClient', () {
    final api = MockReactionsAPI();
    const userId = 'john-doe';
    final dummyResponse = Response(
      data: {},
      requestOptions: RequestOptions(
        path: '',
      ),
      statusCode: 200,
    );

    const token = Token('dummyToken');
    final client = ReactionsClient(api, userToken: token);
    test('add', () async {
      const kind = 'like';
      const activityId = 'activityId';

      const targetFeeds = <FeedId>[];
      const data = {'text': 'awesome post!'};
      const reaction = Reaction(
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeeds,
      );
      when(() => api.add(token, reaction)).thenAnswer((_) async => reaction);

      final result = await client.add(
        kind,
        activityId,
        data: data,
        userId: userId,
        targetFeeds: targetFeeds,
      );
      expect(result, reaction);
      verify(() => api.add(token, reaction)).called(1);
    });

    test('get', () async {
      const id = 'id';

      const reaction = Reaction(id: id);
      when(() => api.get(token, id)).thenAnswer((_) async => reaction);

      expect(await client.get(id), reaction);
      verify(() => api.get(token, id)).called(1);
    });

    test('update', () async {
      const reactionId = 'reactionId';
      const targetFeeds = <FeedId>[];
      const data = {'text': 'modified post'};
      const updatedReaction = Reaction(
        id: reactionId,
        data: data,
        targetFeeds: targetFeeds,
      );

      when(() => api.update(token, updatedReaction))
          .thenAnswer((_) async => updatedReaction);
      await client.update(reactionId, data: data, targetFeeds: targetFeeds);
      verify(() => api.update(token, updatedReaction)).called(1);
    });

    test('delete', () async {
      const id = 'id';
      when(() => api.delete(token, id)).thenAnswer((_) async => dummyResponse);
      await client.delete(id);
      verify(() => api.delete(token, id)).called(1);
    });

    test('filter', () async {
      const lookupAttr = LookupAttribute.activityId;
      const lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      const kind = 'like';
      const limit = 5;
      const activityId = 'activityId';
      const userId = 'john-doe';
      const targetFeeds = <FeedId>[];
      const data = {'text': 'awesome post!'};
      const reactions = [
        Reaction(
          kind: kind,
          activityId: activityId,
          userId: userId,
          data: data,
          targetFeeds: targetFeeds,
        )
      ];
      final flags = EnrichmentFlags()
          .withReactionCounts()
          .withOwnChildren()
          .withOwnReactions();
      final options = {
        'limit': limit,
        ...filter.params,
        ...flags.params,
        'with_activity_data': lookupAttr == LookupAttribute.activityId,
      };
      when(() => api.filter(
              token, lookupAttr, lookupValue, filter, limit, kind, options))
          .thenAnswer((_) async => reactions);
      await client.filter(lookupAttr, lookupValue,
          filter: filter, limit: limit, kind: kind, flags: flags);
      verify(() => api.filter(
              token, lookupAttr, lookupValue, filter, limit, kind, options))
          .called(1);
    });

    test('addChild', () async {
      const kind = 'like';
      const userId = 'john-doe';
      const parentId = 'parentId';
      const targetFeeds = <FeedId>[];
      const data = {'text': 'awesome post!'};
      const reaction = Reaction(
        kind: kind,
        parent: parentId,
        userId: userId,
        data: data,
        targetFeeds: targetFeeds,
      );
      when(() => api.add(token, reaction)).thenAnswer((_) async => reaction);

      expect(
          await client.addChild(kind, parentId,
              userId: userId, data: data, targetFeeds: targetFeeds),
          reaction);
      verify(() => api.add(token, reaction)).called(1);
    });

    test('paginatedReactions', () async {
      const lookupAttr = LookupAttribute.activityId;
      const lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
      final filter =
          Filter().idGreaterThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      const EnrichmentFlags? flags = null;
      const kind = 'like';
      const limit = 5;
      const activityId = 'activityId';
      const userId = 'john-doe';
      const targetFeeds = <FeedId>[];
      const data = {'text': 'awesome post!'};
      const reactions = [
        Reaction(
          kind: kind,
          activityId: activityId,
          userId: userId,
          data: data,
          targetFeeds: targetFeeds,
        )
      ];
      final duration = const Duration(minutes: 2).toString();
      final paginatedReactions = PaginatedReactions(
          next: 'next',
          results: reactions,
          activity: const GenericEnrichedActivity(),
          duration: duration);
      when(() => api.paginatedFilter(
            token,
            lookupAttr,
            lookupValue,
            filter,
            flags,
            limit,
            kind,
          )).thenAnswer(
        (_) async => paginatedReactions,
      );
      await client.paginatedFilter(
        lookupAttr,
        lookupValue,
        filter: filter,
        limit: limit,
        kind: kind,
      );
      verify(() => api.paginatedFilter(
            token,
            lookupAttr,
            lookupValue,
            filter,
            flags,
            limit,
            kind,
          )).called(1);
    });
  });
}
