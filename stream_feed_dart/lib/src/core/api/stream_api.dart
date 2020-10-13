import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';

import 'batch_api.dart';
import 'collections_api.dart';
import 'feed_api.dart';
import 'files_api.dart';
import 'images_api.dart';
import 'reactions_api.dart';
import 'users_api.dart';

abstract class StreamApi {
  BatchApi get batch;

  ReactionsApi get reactions;

  UsersApi get users;

  CollectionsApi get collections;

  FeedApi get feed;

  FilesApi get files;

  ImagesApi get images;

  Future<OpenGraphData> openGraph(Token token, String targetUrl);
}
