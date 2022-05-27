import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/util/default.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

Future<void> main() async {
  group('Reactions API', () {
    final mockClient = MockHttpClient();
    final reactionsApi = ReactionsAPI(mockClient);

    test('Filter', () async {
      const token = Token('dummyToken');

      const lookupAttr = LookupAttribute.activityId;
      const lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
      final filter =
          Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      const limit = Default.limit;
      const kind = 'like';
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
      when(() => mockClient.get<Map>(
            Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).thenAnswer((_) async => Response(
              data: {
                'results': [jsonFixture('reaction.json')]
              },
              requestOptions: RequestOptions(
                path: Routes.buildReactionsUrl(
                    '${lookupAttr.attr}/$lookupValue/$kind'),
              ),
              statusCode: 200));

      await reactionsApi.filter(
        token,
        lookupAttr,
        lookupValue,
        filter,
        limit,
        kind,
        options,
      );

      verify(() => mockClient.get<Map>(
            Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
            headers: {'Authorization': '$token'},
            queryParameters: options,
          )).called(1);
    });

    test('Add', () async {
      const token = Token('dummyToken');

      final targetFeedIds = [
        FeedId('global', 'feed1'),
        FeedId('global', 'feed2')
      ];

      const kind = 'like';
      const activityId = 'commentId';
      const userId = 'john-doe';
      final data = {'text': 'awesome post!'};
      const reactionId = 'reactionId';
      final reaction = Reaction(
        id: reactionId,
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeedIds,
      );
      when(() => mockClient.post<Map<String, dynamic>>(
            Routes.buildReactionsUrl(),
            headers: {'Authorization': '$token'},
            data: reaction,
          )).thenAnswer((_) async => Response(
          data: jsonFixture('reaction.json'),
          requestOptions: RequestOptions(
            path: Routes.buildReactionsUrl(),
          ),
          statusCode: 200));

      await reactionsApi.add(token, reaction);

      verify(() => mockClient.post<Map<String, dynamic>>(
            Routes.buildReactionsUrl(),
            headers: {'Authorization': '$token'},
            data: reaction,
          )).called(1);
    });

    test('Get', () async {
      const token = Token('dummyToken');

      const id = 'id';
      when(() => mockClient.get<Map<String, dynamic>>(
            Routes.buildReactionsUrl('$id/'),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
          data: jsonFixture('reaction.json'),
          requestOptions: RequestOptions(
            path: Routes.buildReactionsUrl('$id/'),
          ),
          statusCode: 200));

      await reactionsApi.get(token, id);

      verify(() => mockClient.get<Map<String, dynamic>>(
            Routes.buildReactionsUrl('$id/'),
            headers: {'Authorization': '$token'},
          )).called(1);
    });
    test('Delete', () async {
      const token = Token('dummyToken');

      const id = 'id';
      when(() => mockClient.delete(
            Routes.buildReactionsUrl('$id/'),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.buildReactionsUrl('$id/'),
          ),
          statusCode: 200));

      await reactionsApi.delete(token, id);

      verify(() => mockClient.delete(
            Routes.buildReactionsUrl('$id/'),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('PaginatedFilter', () async {
      const token = Token('dummyToken');

      const lookupAttr = LookupAttribute.activityId;
      const lookupValue = 'ed2837a6-0a3b-4679-adc1-778a1704852d';
      final filter =
          Filter().idLessThan('e561de8f-00f1-11e4-b400-0cc47a024be0');
      const EnrichmentFlags? flags = null;
      const limit = Default.limit;
      const kind = 'like';
      when(() => mockClient.get(
            Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'limit': limit.toString(),
              ...filter.params,
              'with_activity_data': lookupAttr == LookupAttribute.activityId,
            },
          )).thenAnswer((_) async => Response(
          data: jsonFixture('paginated_reactions.json'),
          requestOptions: RequestOptions(
            path: Routes.buildReactionsUrl(
                '${lookupAttr.attr}/$lookupValue/$kind'),
          ),
          statusCode: 200));

      await reactionsApi.paginatedFilter(
        token,
        lookupAttr,
        lookupValue,
        filter,
        flags,
        limit,
        kind,
      );

      verify(() => mockClient.get(
            Routes.buildReactionsUrl('${lookupAttr.attr}/$lookupValue/$kind'),
            headers: {'Authorization': '$token'},
            queryParameters: {
              'limit': limit.toString(),
              ...filter.params,
              'with_activity_data': lookupAttr == LookupAttribute.activityId,
            },
          )).called(1);
    });
    test('NextPaginatedFilter', () async {
      const token = Token('dummyToken');

      const next = 'next';
      when(() => mockClient.get(
            next,
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: jsonFixture('paginated_reactions.json'),
          requestOptions: RequestOptions(
            path: next,
          ),
          statusCode: 200));

      await reactionsApi.nextPaginatedFilter(token, next);

      verify(() => mockClient.get(
            next,
            headers: {'Authorization': '$token'},
          )).called(1);
    });
    test('Update', () async {
      const token = Token('dummyToken');

      final targetFeedIds = [
        FeedId('global', 'feed1'),
        FeedId('global', 'feed2')
      ];

      const kind = 'like';
      const activityId = 'commentId';
      const userId = 'john-doe';
      final data = {'text': 'awesome post!'};
      const reactionId = 'reactionId';
      final updatedReaction = Reaction(
        id: reactionId,
        kind: kind,
        activityId: activityId,
        userId: userId,
        data: data,
        targetFeeds: targetFeedIds,
      );

      when(() => mockClient.put<Map<String, dynamic>>(
            Routes.buildReactionsUrl('$reactionId/'),
            headers: {'Authorization': '$token'},
            data: {
              'data': data,
              'target_feeds': targetFeedIds.map((e) => e.toString()).toList()
            },
          )).thenAnswer((_) async => Response<Map<String, dynamic>>(
          data: jsonFixture('reaction.json'),
          requestOptions: RequestOptions(
            path: Routes.buildReactionsUrl('$reactionId/'),
          ),
          statusCode: 200));

      await reactionsApi.update(token, updatedReaction);

      verify(() => mockClient.put<Map<String, dynamic>>(
            Routes.buildReactionsUrl('$reactionId/'),
            headers: {'Authorization': '$token'},
            data: {
              'data': data,
              'target_feeds': targetFeedIds.map((e) => e.toString()).toList()
            },
          )).called(1);
    });
  });
}
