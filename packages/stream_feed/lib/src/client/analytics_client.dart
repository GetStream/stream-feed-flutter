import 'package:stream_feed/src/core/api/analytics_api.dart';
import 'package:stream_feed/src/core/http/stream_http_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/event.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template analytics}
/// Send out analytic events to the Stream service.
/// We recommend tracking every event for each user. This allows you to
/// gain a better understanding of that user's interests.
/// Common examples include:
/// - Clicking on a link
/// - Liking or commenting
/// - Sharing an activity
/// - Viewing another user's profile page
/// - Searching for a certain user/content/topic/etc.
/// {@endtemplate}
class StreamAnalytics {
  /// [StreamAnalytics] constructor:
  ///
  /// {@macro analytics}
  StreamAnalytics(
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
  /// i.e. a user is viewing a page.
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
  Future<void> trackImpression(Impression impression) =>
      trackImpressions([impression]);

  /// Send [Impression]s events
  Future<void> trackImpressions(List<Impression> impressions) async {
    final impressionDataList = _validateAndNormalizeUserData(impressions);
    final token =
        userToken ?? TokenHelper.buildAnalytics(secret!, TokenAction.write);
    await _analytics.trackImpressions(token, impressionDataList);
  }

  /// Send [Engagegement] event
  /// i.e. a user is interacting with a content item.
  /// ```dart
  /// final analytics = AnalyticsClient(apiKey,
  ///     userToken: token);
  /// await analytics.trackEngagement(Engagement(
  ///     content: {"foreign_id": "tweet:34349698"},
  ///     label: "click",
  ///     userData: UserData("test", "test"),
  ///     feedId: FeedId("user", "thierry")));
  /// ```
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
