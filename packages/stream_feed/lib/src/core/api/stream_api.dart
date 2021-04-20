import 'package:stream_feed_dart/src/core/api/personalization_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/open_graph_data.dart';

import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/feed_api.dart';
import 'package:stream_feed_dart/src/core/api/files_api.dart';
import 'package:stream_feed_dart/src/core/api/images_api.dart';
import 'package:stream_feed_dart/src/core/api/reactions_api.dart';

///Umbrella interface for all of our http layer apis
abstract class StreamAPI {
  /// getter for [BatchAPI]
  BatchAPI get batch;

  /// getter for [ReactionsAPI]
  ReactionsAPI get reactions;

  /// getter for [UsersAPI]
  UsersAPI get users;

  /// getter for [CollectionsAPI]
  CollectionsAPI get collections;

  /// getter for [FeedAPI]
  FeedAPI get feed;

  /// getter for [FilesAPI]
  FilesAPI get files;

  /// getter for [ImagesAPI]
  ImagesAPI get images;

  PersonalizationAPI get personalization;

  /// retrieve for [OpenGraphData]
  Future<OpenGraphData> openGraph(Token token, String targetUrl);
}
