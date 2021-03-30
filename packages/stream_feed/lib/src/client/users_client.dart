import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/api/users_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class UsersClient {
  ///Initialize a user session object
  const UsersClient(this.users, {this.userToken, this.secret});

  ///User JWT token
  final Token? userToken;
  final UsersApi users;
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
  Future<User> add(
    String id,
    Map<String, Object> data, {
    bool? getOrCreate,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return users.add(token, id, data, getOrCreate ?? false);
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
    return users.delete(token, id);
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
    return users.get(token, id, withFollowCounts ?? true);
  }

  /// Update the user
  /// Usage:
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
    return users.update(token, id, data);
  }
}
