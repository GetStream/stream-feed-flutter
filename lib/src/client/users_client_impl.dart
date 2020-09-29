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
    bool getOrCreate = false,
  }) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.write);
    final user = User(id: id, data: data);
    return users.add(token, user, getOrCreate);
  }

  @override
  Future<void> delete(String id) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.delete);
    return users.delete(token, id);
  }

  @override
  Future<User> get(
    String id, {
    bool withFollowCounts = true,
  }) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.read);
    return users.get(token, id, withFollowCounts);
  }

  @override
  String ref(String id) => users.ref(id);

  @override
  Future<User> update(String id, Map<String, Object> data) {
    final token = TokenHelper.buildUsersToken(secret, TokenAction.write);
    final user = User(id: id, data: data);
    return users.update(token, user);
  }
}
