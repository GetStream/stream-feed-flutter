import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/activity.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

class MockDioAdapter extends Mock implements HttpClientAdapter {}

class MockDio extends Mock implements Dio {}

class Service {
  final Dio dio;
  Service(this.dio);

  Future<Response> post(String path,
          {dynamic data,
          Map<String, dynamic> queryParameters,
          Options options,
          CancelToken cancelToken,
          void Function(int, int) onSendProgress,
          void Function(int, int) onReceiveProgress}) =>
      dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);

  Future<Response> get(String path,
          {Map<String, dynamic> queryParameters,
          Options options,
          CancelToken cancelToken,
          void Function(int, int) onReceiveProgress}) =>
      dio.get(path,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);
}

Future<void> main() async {
  test('Batch API addToMany', () async {
    final mockDio = MockDio();
    final dioAdapterMock = MockDioAdapter();
    mockDio.httpClientAdapter = dioAdapterMock;
    //uncomment this line then await service.addToMany(token, activity, feedIds); and see the test fails
    // final service = BatchApiImpl(mockDio);
    final service = Service(mockDio);//comment this line

    when(mockDio.post(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              data: '{}',
              statusCode: 200,
              headers: Headers.fromMap({
                Headers.contentTypeHeader: [Headers.jsonContentType],
              }),
            ));
    const activity = Activity(actor: 'matthisk', object: '0', verb: 'tweet');
    final feedIds = <FeedId>[
      FeedId('global', 'feed'),
      FeedId('global', 'feed2'),
    ];
    const token = Token('dummy');
    await service.post( //comment this line
      Routes.addToManyUrl,
      // options: Options(headers: {'Authorization': '$token'}),
      data: json.encode({
        'feeds': feedIds.map((e) => e.toString()).toList(),
        'activity': activity,
      }),
    );

    // uncomment this line
    // await service.addToMany(token, activity, feedIds);

    verify(
      mockDio.post(
        Routes.addToManyUrl,
        // options: Options(headers: {'Authorization': '$token'}),
        data: json.encode({
          'feeds': feedIds.map((e) => e.toString()).toList(),
          'activity': activity,
        }),
      ),
    );
  });
}
