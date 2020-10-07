import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class UsersApiImpl implements UsersApi {
  final HttpClient client;

  const UsersApiImpl(this.client);

  @override
  Future<User> add(Token token, User user, [bool getOrCreate = false]) async {
    final result = await client.post(
      Routes.buildUsersUrl(),
      headers: {'Authorization': '$token'},
      queryParameters: {'get_or_create': getOrCreate},
      data: user,
    );
    print(result);
  }

  @override
  Future<User> get(Token token, String id,
      [bool withFollowCounts = true]) async {
    final result = await client.get(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
      queryParameters: {'with_follow_counts': withFollowCounts},
    );
    print(result);
  }

  @override
  Future<User> update(Token token, User updatedUser) async {
    final result = await client.put(
      Routes.buildUsersUrl('${updatedUser.id}/'),
      headers: {'Authorization': '$token'},
      data: updatedUser,
    );
    print(result);
  }

  @override
  Future<void> delete(Token token, String id) async {
    final result = await client.delete(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
    print(result);
  }

  @override
  String ref(String id) => 'SU:$id';
}
