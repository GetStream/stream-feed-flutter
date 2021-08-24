import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/extension.dart';

/// {@macro personalization}
class PersonalizationAPI {
  /// Builds a [PersonalizationAPI].
  const PersonalizationAPI(this.client);

  final StreamHttpClient client;

  /// {@macro personalizationGet}
  Future<Map> get(
    Token token,
    String resource,
    Map<String, Object?>? params,
  ) async {
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    if (params != null) checkArgument(params.isNotEmpty, 'Missing params');
    final result = await client.get(
      resource,
      serviceName: 'personalization',
      queryParameters: params,
      headers: {'Authorization': '$token'},
    );
    return result.data;
  }

  Future<Response> post(
    Token token,
    String resource,
    Map<String, Object?> params,
    Map<String, Object?>? payload,
  ) async {
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    checkArgument(params.isNotEmpty, 'Missing params');
    if (payload != null) checkArgument(payload.isNotEmpty, 'Missing payload');
    return client.post(
      resource,
      serviceName: 'personalization',
      queryParameters: params,
      data: json.encode(payload),
      headers: {'Authorization': '$token'},
    );
  }

  Future<Response> delete(
    Token token,
    String resource,
    Map<String, Object?>? params,
  ) {
    checkArgument(resource.isNotEmpty, "Resource can't be empty");
    if (params != null) checkArgument(params.isNotEmpty, 'Missing params');
    return client.delete(
      resource,
      serviceName: 'personalization',
      queryParameters: params,
      headers: {'Authorization': '$token'},
    );
  }
}
