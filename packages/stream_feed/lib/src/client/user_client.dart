import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:stream_feed/stream_feed.dart';

/// Stream allows you to store user information
/// and embed them inside activities or use them for personalization.
///
/// When stored in activities, users are automatically enriched by Stream.
class UserClient {
  ///Initialize a [UsersClient] session object
  const UserClient(this._user, this.userId, {this.userToken, this.secret});

  ///User JWT token
  final Token? userToken;

  ///User id
  final String userId;

  ///The users client
  final UsersAPI _user;

  /// You API secret
  final String? secret;

  String get ref => createUserReference(userId);

  /// Create a new user in stream
  ///
  /// Usage
  ///
  /// ```dart
  /// await user('john-doe').add( {
  ///   'name': 'John Doe',
  ///   'occupation': 'Software Engineer',
  ///   'gender': 'male',
  /// });
  /// ```
  /// API docs: [adding-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#adding-users)
  Future<User> create(
    Map<String, Object> data, {
    bool? getOrCreate,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _user.add(token, userId, data, getOrCreate ?? false);
  }

  ///Get or Create a new user in stream
  Future<User> getOrCreate(Map<String, Object> data) =>
      create(data, getOrCreate: true);

  /// Delete the user
  /// Usage:
  ///```dart
  ///await user('123').delete();
  ///```
  ///API docs: [removing-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#removing-users)
  Future<void> delete() {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.delete);
    return _user.delete(token, userId);
  }

  ///  Get the user profile, it includes the follow counts by default
  Future<User> profile({bool withFollowCounts = true}) =>
      get(withFollowCounts: withFollowCounts);

  /// Get the user data
  /// Usage
  /// ```dart
  /// await user('123').get();
  /// ```
  /// API docs: [retrieving-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#retrieving-users)
  Future<User> get({
    bool? withFollowCounts = false,
  }) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.read);
    return _user.get(token, userId, withFollowCounts!);
  }

  /// Update the user
  /// # Usage:
  /// ```dart
  ///   await user('123').update({
  ///    'name': 'Jane Doe',
  ///    'occupation': 'Software Engineer',
  ///    'gender': 'female',
  ///  });
  /// ```
  /// API docs: [updating-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#updating-users)
  Future<User> update(Map<String, Object> data) {
    final token =
        userToken ?? TokenHelper.buildUsersToken(secret!, TokenAction.write);
    return _user.update(token, userId, data);
  }
}
