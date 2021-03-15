import 'package:stream_feed_dart/src/core/index.dart';

abstract class CloudUsersClient {
  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool? getOrCreate,
  });

  Future<User> get(
    String id, {
    bool? withFollowCounts,
  });

  Future<User> update(String id, Map<String, Object> data);

  Future<void> delete(String id);
}
