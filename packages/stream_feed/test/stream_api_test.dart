import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/stream_api_impl.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'mock.dart';
import 'utils.dart';

void main() {
  test('streamApi', () async {
    final mockClient = MockHttpClient();

    final streamApi = StreamApiImpl('apiKey', client: mockClient);
    expect(streamApi.collections, isNotNull);
    expect(streamApi.batch, isNotNull);
    expect(streamApi.feed, isNotNull);
    expect(streamApi.files, isNotNull);
    expect(streamApi.images, isNotNull);
    expect(streamApi.reactions, isNotNull);
    expect(streamApi.users, isNotNull);
    expect(streamApi.personalization, isNotNull);
    const token = Token('token');
    const targetUrl = 'targetUrl';
    when(() => mockClient.get(
          Routes.openGraphUrl,
          headers: {'Authorization': '$token'},
          queryParameters: {'url': targetUrl},
        )).thenAnswer((_) async => Response(
        data: jsonFixture('open_graph_data.json'),
        requestOptions: RequestOptions(
          path: Routes.openGraphUrl,
        ),
        statusCode: 200));

    await streamApi.openGraph(token, targetUrl);
    verify(() => mockClient.get(
          Routes.openGraphUrl,
          headers: {'Authorization': '$token'},
          queryParameters: {'url': targetUrl},
        )).called(1);
  });
}
