import 'package:stream_feed_dart/src/core/api/batch_api.dart';
import 'package:stream_feed_dart/src/core/api/collections_api.dart';
import 'package:stream_feed_dart/src/core/api/reaction_api.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';

abstract class StreamApi {
  BatchApi get batch;

  ReactionsApi get reaction;

  UsersApi get users;

  CollectionsApi get collections;
}
