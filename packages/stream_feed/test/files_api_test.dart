import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/api/files_api_impl.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  final MockHttpClient mockClient = MockHttpClient();
  final FilesApiImpl filesApi = FilesApiImpl(mockClient);

  group('Files API', () {
    test('Upload', () async {
      const token = Token('dummyToken');

      final multipartFile = MultipartFile.fromString('file');

      when(mockClient.postFile<Map>(
        Routes.filesUrl,
        multipartFile,
        headers: {'Authorization': '$token'},
      )).thenAnswer((_) async => Response(data: {'file': ''}, statusCode: 200));

      await filesApi.upload(token, multipartFile);
      verify(mockClient.postFile<Map>(
        Routes.filesUrl,
        multipartFile,
        headers: {'Authorization': '$token'},
      )).called(1);
    });
  });
}
