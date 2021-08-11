import 'package:stream_feed/src/core/api/batch_api.dart';
import 'package:stream_feed/src/core/api/collections_api.dart';
import 'package:stream_feed/src/core/api/feed_api.dart';
import 'package:stream_feed/src/core/api/files_api.dart';
import 'package:stream_feed/src/core/api/images_api.dart';
import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/api/reactions_api.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/open_graph_data.dart';

/// Umbrella interface for all of our http layer apis
abstract class StreamAPI {
  /// Getter for [BatchAPI]
  BatchAPI get batch;

  /// Getter for [ReactionsAPI]
  ReactionsAPI get reactions;

  /// Getter for [UsersAPI]
  UsersAPI get users;

  /// Getter for [CollectionsAPI]
  CollectionsAPI get collections;

  /// Getter for [FeedAPI]
  FeedAPI get feed;

  /// Getter for [FilesAPI]
  FilesAPI get files;

  /// Getter for [ImagesAPI]
  ImagesAPI get images;

  /// Getter for [PersonalizationAPI].
  PersonalizationAPI get personalization;

  /// Getter for [OpenGraphData].
  Future<OpenGraphData> openGraph(Token token, String targetUrl);
}
