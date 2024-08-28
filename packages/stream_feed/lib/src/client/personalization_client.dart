import 'package:stream_feed/src/core/api/personalization_api.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';

/// {@template personalization}
/// Allows for personalizing a feed to the user's preference.
///
/// Personalization is a powerful feature. It enables you to leverage machine
/// learning to optimize what's shown in the feed.
///
/// The 5 most common use cases are:
// ignore: doc_directive_unknown
/// {@image <image alt='' src='https://getstream.imgix.net/images/docs/personalization5cases@2x.png?cs=strip&auto=format,compress?auto=compress,auto&fit=clip&h=600&w=800'>}
///
/// Famous examples of discovery feeds are Instagram's explore section
/// and Pinterest's main feed. Edge rank is used by Facebook and LinkedIn.
///
/// Stream uses 3 data sources for personalization:
/// 1. Feeds & Follows
/// The best way to understand how feeds and follows work is
/// to try our 5-minute interactive tutorial.
/// 2. Analytics
///
/// The purpose of analytics is to track which activities a user is looking at
///  and what they are engaging with. Basically, you want to track everything
/// that indicates a user's interest in something.
/// Common examples include:
/// -  Clicking on a link
/// -  Likes or comments
/// -  Sharing an activity
/// -  Viewing another user's profile page
/// -  Search terms
///
/// The events and data you want to track are often different
/// than what you traditionally track in Google Analytics or Mixpanel.
/// Stream's analytics is designed to run alongside
/// your existing analytics solution.
///
/// 3. Collections
/// Collections enable you to sync information to Stream
/// that's not captured by analytics or feeds. Common examples
/// include user profiles and product information.
/// {@endtemplate}
class PersonalizationClient {
  ///{@macro personalization}
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

  /// {@template personalizationGet}
  /// Reads the personalized feed for a given user
  ///
  /// Our data science team will typically tell you which endpoint to use
  /// {@endtemplate}
  Future<Map> get(
    String resource, {
    Map<String, dynamic>? params,
  }) {
    final token = userToken ??
        TokenHelper.buildPersonalizationToken(secret!, TokenAction.any,
            userId: '*');
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
