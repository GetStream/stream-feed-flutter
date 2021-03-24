import 'package:stream_feed_dart/src/core/api/personalization.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';

class PersonalizationClient {
  ///Initialize a Personalization client
  const PersonalizationClient(this.personalization,
      {this.userToken, this.secret});
  final Token? userToken;

  final PersonalizationApi personalization;

  /// Your API secret. You can get it in your Stream Dashboard [here](https://dashboard.getstream.io/dashboard/v2/)
  final String? secret;

  Future<Map> get(
      String userID, String resource, Map<String, Object> params) async {
    final token = userToken ??
        TokenHelper.buildPersonalizationToken(secret, TokenAction.read);
    return personalization.get(token, userID, resource, params);
  }

// Server side methods
  Future<void> post(Token token, String userID, String resource,
      Map<String, Object> params, Map<String, Object> payload) async {
    final token =
        TokenHelper.buildPersonalizationToken(secret, TokenAction.write);
    return personalization.post(token, userID, resource, params, payload);
  }

  Future<void> delete(Token token, String userID, String resource,
      Map<String, Object> params) async {
    final token =
        TokenHelper.buildPersonalizationToken(secret, TokenAction.write);
    return personalization.delete(token, userID, resource, params);
  }
}
