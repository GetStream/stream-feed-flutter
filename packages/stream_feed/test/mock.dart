import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/core/api/analytics_api.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/api/stream_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';

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

class MockAnalyticsAPI extends Mock implements AnalyticsAPI {}

class MockCollectionsAPI extends Mock implements CollectionsAPI {}

class MockFilesAPI extends Mock implements FilesAPI {}

class MockReactionsAPI extends Mock implements ReactionsAPI {}

class MockImagesAPI extends Mock implements ImagesAPI {}

class MockUserAPI extends Mock implements UsersAPI {}

class MockFeedAPI extends Mock implements FeedAPI {}

class MockAPI extends Mock implements StreamAPI {}

class MultipartFileFake extends Fake implements MultipartFile {}
