import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/api/images_api_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  final mockClient = MockHttpClient();
  final imagesApi = ImagesApiImpl(mockClient);

  group('Images API', () {
    test('Upload', () async {
      const token = Token('dummyToken');

      final multipartFile = MultipartFile.fromString('file');

      when(() => mockClient.postFile<Map>(
            Routes.imagesUrl,
            multipartFile,
            headers: {'Authorization': '$token'},
          )).thenAnswer((_) async => Response(
          data: {'file': ''},
          requestOptions: RequestOptions(
            path: Routes.imagesUrl,
          ),
          statusCode: 200));

      await imagesApi.upload(token, multipartFile);
      verify(() => mockClient.postFile<Map>(
            Routes.imagesUrl,
            multipartFile,
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
