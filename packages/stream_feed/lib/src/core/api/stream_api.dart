import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/open_graph_data.dart';

import 'package:stream_feed/src/core/api/batch_api.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';

///Umbrella interface for all of our http layer apis
abstract class StreamApi {
  /// getter for [BatchApi]
  BatchApi get batch;

  /// getter for [ReactionsApi]
  ReactionsApi get reactions;

  /// getter for [UsersApi]
  UsersApi get users;

  /// getter for [CollectionsApi]
  CollectionsApi get collections;

  /// getter for [FeedApi]
  FeedApi get feed;

  /// getter for [FilesApi]
  FilesApi get files;

  /// getter for [ImagesApi]
  ImagesApi get images;

  PersonalizationApi get personalization;

  /// retrieve for [OpenGraphData]
  Future<OpenGraphData> openGraph(Token token, String targetUrl);
}
