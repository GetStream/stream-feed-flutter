import 'package:stream_feed_dart/src/core/models/user.dart';

abstract class UsersClient {
  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool getOrCreate,
  });

  Future<User> get(
    String id, {
    bool withFollowCounts,
  });

  Future<User> update(String id, Map<String, Object> data);

  Future<void> delete(String id);

  String ref(String id);
}
