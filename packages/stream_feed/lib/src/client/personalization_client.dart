import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

class PersonalizationClient {
  const PersonalizationClient(
    this._personalization, {
    this.userToken,
    this.secret,
  }) : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        );

  final Token? userToken;
  final String? secret;
  final PersonalizationAPI _personalization;

  Future<Map> get(
    String resource, {
    Map<String, Object>? params,
  }) {
    final token = userToken ??
        TokenHelper.buildPersonalizationToken(secret!, TokenAction.read);
    return _personalization.get(token, resource, params);
  }

  //------------------------- Server side methods ----------------------------//
  Future<void> post(
    String resource,
    Map<String, Object> params, {
    Map<String, Object>? payload,
  }) {
    checkNotNull(secret, "You can't use this method client side");
    final token =
        TokenHelper.buildPersonalizationToken(secret!, TokenAction.write);
    return _personalization.post(token, resource, params, payload);
  }

  Future<void> delete(
    String resource, {
    Map<String, Object>? params,
  }) {
    checkNotNull(secret, "You can't use this method client side");
    final token =
        TokenHelper.buildPersonalizationToken(secret!, TokenAction.delete);
    return _personalization.delete(token, resource, params);
  }
}
