import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/analytics_api.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  const apiKey = 'dummyKey';
  const token = Token('dummyToken');
  final httpClient = MockHttpClient();

  group('trackImpressions', () {
    final api = AnalyticsAPI(apiKey, client: httpClient);
    final impression = Impression(
      contentList: [
        Content(
          foreignId: FeedId.fromId('post:42'),
          data: const {
            'actor': {'id': 'user:2353540'},
            'verb': 'share',
            'object': {'id': 'song:34349698'},
          },
        ),
      ],
      feedId: FeedId('timeline', 'tom'),
    );
    test('should throw if userData is not present', () {
      expect(
        () => api.trackImpressions(token, [impression]),
        throwsArgumentError,
      );
    });

    test(
      'should successfully upload impressions if userData is present',
      () async {
        const userData = UserData('testUserId', 'testAlias');
        final updatedImpression = impression.copyWith(userData: userData);

        when(() => httpClient.post(
              'impression',
              serviceName: 'analytics',
              headers: {'Authorization': '$token'},
              data: json.encode([updatedImpression]),
            )).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        final res = await api.trackImpressions(token, [updatedImpression]);

        expect(res, isNotNull);
        expect(res.statusCode, 200);

        verify(() => httpClient.post(
              'impression',
              serviceName: 'analytics',
              headers: {'Authorization': '$token'},
              data: json.encode([updatedImpression]),
            )).called(1);
      },
    );
  });

  group('trackEngagements', () {
    final api = AnalyticsAPI(apiKey, client: httpClient);
    final engagement = Engagement(
      content: Content(foreignId: FeedId.fromId('tweet:34349698')),
      label: 'click',
      score: 2,
      position: 3,
      feedId: FeedId('user', 'thierry'),
      location: 'profile_page',
    );
    test('should throw if userData is not present', () {
      expect(
        () => api.trackEngagements(token, [engagement]),
        throwsArgumentError,
      );
    });

    test(
      'should successfully upload engagements if userData is present',
      () async {
        const userData = UserData('testUserId', 'testAlias');
        final updatedEngagement = engagement.copyWith(userData: userData);

        when(() => httpClient.post(
              'engagement',
              serviceName: 'analytics',
              headers: {'Authorization': '$token'},
              data: json.encode({
                'content_list': [updatedEngagement]
              }),
            )).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            statusCode: 200,
          ),
        );

        final res = await api.trackEngagements(token, [updatedEngagement]);

        expect(res, isNotNull);
        expect(res.statusCode, 200);

        verify(() => httpClient.post(
              'engagement',
              serviceName: 'analytics',
              headers: {'Authorization': '$token'},
              data: json.encode({
                'content_list': [updatedEngagement]
              }),
            )).called(1);
      },
    );
  });
}
