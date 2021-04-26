import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('FileStorageClient', () {
    final api = MockFilesAPI();
    const token = Token('dummyToken');
    final client = FileStorageClient(api, userToken: token);
    test('upload', () async {
      final multipartFile = MultipartFile(Stream.value([]), 2);
      when(() => api.upload(token, multipartFile))
          .thenAnswer((invocation) async => 'whatever');

      expect(await client.upload(multipartFile), 'whatever');
      verify(() => api.upload(token, multipartFile)).called(1);
    });

    test('refreshUrl', () async {
      const targetUrl = 'targetUrl';

      when(() => api.refreshUrl(token, targetUrl))
          .thenAnswer((invocation) async => targetUrl);

      expect(await client.refreshUrl(targetUrl), targetUrl);
      verify(() => api.refreshUrl(token, targetUrl)).called(1);
    });

    test('delete', () async {
      const targetUrl = 'targetUrl';
      when(() => api.delete(token, targetUrl)).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: '',
          ),
          statusCode: 200));
      await client.delete(targetUrl);
      verify(() => api.delete(token, targetUrl)).called(1);
    });
  });
}
