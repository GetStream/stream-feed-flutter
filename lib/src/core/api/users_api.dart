import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';

abstract class UsersApi {
  Future<User> add(Token token, User user, [bool getOrCreate = false]);

  Future<User> get(Token token, String id, [bool withFollowCounts = true]);

  Future<User> update(Token token, User updatedUser);

  Future<void> delete(Token token, String id);

  String ref(String id);
}
