import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/models/event.dart';
import 'package:stream_feed_dart/src/core/util/extension.dart';

class AnalyticsApi {
  const AnalyticsApi(this.client);

  final StreamHttpClient client;

  ///
  Future<Response> trackImpressions(List<Impression> impressions) {
    for (final impression in impressions) {
      checkNotNull(impression.userData, 'Missing UserData');
    }
    return client.post(
      'impression',
      serviceName: 'analytics',
      data: json.encode(impressions),
    );
  }

  ///
  Future<Response> trackEngagements(List<Engagement> engagements) {
    for (final engagement in engagements) {
      checkNotNull(engagement.userData, 'Missing UserData');
    }
    return client.post(
      'engagement',
      serviceName: 'analytics',
      data: json.encode({'content_list': engagements}),
    );
  }
}
