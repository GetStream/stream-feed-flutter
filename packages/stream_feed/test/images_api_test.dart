import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/api/images_api_impl.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  final MockHttpClient mockClient = MockHttpClient();
  final ImagesApiImpl imagesApi = ImagesApiImpl(mockClient);

  group('Images API', () {
    test('Upload', () async {
      const token = Token('dummyToken');

      final multipartFile = MultipartFile.fromString('file');

      when(mockClient.postFile<Map>(
        Routes.imagesUrl,
        multipartFile,
        headers: {'Authorization': '$token'},
      )).thenAnswer((_) async => Response(data: {'file': ''}, statusCode: 200));

      await imagesApi.upload(token, multipartFile);
      verify(mockClient.postFile<Map>(
        Routes.imagesUrl,
        multipartFile,
        headers: {'Authorization': '$token'},
      )).called(1);
    });

    test('Delete', () async {
      const token = Token('dummyToken');

      const targetUrl = 'fileUrl';
      when(mockClient.delete(
        Routes.imagesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      )).thenAnswer((_) async => Response(data: {}, statusCode: 200));

      await imagesApi.delete(token, targetUrl);

      verify(mockClient.delete(
        Routes.imagesUrl,
        headers: {'Authorization': '$token'},
        queryParameters: {'url': targetUrl},
      )).called(1);
    });
  });
}
