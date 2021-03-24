import 'dart:convert';

import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';

class PersonalizationApi {
  const PersonalizationApi(this.client);

  final HttpClient client;

//TODO: for some reason userID is never used in the java client

  Future<Map> get(Token token, String userID, String resource,
      Map<String, Object> params) async {
    checkNotNull(resource, "Resource can't be empty");
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    checkNotNull(params, "Missing params");
    final result = await client.get(
      Routes.buildPersonalizationURL(resource),
      headers: {'Authorization': '$token'},
      queryParameters: params,
    );
    return result.data;
  }

  Future<void> post(Token token, String userID, String resource,
      Map<String, Object> params, Map<String, Object> payload) async {
    checkNotNull(resource, "Resource can't be empty");
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    checkNotNull(params, "Missing params");
    checkNotNull(params, "Missing payload");
    await client.post(Routes.buildPersonalizationURL(resource),
        headers: {'Authorization': '$token'},
        queryParameters: params,
        data: json.encode(payload));
  }

  Future<void> delete(Token token, String userID, String resource,
      Map<String, Object> params) async {
    checkNotNull(resource, "Resource can't be empty");
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    checkNotNull(params, "Missing params");
    await client.delete(
      Routes.buildPersonalizationURL(resource),
      headers: {'Authorization': '$token'},
      queryParameters: params,
    );
  }
}
