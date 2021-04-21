import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/routes.dart';

/// The http layer api for CRUD operation on Users
class UsersApi {
  /// [UsersApi] constructor
  const UsersApi(this._client);

  final StreamHttpClient _client;

  /// Create a new user
  Future<User> add(
    Token token,
    String id,
    Map<String, Object> data, [
    bool getOrCreate = false,
  ]) async {
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final user = User(id: id, data: data);
    final result = await _client.post<Map>(
      Routes.buildUsersUrl(),
      headers: {'Authorization': '$token'},
      queryParameters: {'get_or_create': getOrCreate},
      data: user,
    );
    return User.fromJson(result.data as Map<String, dynamic>);
  }

  /// Get the user data
  Future<User> get(Token token, String id,
      [bool withFollowCounts = true]) async {
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final result = await _client.get(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
      queryParameters: {'with_follow_counts': withFollowCounts},
    );
    return User.fromJson(result.data);
  }

  ///Update the user
  Future<User> update(Token token, String id, Map<String, Object> data) async {
    checkArgument(id.isNotEmpty, 'Missing user ID');
    final updatedUser = User(id: id, data: data);
    final result = await _client.put(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
      data: updatedUser,
    );
    return User.fromJson(result.data);
  }

  ///Delete the user
  Future<void> delete(Token token, String id) {
    checkArgument(id.isNotEmpty, 'Missing user ID');
    return _client.delete(
      Routes.buildUsersUrl('$id/'),
      headers: {'Authorization': '$token'},
    );
  }
}
