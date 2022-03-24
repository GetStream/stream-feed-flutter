import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:stream_feed/stream_feed.dart';
import 'package:test/test.dart';

import 'matcher.dart';
import 'mock.dart';
import 'utils.dart';

void main() {
  final mockClient = MockHttpClient();
  final filesApi = FilesAPI(mockClient);

  setUpAll(() {
    registerFallbackValue(MultipartFileFake());
  });

  group('Files API', () {
    test('RefreshUrl', () async {
      const token = Token('dummyToken');
      const targetUrl = 'targetUrl';
      when(() => mockClient.post(
            Routes.filesUrl,
            data: {'url': targetUrl},
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {'url': targetUrl},
          requestOptions: RequestOptions(
            path: Routes.filesUrl,
          ),
          statusCode: 200));

      await filesApi.refreshUrl(token, targetUrl);
      verify(() => mockClient.post(
            Routes.filesUrl,
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
            Routes.filesUrl,
            any(that: isSameMultipartFileAs(multipartFile)),
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
            data: {'file': fileUrl},
            requestOptions: RequestOptions(
              path: Routes.filesUrl,
            ),
            statusCode: 200,
          ));

      final res = await filesApi.upload(token, attachmentFile);
      expect(res, fileUrl);

      verify(() => mockClient.postFile<Map>(
            Routes.filesUrl,
            any(that: isSameMultipartFileAs(multipartFile)),
            headers: {'Authorization': '$token'},
          )).called(1);
    });

    test('Delete', () async {
      const token = Token('dummyToken');

      const targetUrl = 'fileUrl';

      when(() => mockClient.delete(
            Routes.filesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {'url': targetUrl},
          )).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: Routes.filesUrl,
          ),
          statusCode: 200));

      await filesApi.delete(token, targetUrl);

      verify(() => mockClient.delete(
            Routes.filesUrl,
            headers: {'Authorization': '$token'},
            queryParameters: {'url': targetUrl},
          )).called(1);
    });
  });
}
