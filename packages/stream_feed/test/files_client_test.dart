import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/file_storage_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  group('FileStorageClient', () {
    final api = MockFilesApi();
    const token = Token('dummyToken');
    final client = FileStorageClient(api, userToken: token);
    test('upload', () async {
      final multipartFile = MultipartFile(Stream.value([]), 2);
      when(() => api.upload(token, multipartFile))
          .thenAnswer((invocation) async => 'whatever');

      expect(await client.upload(multipartFile), 'whatever');
      verify(() => api.upload(token, multipartFile)).called(1);
    });

    // test('delete', () async {
    //   const targetUrl = 'targetUrl';
    //   when(() => api.delete(token, targetUrl)).thenAnswer((_) async => Response(
    //       data: {},
    //       requestOptions: RequestOptions(
    //         path: '',
    //       ),
    //       statusCode: 200));
    //   await client.delete('url');
    //   verify(() => api.delete(token, targetUrl)).called(1);
    // });
  });
}
