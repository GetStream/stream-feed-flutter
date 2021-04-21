import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/routes.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:mocktail/mocktail.dart';

import 'mock.dart';

void main() {
  final mockClient = MockHttpClient();
  final filesApi = FilesApi(mockClient);

  group('Files API', () {
    test('Upload', () async {
      const token = Token('dummyToken');

      final multipartFile = MultipartFile.fromString('file');

      when(() => mockClient.postFile<Map>(
            Routes.filesUrl,
            multipartFile,
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {'file': ''},
          requestOptions: RequestOptions(
            path: Routes.filesUrl,
          ),
          statusCode: 200));

      await filesApi.upload(token, multipartFile);
      verify(() => mockClient.postFile<Map>(
            Routes.filesUrl,
            multipartFile,
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
