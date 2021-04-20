import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/api/analytics_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

class MockDio extends Mock implements Dio {
  BaseOptions? _options;

  @override
  BaseOptions get options => _options ??= BaseOptions();

  Interceptors? _interceptors;

  @override
  Interceptors get interceptors => _interceptors ??= Interceptors();
}

class MockHttpClient extends Mock implements StreamHttpClient {}

class MockAnalyticsApi extends Mock implements AnalyticsApi {}

class MockCollectionsApi extends Mock implements CollectionsApi {}

class MockFilesApi extends Mock implements FilesApi {}

class MockReactionsApi extends Mock implements ReactionsApi {}

class MockImagesApi extends Mock implements ImagesApi {}

class MockUsersApi extends Mock implements UsersApi {}

class MockFeedAPI extends Mock implements FeedAPI {}

class MockApi extends Mock implements StreamApi {}

class Functions {
  WebSocketChannel? connectFunc(
    String url, {
    Iterable<String>? protocols,
    Duration? connectionTimeout,
  }) =>
      null;

// void handleFunc(Event event) => null;
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

class MockWSSink extends Mock implements WebSocketSink {}
