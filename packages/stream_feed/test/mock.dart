import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';
import 'package:stream_feed_dart/src/core/api/stream_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';

class MockHttpClient extends Mock implements StreamHttpClient {}

class MockCollectionsApi extends Mock implements CollectionsApi {}

class MockFilesApi extends Mock implements FilesApi {}

class MockReactionsApi extends Mock implements ReactionsApi {}

class MockImagesApi extends Mock implements ImagesApi {}

class MockUsersApi extends Mock implements UsersApi {}

class MockFeedApi extends Mock implements FeedApi {}

class MockApi extends Mock implements StreamApi {}
