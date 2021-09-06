import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/image_storage_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:stream_feed/src/core/models/crop.dart';
import 'package:stream_feed/src/core/models/resize.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('ImagesStorageClient', () {
    final api = MockImagesAPI();
    const token = Token('dummyToken');
    final client = ImageStorageClient(api, userToken: token);

    test('get', () async {
      const url = 'url';
      when(() => api.get(token, url))
          .thenAnswer((invocation) async => 'whatever');

      expect(await client.get(url), 'whatever');
      verify(() => api.get(token, url)).called(1);
    });

    test('getCropped', () async {
      const url = 'url';
      const crop = Crop(50, 50);
      when(() => api.get(token, url, options: crop.params))
          .thenAnswer((invocation) async => 'whatever');

      expect(await client.getCropped(url, crop), 'whatever');
      verify(() => api.get(token, url, options: crop.params)).called(1);
    });

    test('getResized', () async {
      const url = 'url';
      const resize = Resize(50, 50);
      when(() => api.get(token, url, options: resize.params))
          .thenAnswer((invocation) async => 'whatever');

      expect(await client.getResized(url, resize), 'whatever');
      verify(() => api.get(token, url, options: resize.params)).called(1);
    });

    test('refreshUrl', () async {
      const targetUrl = 'targetUrl';

      when(() => api.refreshUrl(token, targetUrl))
          .thenAnswer((invocation) async => targetUrl);

      expect(await client.refreshUrl(targetUrl), targetUrl);
      verify(() => api.refreshUrl(token, targetUrl)).called(1);
    });

    test('upload', () async {
      final attachment = AttachmentFile(path: 'dummyPath');

      const fileUrl = 'dummyFileUrl';
      when(() => api.upload(token, attachment))
          .thenAnswer((_) async => fileUrl);

      final res = await client.upload(attachment);
      expect(res, fileUrl);

      verify(() => api.upload(token, attachment)).called(1);
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
