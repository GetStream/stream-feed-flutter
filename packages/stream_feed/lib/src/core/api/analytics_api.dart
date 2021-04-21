import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/event.dart';
import 'package:stream_feed/src/core/util/extension.dart';

///
class AnalyticsApi {
  ///
  AnalyticsApi(
    String apiKey,
    this._token, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  final Token _token;
  final StreamHttpClient _client;

  ///
  Future<Response> trackImpressions(List<Impression> impressions) {
    for (final impression in impressions) {
      checkNotNull(impression.userData, 'Missing UserData');
    }
    return _client.post(
      'impression',
      serviceName: 'analytics',
      headers: {'Authorization': '$_token'},
      data: json.encode(impressions),
    );
  }

  ///
  Future<Response> trackEngagements(List<Engagement> engagements) {
    for (final engagement in engagements) {
      checkNotNull(engagement.userData, 'Missing UserData');
    }
    return _client.post(
      'engagement',
      serviceName: 'analytics',
      headers: {'Authorization': '$_token'},
      data: json.encode({'content_list': engagements}),
    );
  }
}
