import 'package:stream_feed_dart/src/cloud/cloud_users_client.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';

class CloudUsersClientImpl implements CloudUsersClient {
  const CloudUsersClientImpl(this.token, this.users);
  final Token token;
  final UsersApi users;

  @override
  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool? getOrCreate,
  }) =>
      users.add(token, id, data, getOrCreate ?? false);

  @override
  Future<void> delete(String id) => users.delete(token, id);

  @override
  Future<User> get(
    String id, {
    bool? withFollowCounts,
  }) =>
      users.get(token, id, withFollowCounts ?? true);

  @override
  Future<User> update(String id, Map<String, Object> data) =>
      users.update(token, id, data);
}
