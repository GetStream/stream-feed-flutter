import 'package:stream_feed_dart/src/core/api/analytics_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';

import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';

abstract class StreamApi {
  BatchApi get batch;

  ReactionsApi get reactions;

  UsersApi get users;

  CollectionsApi get collections;

  FeedApi get feed;

  FilesApi get files;

  ImagesApi get images;

  AnalyticsApi get analytics;

  Future<OpenGraphData> openGraph(Token token, String targetUrl);
}
