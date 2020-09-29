import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/feed_id.dart';

enum TokenAction {
  any,
  read,
  write,
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

enum TokenResource {
  any,
  activities,
  analytics,
  analytics_redirect,
  collections,
  files,
  feed,
  feed_targets,
  follower,
  open_graph,
  personalization,
  reactions,
  users,
}

extension TokenResourceX on TokenResource {
  String get resource => {
        TokenResource.any: '*',
        TokenResource.activities: 'activities',
        TokenResource.analytics: 'analytics',
        TokenResource.analytics_redirect: 'redirect_and_track',
        TokenResource.collections: 'collections',
        TokenResource.files: 'files',
        TokenResource.feed: 'feed',
        TokenResource.feed_targets: 'feed_targets',
        TokenResource.follower: 'follower',
        TokenResource.open_graph: 'url',
        TokenResource.personalization: 'ppersonalization',
        TokenResource.reactions: 'reactions',
        TokenResource.users: 'users',
      }[this];
}

class TokenHelper {
  static Token buildFeedToken(
    String secret,
    TokenAction action, {
    FeedId feed,
  }) {
    return _buildBackendToken(
        secret, TokenResource.feed, action, feed?.claim ?? '*');
  }

  static Token buildFollowToken(
    String secret,
    TokenAction action, {
    FeedId feed,
  }) {
    return _buildBackendToken(
        secret, TokenResource.follower, action, feed?.claim ?? '*');
  }

  static Token buildReactionToken(String secret, TokenAction action) {
    return _buildBackendToken(secret, TokenResource.reactions, action, '*');
  }

  static Token buildActivityToken(String secret, TokenAction action) {
    return _buildBackendToken(secret, TokenResource.activities, action, '*');
  }

  static Token _buildFrontendToken(
    String secret,
    String userId, {
    DateTime expiresAt,
  }) {
    final claims = <String, Object>{
      'user_id': userId,
    };
    final claimSet = JwtClaim(otherClaims: claims, expiry: expiresAt);
    return Token(issueJwtHS256(claimSet, secret));
  }

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
    final claimSet = JwtClaim(otherClaims: claims);
    return Token(issueJwtHS256(claimSet, secret));
  }
}
