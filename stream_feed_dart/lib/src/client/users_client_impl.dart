import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class UsersClientImpl implements UsersClient {
  final String secret;
  final UsersApi users;

  const UsersClientImpl(this.secret, this.users);

  @override
  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool getOrCreate,
  }) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.write);
    return users.add(token, id, data, getOrCreate ?? false);
  }

  @override
  Future<void> delete(String id) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.delete);
    return users.delete(token, id);
  }

  @override
  Future<User> get(
    String id, {
    bool withFollowCounts,
  }) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.read);
    return users.get(token, id, withFollowCounts ?? true);
  }

  @override
  Future<User> update(String id, Map<String, Object> data) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.write);
    return users.update(token, id, data);
  }
}
