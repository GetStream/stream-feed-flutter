import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';

abstract class UsersApi {
  Future<User> add(
    Token token,
    String id,
    Map<String, Object> data, [
    bool getOrCreate = false,
  ]);

  Future<User> get(Token token, String id, [bool withFollowCounts = true]);

  Future<User> update(Token token, String id, Map<String, Object> data);

  Future<void> delete(Token token, String id);

  String ref(String id);
}
