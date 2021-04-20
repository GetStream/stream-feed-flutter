import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/models/event.dart';
import 'package:stream_feed_dart/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  const apiKey = 'dummyKey';
  const token = Token('dummyToken');
  final api = MockAnalyticsAPI();

  test('`setUser` should set user successfully', () {
    final client = AnalyticsClient(apiKey, token, analytics: api);
    expect(client.userData, isNull);
    const userId = 'testId';
    const alias = 'testAlias';
    client.setUser(id: userId, alias: alias);
    expect(client.userData, isNotNull);
    expect(client.userData!.id, userId);
    expect(client.userData!.alias, alias);
  });

  group('trackImpression', () {
    final client = AnalyticsClient(apiKey, token, analytics: api);
    final impression = Impression(
      contentList: const [
        {
          'foreign_id': 'post:42',
          'actor': {'id': 'user:2353540'},
          'verb': 'share',
          'object': {'id': 'song:34349698'},
        }
      ],
      feedId: FeedId('timeline', 'tom'),
    );

    test('should throw if userData is not present', () {
      expect(
        () => client.trackImpression(impression),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'should complete without any error if userData is present',
      () async {
        const userData = UserData('testId', 'testAlias');
        final updatedImpression = impression.copyWith(userData: userData);
        when(() => api.trackImpressions([updatedImpression])).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ),
        );

        final resp = await client.trackImpression(updatedImpression);

        expect(resp, isNotNull);
        expect(resp.statusCode, 200);

        verify(() => api.trackImpressions([updatedImpression])).called(1);
      },
    );
  });

  group('trackEngagement', () {
    final client = AnalyticsClient(apiKey, token, analytics: api);
    final engagement = Engagement(
      content: const {'foreign_id': 'tweet:34349698'},
      label: 'click',
      score: 2,
      position: 3,
      feedId: FeedId('user', 'thierry'),
      location: 'profile_page',
    );

    test('should throw if userData is not present', () async {
      expect(
        () => client.trackEngagement(engagement),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'should complete without any error if userData is present',
      () async {
        const userData = UserData('testId', 'testAlias');
        final updatedEngagement = engagement.copyWith(userData: userData);
        when(() => api.trackEngagements([updatedEngagement])).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ),
        );

        final resp = await client.trackEngagement(updatedEngagement);

        expect(resp, isNotNull);
        expect(resp.statusCode, 200);

        verify(() => api.trackEngagements([updatedEngagement])).called(1);
      },
    );
  });
}
