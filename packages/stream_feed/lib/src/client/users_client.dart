import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class UsersClient {
  const UsersClient(this.users, {this.userToken, this.secret});
  final Token? userToken;
  final UsersApi users;
  final String? secret;

  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool? getOrCreate,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret, TokenAction.write);
    return users.add(token, id, data, getOrCreate ?? false);
  }

  Future<void> delete(String id) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret, TokenAction.delete);
    return users.delete(token, id);
  }

  Future<User> get(
    String id, {
    bool? withFollowCounts,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret, TokenAction.read);
    return users.get(token, id, withFollowCounts ?? true);
  }

  Future<User> update(String id, Map<String, Object> data) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret, TokenAction.write);
    return users.update(token, id, data);
  }
}
