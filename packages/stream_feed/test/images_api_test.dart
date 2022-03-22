import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'matcher.dart';
import 'mock.dart';
import 'utils.dart';

void main() {
  final mockClient = MockHttpClient();
  final imagesApi = ImagesAPI(mockClient);

  setUpAll(() {
    registerFallbackValue(MultipartFileFake());
  });

  group('Images API', () {
    test('RefreshUrl', () async {
      const token = Token('dummyToken');
      const targetUrl = 'targetUrl';
      when(() => mockClient.post(
            Routes.imagesUrl,
            data: {'url': targetUrl},
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {'url': targetUrl},
          requestOptions: RequestOptions(
            path: Routes.imagesUrl,
          ),
          statusCode: 200));

      await imagesApi.refreshUrl(token, targetUrl);
      verify(() => mockClient.post(
            Routes.imagesUrl,
            data: {'url': targetUrl},
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('Upload', () async {
      const token = Token('dummyToken');

      final file = assetFile('test_image.jpeg');
      final attachmentFile = AttachmentFile(
        path: file.path,
        bytes: file.readAsBytesSync(),
      );
      final multipartFile = await attachmentFile.toMultipartFile();

      const fileUrl = 'dummyFileUrl';
      when(() => mockClient.postFile<Map>(
            Routes.imagesUrl,
            any(that: isSameMultipartFileAs(multipartFile)),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
            data: {'file': fileUrl},
            requestOptions: RequestOptions(
              path: Routes.imagesUrl,
            ),
            statusCode: 200,
          ));

      final res = await imagesApi.upload(token, attachmentFile);
      expect(res, fileUrl);

      verify(() => mockClient.postFile<Map>(
            Routes.imagesUrl,
            any(that: isSameMultipartFileAs(multipartFile)),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('Delete', () async {
      const token = Token('dummyToken');

      const targetUrl = 'fileUrl';
      when(() => mockClient.delete(
            Routes.imagesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {'url': targetUrl},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.imagesUrl,
          ),
          statusCode: 200));

      await imagesApi.delete(token, targetUrl);

      verify(() => mockClient.delete(
            Routes.imagesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {'url': targetUrl},
          )).called(1);
    });

    test('Get', () async {
      const token = Token('dummyToken');

      const targetUrl = 'fileUrl';
      when(() => mockClient.get(
            Routes.imagesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {
              'url': targetUrl,
              // if (options != null) ...options,
            },
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.imagesUrl,
          ),
          statusCode: 200));

      await imagesApi.get(token, targetUrl);

      verify(() => mockClient.get(
            Routes.imagesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {
              'url': targetUrl,
              // if (options != null) ...options,
            }, //TODO: test options
          )).called(1);
    });
  });
}
