import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/event.dart';
import 'package:stream_feed/src/core/util/extension.dart';

/// Provides methods for tracking data related to activities
class AnalyticsAPI {
  /// Builds an [AnalyticsAPI].
  AnalyticsAPI(
    String apiKey, {
    StreamHttpClient? client,
    StreamHttpClientOptions? options,
  }) : _client = client ?? StreamHttpClient(apiKey, options: options);

  final StreamHttpClient _client;

  /// Tracks the amount of times an Activity has been viewed, and by which
  /// users.
  Future<Response> trackImpressions(Token token, List<Impression> impressions) {
    for (final impression in impressions) {
      checkNotNull(impression.userData, 'Missing UserData');
    }
    return _client.post(
      'impression',
      serviceName: 'analytics',
      headers: {'Authorization': '$token'},
      data: json.encode(impressions),
    );
  }

  /// Tracks the interactions users have had with an Activity.
  Future<Response> trackEngagements(Token token, List<Engagement> engagements) {
    for (final engagement in engagements) {
      checkNotNull(engagement.userData, 'Missing UserData');
    }
    return _client.post(
      'engagement',
      serviceName: 'analytics',
      headers: {'Authorization': '$token'},
      data: json.encode({'content_list': engagements}),
    );
  }
}
