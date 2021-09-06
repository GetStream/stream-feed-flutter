import 'package:equatable/equatable.dart';
import 'package:stream_feed/src/core/api/users_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/index.dart' show User;
import 'package:stream_feed/src/core/util/enrichment.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template user}
/// Stream allows you to store user information
/// and embed them inside activities or use them for personalization.
///
/// When stored in activities, users are automatically enriched by Stream.
/// {@endtemplate}
class StreamUser with EquatableMixin {
  /// Initializes a [UsersClient] session object
  StreamUser(
    this._users,
    this.id, {
    Token? userToken,
    String? secret,
  })  : _secret = secret,
        _userToken = userToken;

  /// User id
  final String id;

  /// {@template jwt}
  /// User JWT
  /// {@endtemplate}
  final Token? _userToken;

  /// The users client
  final UsersAPI _users;

  /// You API secret
  final String? _secret;

  /// Create a stream user ref
  String get ref => createUserReference(id);

  Map<String, Object?>? _data;

  /// User additional data.
  Map<String, Object?>? get data => _data;

  DateTime? _createdAt;

  /// When the user was created.
  DateTime? get createdAt => _createdAt;

  DateTime? _updatedAt;

  /// When the user was last updated.
  DateTime? get updatedAt => _updatedAt;

  int? _followersCount;

  /// Number of users that follow this user.
  int? get followersCount => _followersCount;

  int? _followingCount;

  /// Number of users this user is following.
  int? get followingCount => _followingCount;

  void _enrichUser(User user) {
    _data = user.data;
    _createdAt = user.createdAt;
    _updatedAt = user.updatedAt;
    _followersCount = user.followersCount;
    _followingCount = user.followingCount;
  }

  /// Create a new user in stream
  ///
  /// # Usage
  ///
  /// ```dart
  /// await user('john-doe').create( {
  ///   'name': 'John Doe',
  ///   'occupation': 'Software Engineer',
  ///   'gender': 'male',
  /// });
  /// ```
  /// API docs: [adding-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#adding-users)
  Future<StreamUser> create(
    Map<String, Object?> data, {
    bool getOrCreate = false,
  }) async {
    final token =
        _userToken ?? TokenHelper.buildUsersToken(_secret!, TokenAction.write);
    final user = await _users.create(token, id, data, getOrCreate: getOrCreate);
    _enrichUser(user);
    return this;
  }

  /// Get or Create a new user in stream
  Future<StreamUser> getOrCreate(Map<String, Object?> data) =>
      create(data, getOrCreate: true);

  /// Delete the user
  ///
  /// # Usage:
  /// ```dart
  /// await user('123').delete();
  /// ```
  /// API docs: [removing-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#removing-users)
  Future<void> delete() {
    final token =
        _userToken ?? TokenHelper.buildUsersToken(_secret!, TokenAction.delete);
    return _users.delete(token, id);
  }

  /// Get the user profile, it includes the follow counts by default
  Future<StreamUser> profile({bool withFollowCounts = true}) =>
      get(withFollowCounts: withFollowCounts);

  /// Get the user data
  ///
  /// # Usage
  /// ```dart
  /// await user('123').get();
  /// ```
  /// API docs: [retrieving-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#retrieving-users)
  Future<StreamUser> get({
    bool withFollowCounts = false,
  }) async {
    final token =
        _userToken ?? TokenHelper.buildUsersToken(_secret!, TokenAction.read);
    final user =
        await _users.get(token, id, withFollowCounts: withFollowCounts);
    _enrichUser(user);
    return this;
  }

  /// Update the user
  ///
  /// # Usage:
  /// ```dart
  ///   await user('123').update({
  ///    'name': 'Jane Doe',
  ///    'occupation': 'Software Engineer',
  ///    'gender': 'female',
  ///  });
  /// ```
  /// API docs: [updating-users](https://getstream.io/activity-feeds/docs/flutter-dart/users_introduction/?language=dart#updating-users)
  Future<StreamUser> update(Map<String, Object?> data) async {
    final token =
        _userToken ?? TokenHelper.buildUsersToken(_secret!, TokenAction.write);
    final user = await _users.update(token, id, data);
    _enrichUser(user);
    return this;
  }

  @override
  List<Object?> get props => [id, createdAt];
}
