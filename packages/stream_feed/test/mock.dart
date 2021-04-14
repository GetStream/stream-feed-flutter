import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/api/analytics_api.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';

class MockHttpClient extends Mock implements StreamHttpClient {}

class MockAnalyticsApi extends Mock implements AnalyticsApi {}
