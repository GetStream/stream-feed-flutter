import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class UsersApiImpl implements UsersApi {
  const UsersApiImpl(this.client)
      : assert(client != null, "Can't create a UserApi w/o Client");

  final HttpClient client;

  @override
  Future<User> add(
    Token token,
    String id,
    Map<String, Object> data, [
    bool getOrCreate = false,
  ]) async {
    checkNotNull(id, 'Missing user ID');
    checkNotNull(data, 'Missing user data');
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final user = User(id: id, data: data);
    final result = await client.post<Map>(
      Routes.buildUsersUrl(),
      headers: {'Authorization': '$token'},
      queryParameters: {'get_or_create': getOrCreate},
      data: user,
    );
    return User.fromJson(result.data as Map<String, dynamic>);
  }

  @override
  Future<User> get(Token token, String id,
      [bool withFollowCounts = true]) async {
    checkNotNull(id, 'Missing user ID');
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final result = await client.get(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
      queryParameters: {'with_follow_counts': withFollowCounts},
    );
    return User.fromJson(result.data);
  }

  @override
  Future<User> update(Token token, String id, Map<String, Object> data) async {
    checkNotNull(id, 'Missing user ID');
    checkNotNull(data, 'Missing user data');
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final updatedUser = User(id: id, data: data);
    final result = await client.put(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
      data: updatedUser,
    );
    return User.fromJson(result.data);
  }

  @override
  Future<void> delete(Token token, String id) {
    checkNotNull(id, 'Missing user ID');
    checkArgument(id.isNotEmpty, 'Missing user ID');
    return client.delete(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
  }
}
