import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';

class UserClientImpl implements UsersClient {
  @override
  Future<User> add(String userId, Map<String, Object> data,
      {bool getOrCreate = false}) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<User> get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<User> update(String id, Map<String, Object> data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
