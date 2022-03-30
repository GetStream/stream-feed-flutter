import 'dart:convert';
import 'package:jose/jose.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/feed_id.dart';

/// Actions permissions
enum TokenAction {
  /// Allows any operations
  any,

  /// Allows read operations
  read,

  /// Allows write operations
  write,

  /// Allows delete operations
  delete,
}

extension _TokenActionX on TokenAction {
  String? get action => {
        TokenAction.any: '*',
        TokenAction.read: 'read',
        TokenAction.write: 'write',
        TokenAction.delete: 'delete',
      }[this];
}

/// Resource Access Restrictions
enum TokenResource {
  /// Allows access to any resource
  any,

  /// Allows access to [Activity] resource
  activities,

  /// Allows access to analytics resource
  analytics,

  /// Allows access to analyticsRedirect resource
  analyticsRedirect,

  /// Allows access to [CollectionEntry] resource
  collections,

  /// Allows access to files resource
  files,

  /// Allows access to [Feed] resource
  feed,

  /// Allows access to feedTargets resource
  feedTargets,

  /// Allows access to [Follow] resource
  follower,

  /// Allows access to [OpenGraph] resource
  openGraph,

  /// Token resource that allows access to personalization resource
  personalization,

  /// Token resource that allows access to [Reaction] resource
  reactions,

  /// Token resource that allows access to [User] resource
  users,
}

/// Convenient class Extension to on [TokenResource] enum
extension TokenResourceX on TokenResource {
  /// Convenient method Extension to stringify the [TokenResource] enum
  String? get resource => {
        TokenResource.any: '*',
        TokenResource.activities: 'activities',
        TokenResource.analytics: 'analytics',
        TokenResource.analyticsRedirect: 'redirect_and_track',
        TokenResource.collections: 'collections',
        TokenResource.files: 'files',
        TokenResource.feed: 'feed',
        TokenResource.feedTargets: 'feed_targets',
        TokenResource.follower: 'follower',
        TokenResource.openGraph: 'url',
        TokenResource.personalization: 'personalization',
        TokenResource.reactions: 'reactions',
        TokenResource.users: 'users',
      }[this];
}

/// Class that generates tokens
class TokenHelper {
  /// Constructor for [TokenHelper]
  const TokenHelper();

  /// Build Feed Token
  static Token buildFeedToken(
    String secret,
    TokenAction action, [
    FeedId? feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.feed, action, feed?.claim ?? '*');

  /// Build Feed Token
  static Token buildAnalyticsToken(
    String secret,
    TokenAction action, [
    FeedId? feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.analytics, action, feed?.claim ?? '*');

  /// Build Follow Token
  static Token buildFollowToken(
    String secret,
    TokenAction action, [
    FeedId? feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.follower, action, feed?.claim ?? '*');

  /// Build Personalization Token
  static Token buildAnyToken(String secret, TokenAction action,
          {String? userId}) =>
      _buildBackendToken(secret, TokenResource.any, action, '*',
          userId: userId);

  /// Build Personalization Token
  static Token buildPersonalizationToken(String secret, TokenAction action,
          {String? userId}) =>
      _buildBackendToken(secret, TokenResource.personalization, action, '*',
          userId: userId);

  /// Build Reaction Token
  static Token buildReactionToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.reactions, action, '*');

  /// Build Analytics Token
  static Token buildAnalytics(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.analytics, action, '*');

  /// Build Analytics Redirect Token
  static Token buildAnalyticsRedirect(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.analyticsRedirect, action, '*');

  /// Build Activity Token
  static Token buildActivityToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.activities, action, '*');

  /// Build Users Token
  static Token buildUsersToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.users, action, '*');

  /// Build Collections Token
  static Token buildCollectionsToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.collections, action, '*');

  /// Build Open Graph Token
  static Token buildOpenGraphToken(String secret) => _buildBackendToken(
      secret, TokenResource.openGraph, TokenAction.read, '*');

  /// Build To Target Update Token
  static Token buildToTargetUpdateToken(
    String secret,
    TokenAction action, [
    FeedId? feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.feedTargets, action, feed?.claim ?? '*');

  /// Build Files Token
  static Token buildFilesToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.files, action, '*');

  /// Build Frontend Token
  static Token buildFrontendToken(
    String secret,
    String userId, {
    DateTime? expiresAt,
  }) {
    final claims = <String, Object>{
      'user_id': userId,
    };

    return Token(
        issueJwtHS256(secret: secret, expiresAt: expiresAt, claims: claims));
  }

  /// Creates the JWT for [feedId], [resource] and [action]
  /// using the api [secret]
  static Token _buildBackendToken(
    String secret,
    TokenResource resource,
    TokenAction action,
    String feedId, {
    String? userId,
  }) {
    final claims = <String, Object?>{
      'resource': resource.resource,
      'action': action.action,
      'feed_id': feedId,
    };
    if (userId != null) {
      claims['user_id'] = userId;
    }

    return Token(issueJwtHS256(secret: secret, claims: claims));
  }
}

/// Decode the JWT
JsonWebToken jwtDecode(Token userToken) =>
    JsonWebToken.unverified(userToken.token);

/// Issues a JWT issue signed with HS256
String issueJwtHS256({
  required String secret,
  required Map<String, Object?>? claims,
  DateTime? expiresAt,
}) {
  final claimSet = JsonWebTokenClaims.fromJson({
    if (expiresAt != null) 'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    if (claims != null) ...claims,
  });

  // create a builder, decoding the JWT in a JWS, so using a
  // JsonWebSignatureBuilder
  final builder = JsonWebSignatureBuilder()

    // set the content
    ..jsonContent = claimSet.toJson()

    // add a key to sign, can only add one for JWT
    ..addRecipient(
        JsonWebKey.fromJson({
          'kty': 'oct',
          'k': base64Urlencode(secret),
        }),
        algorithm: 'HS256')
    // builder.recipients
    ..setProtectedHeader('typ', 'JWT');
  // build the jws
  final jws = builder.build();

  // output the compact serialization
  return jws.toCompactSerialization();
}

/// Base64 url encodes a secret
String base64Urlencode(String secret) {
  final Codec<String?, String> stringToBase64Url = utf8.fuse(base64Url);
  final encoded = stringToBase64Url.encode(secret);
  return encoded;
}
