import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:jose/jose.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

/// Actions permissions
enum TokenAction {
  /// allows any operations
  any,

  /// allows read operations
  read,

  /// allows write operations
  write,

  /// allows delete operations
  delete,
}

extension TokenActionX on TokenAction {
  String get action => {
        TokenAction.any: '*',
        TokenAction.read: 'read',
        TokenAction.write: 'write',
        TokenAction.delete: 'delete',
      }[this];
}

/// Resource Access Restrictions
enum TokenResource {
  /// allows access to any resource
  any,

  /// allows access to [Activity] resource
  activities,

  /// allows access to analytics resource
  analytics,

  /// allows access to analyticsRedirect resource
  analyticsRedirect,

  /// allows access to [CollectionEntry] resource
  collections,

  /// allows access to files resource
  files,

  /// allows access to [Feed] resource
  feed,

  /// allows access to feedTargets resource
  feedTargets,

  /// allows access to [Follow] resource
  follower,

  /// allows access to [OpenGraph] resource
  openGraph,

  /// token resource that allows access to personalization resource
  personalization,

  /// token resource that allows access to [Reaction] resource
  reactions,

  /// token resource that allows access to [User] resource
  users,
}

/// Convenient class Extension to on [TokenResource] enum
extension TokenResourceX on TokenResource {
  /// Convenient method Extension to stringify the [TokenResource] enum
  String get resource => {
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
        TokenResource.personalization: 'ppersonalization',
        TokenResource.reactions: 'reactions',
        TokenResource.users: 'users',
      }[this];
}

class TokenHelper {
  const TokenHelper._();

  static Token buildFeedToken(
    String secret,
    TokenAction action, [
    FeedId feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.feed, action, feed?.claim ?? '*');

  static Token buildFollowToken(
    String secret,
    TokenAction action, [
    FeedId feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.follower, action, feed?.claim ?? '*');

  static Token buildReactionToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.reactions, action, '*');

  static Token buildActivityToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.activities, action, '*');

  static Token buildUsersToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.users, action, '*');

  static Token buildCollectionsToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.collections, action, '*');

  static Token buildOpenGraphToken(String secret) => _buildBackendToken(
      secret, TokenResource.openGraph, TokenAction.read, '*');

  static Token buildToTargetUpdateToken(
    String secret,
    TokenAction action, [
    FeedId feed,
  ]) =>
      _buildBackendToken(
          secret, TokenResource.feedTargets, action, feed?.claim ?? '*');

  static Token buildFilesToken(String secret, TokenAction action) =>
      _buildBackendToken(secret, TokenResource.files, action, '*');

  static Token buildFrontendToken(
    String secret,
    String userId, {
    DateTime expiresAt,
  }) {
    final claims = <String, Object>{
      'user_id': userId,
    };
    // final claimSet = JwtClaim(otherClaims: claims, expiry: expiresAt);

    return Token(
        issueJwtHS256(secret: secret, expiresAt: expiresAt, claims: claims));
  }

  /// Creates the JWT token for [feedId], [resource] and [action]
  /// using the api [secret]
  static Token _buildBackendToken(
    String secret,
    TokenResource resource,
    TokenAction action,
    String feedId, {
    String userId,
  }) {
    final claims = <String, Object>{
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

String issueJwtHS256(
    {String secret, DateTime expiresAt, Map<String, Object> claims}) {
  final claimSet = JsonWebTokenClaims.fromJson({
    'exp': DateTime.now()
            .add(const Duration(seconds: 1200))
            .millisecondsSinceEpoch ~/
        1000,
    'iat': DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
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

String base64Urlencode(String secret) {
  Codec<String, String> stringToBase64Url = utf8.fuse(base64Url);
  String encoded = stringToBase64Url.encode(secret);
  return encoded;
}
