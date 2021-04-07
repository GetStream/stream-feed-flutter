import 'package:dio/dio.dart';
import 'package:stream_feed_dart/src/core/api/analytics_api.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/event.dart';

class AnalyticsClient {
  AnalyticsClient(this.analytics, {required this.userToken});

  final Token? userToken;
  final AnalyticsApi analytics;

  UserData? _userData;

  void setUser({required String id, required String alias}) =>
      _userData = UserData(id, alias);

  List<T> _validateAndNormalizeUserData<T extends Event>(List<T> events) =>
      events.map((e) {
        if (e.userData != null || _userData != null) {
          return e.copyWith(userData: e.userData ?? _userData) as T;
        }
        throw Exception(
          'UserData should be in each event or '
          'set the default with AnalyticsClient.setUser()',
        );
      }).toList(growable: false);

  Future<Response> trackImpression(Impression impression) =>
      trackImpressions([impression]);

  Future<Response> trackImpressions(List<Impression> impressions) {
    final impressionDataList = _validateAndNormalizeUserData(impressions);
    return analytics.trackImpressions(impressionDataList);
  }

  Future<Response> trackEngagement(Engagement engagement) =>
      trackEngagements([engagement]);

  Future<Response> trackEngagements(List<Engagement> engagements) {
    final engagementDataList = _validateAndNormalizeUserData(engagements);
    return analytics.trackEngagements(engagementDataList);
  }
}
