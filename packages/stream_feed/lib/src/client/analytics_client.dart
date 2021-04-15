import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/analytics_api.dart';
import 'package:stream_feed_dart/src/core/http/stream_http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/event.dart';

/// Send out analytic events to the Stream service.
class AnalyticsClient {
  ///
  AnalyticsClient(
    String apiKey,
    Token token, {
    AnalyticsApi? analytics,
    StreamHttpClientOptions? options,
  }) : _analytics = analytics ?? AnalyticsApi(apiKey, token, options: options);

  final AnalyticsApi _analytics;

  ///
  UserData? userData;
  //TODO: get user?

  /// Set user id and alias
  void setUser({required String id, required String alias}) =>
      userData = UserData(id, alias);

  List<T> _validateAndNormalizeUserData<T extends Event>(List<T> events) =>
      events.map((e) {
        if (e.userData != null || userData != null) {
          return e.copyWith(userData: e.userData ?? userData) as T;
        }
        throw Exception(
          'UserData should be in each event or '
          'set the default with AnalyticsClient.setUser()',
        );
      }).toList(growable: false);

  /// Send a new [Impression] event.
  Future<Response> trackImpression(Impression impression) =>
      trackImpressions([impression]);

  /// Send [Impression]s events
  Future<Response> trackImpressions(List<Impression> impressions) {
    final impressionDataList = _validateAndNormalizeUserData(impressions);
    return _analytics.trackImpressions(impressionDataList);
  }

  /// Send [Engagegement] event
  Future<Response> trackEngagement(Engagement engagement) =>
      trackEngagements([engagement]);

  /// Send [Engagegement]s event
  Future<Response> trackEngagements(List<Engagement> engagements) {
    final engagementDataList = _validateAndNormalizeUserData(engagements);
    return _analytics.trackEngagements(engagementDataList);
  }
}
