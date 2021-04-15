import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  Response successResponse(String path) => Response(
        requestOptions: RequestOptions(path: path),
        statusCode: 200,
      );

  group('StreamHttpClient', () {
    const apiKey = 'dummyKey';
    final mockDio = MockDio();
    final client = StreamHttpClient(apiKey, dio: mockDio);

    test('`enrichUrl` should return an enriched url', () {
      const serviceName = 'api';
      const baseUrl = 'https://api.stream-io-api.com/api/v1.0/collections';

      const options = StreamHttpClientOptions(
        urlOverride: {serviceName: baseUrl},
      );
      final clientWithOptions = StreamHttpClient(apiKey, options: options);

      const relativeUrl = 'collections';

      final enriched = clientWithOptions.enrichUrl(relativeUrl, serviceName);
      expect(enriched, '$baseUrl/$relativeUrl');
    });

    test('get', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      final enriched = client.enrichUrl(relativePath, serviceName);
      when(() => mockDio.get(
            enriched,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.get(relativePath, serviceName: serviceName);

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.get(
            enriched,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('post', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.post(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.post(
        relativePath,
        data: data,
        serviceName: serviceName,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.post(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('delete', () async {
      const relativePath = 'collections';
      const serviceName = 'api';

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.delete(
            enriched,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.delete(relativePath, serviceName: serviceName);

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.delete(
            enriched,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          )).called(1);
    });

    test('patch', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.patch(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.patch(
        relativePath,
        data: data,
        serviceName: serviceName,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.patch(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('put', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.put(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.put(
        relativePath,
        data: data,
        serviceName: serviceName,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.put(
            enriched,
            data: data,
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('postFile', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      final file = MultipartFile.fromBytes([]);

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.post(
            enriched,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.postFile(
        relativePath,
        file,
        serviceName: serviceName,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.post(
            enriched,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });
  });
}
