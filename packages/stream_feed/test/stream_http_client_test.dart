import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
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

    group('enrichUrl', () {
      const apiService = 'api';
      const analyticsService = 'analytics';
      const personalizationService = 'personalization';

      const apiBaseUrl = 'https://api.stream-io-api.com/api/v1.0';
      const analyticsBaseUrl =
          'https://analytics.stream-io-api.com/analytics/v1.0';
      const personalizationBaseUrl =
          'https://personalization.stream-io-api.com/personalization/v1.0';

      const options = StreamHttpClientOptions(
        urlOverride: {
          apiService: apiBaseUrl,
          analyticsService: analyticsBaseUrl,
          personalizationService: personalizationBaseUrl,
        },
      );

      final clientWithOptions = StreamHttpClient(apiKey, options: options);

      test('should return an `api` service enriched url', () {
        const relativeUrl = 'collections';
        final enriched = clientWithOptions.enrichUrl(relativeUrl, apiService);
        expect(enriched, '$apiBaseUrl/$relativeUrl');
      });

      test('should return an `analytics` service enriched url', () {
        const relativeUrl = 'impression';
        final enriched = clientWithOptions.enrichUrl(
          relativeUrl,
          analyticsService,
        );
        expect(enriched, '$analyticsBaseUrl/$relativeUrl');
      });

      test('should return an `personalization` service enriched url', () {
        const relativeUrl = 'feeds';
        final enriched = clientWithOptions.enrichUrl(
          relativeUrl,
          personalizationService,
        );
        expect(enriched, '$personalizationBaseUrl/$relativeUrl');
      });
    });

    test('get', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};

      final enriched = client.enrichUrl(relativePath, serviceName);
      when(() => mockDio.get(
            enriched,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.get(
        relativePath,
        serviceName: serviceName,
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.get(
            enriched,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('post', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.post(
            enriched,
            data: data,
            queryParameters: queryParams,
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
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.post(
            enriched,
            data: data,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('delete', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.delete(
            enriched,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer(
        (_) async => successResponse(enriched),
      );

      final res = await client.delete(
        relativePath,
        serviceName: serviceName,
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.delete(
            enriched,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          )).called(1);
    });

    test('patch', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.patch(
            enriched,
            data: data,
            queryParameters: queryParams,
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
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.patch(
            enriched,
            data: data,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('put', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};
      const data = {};

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.put(
            enriched,
            data: data,
            queryParameters: queryParams,
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
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.put(
            enriched,
            data: data,
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });

    test('postFile', () async {
      const relativePath = 'collections';
      const serviceName = 'api';
      const queryParams = {'group': 'unknown'};
      final file = MultipartFile.fromBytes([]);

      final enriched = client.enrichUrl(relativePath, serviceName);

      when(() => mockDio.post(
            enriched,
            data: any(named: 'data'),
            queryParameters: queryParams,
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
        queryParameters: queryParams,
      );

      expect(res, isNotNull);
      expect(res.statusCode, 200);
      expect(res.requestOptions.path, enriched);

      verify(() => mockDio.post(
            enriched,
            data: any(named: 'data'),
            queryParameters: queryParams,
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          )).called(1);
    });
  });
}
