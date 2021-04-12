import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/collections_client.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';

class MockHttpClient extends Mock implements StreamHttpClient {}

class MockCollectionsClient extends Mock implements CollectionsClient {}
