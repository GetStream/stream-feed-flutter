import 'package:dio/dio.dart';
import 'package:stream_feed/src/core/api/analytics_api.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/event.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// Send out analytic events to the Stream service.
class AnalyticsClient {
  /// [AnalyticsClient] constructor
  AnalyticsClient(
    String apiKey, {
    this.secret,
    this.userToken,
    AnalyticsAPI? analytics,
    StreamHttpClientOptions? options,
  })  : assert(
          userToken != null || secret != null,
          'At least a secret or userToken must be provided',
        ),
        _analytics = analytics ?? AnalyticsAPI(apiKey, options: options);

  final AnalyticsAPI _analytics;
  final String? secret;
  final Token? userToken;

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
  /// ```dart
  ///  final analytics = AnalyticsClient(apiKey, secret: secret);
  /// await analytics.trackImpression(Impression(
  ///     contentList: [
  ///       {"foreign_id": "tweet:34349698"}
  ///     ],
  ///     userData: UserData("test", "test"),
  ///     feedId: FeedId("flat", "tommaso"),
  ///     location: "profile_page");
  /// ```
  Future<Response> trackImpression(Impression impression) =>
      trackImpressions([impression]);

  /// Send [Impression]s events
  Future<Response> trackImpressions(List<Impression> impressions) {
    final impressionDataList = _validateAndNormalizeUserData(impressions);
    final token =
        userToken ?? TokenHelper.buildAnalytics(secret!, TokenAction.write);
    return _analytics.trackImpressions(token, impressionDataList);
  }

  /// Send [Engagegement] event
  Future<void> trackEngagement(Engagement engagement) =>
      trackEngagements([engagement]);

  /// Send [Engagegement]s event
  Future<void> trackEngagements(List<Engagement> engagements) {
    final engagementDataList = _validateAndNormalizeUserData(engagements);
    final token =
        userToken ?? TokenHelper.buildAnalytics(secret!, TokenAction.write);
    return _analytics.trackEngagements(token, engagementDataList);
  }
}
