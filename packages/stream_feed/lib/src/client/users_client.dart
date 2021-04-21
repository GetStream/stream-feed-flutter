import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Stream allows you to store user information
/// and embed them inside activities or use them for personalization.
///
/// When stored in activities, users are automatically enriched by Stream.
class UsersClient {
  ///Initialize a [UsersClient] session object
  const UsersClient(this._users, {this.userToken, this.secret, this.userId});

  ///User JWT token
  final Token? userToken;

  ///User id
  final String? userId;

  ///The users client
  final UsersApi _users;

  /// You API secret
  final String? secret;

  /// Create a new user in stream
  ///
  /// Usage
  ///
  /// ```dart
  /// await users.add('john-doe', {
  ///   'name': 'John Doe',
  ///   'occupation': 'Software Engineer',
  ///   'gender': 'male',
  /// });
  /// ```
  /// API docs: [adding-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#adding-users)
  Future<User> create(
    String id,
    Map<String, Object> data, {
    bool? getOrCreate,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _users.add(token, id, data, getOrCreate ?? false);
  }

  /// Delete the user
  /// Usage:
  ///```dart
  ///await users.delete('123');
  ///```
  ///API docs: [removing-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#removing-users)
  Future<void> delete(String id) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.delete);
    return _users.delete(token, id);
  }

  ///  Get the user profile, it includes the follow counts by default
  Future<User> profile({bool withFollowCounts = true}) async {
    checkNotNull(userId, 'userId is not defined');
    return get(userId!, withFollowCounts: withFollowCounts);
  }

  /// Get the user data
  /// Usage
  /// ```dart
  /// await users.get('123');
  /// ```
  /// API docs: [retrieving-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#retrieving-users)
  Future<User> get(
    String id, {
    bool? withFollowCounts,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.read);
    return _users.get(token, id, withFollowCounts ?? true);
  }

  /// Update the user
  /// # Usage:
  /// ```dart
  ///   await users.update('123', {
  ///    'name': 'Jane Doe',
  ///    'occupation': 'Software Engineer',
  ///    'gender': 'female',
  ///  });
  /// ```
  /// API docs: [updating-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#updating-users)
  Future<User> update(String id, Map<String, Object> data) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _users.update(token, id, data);
  }
}
