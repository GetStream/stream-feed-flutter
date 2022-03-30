import 'package:jose/jose.dart';
import 'package:stream_feed/src/core/util/token_helper.dart';
import 'package:test/test.dart';
// ignore: directives_ordering
import 'dart:convert';

void main() {
  group('TokenHelper', () {
    const secret =
        // ignore: lines_longer_than_80_chars
        'secret';

    // create key store to verify the signature
    final keyStore = JsonWebKeyStore()
      ..addKey(
          JsonWebKey.fromJson({'kty': 'oct', 'k': base64Urlencode(secret)}));

    test('buildFrontendToken', () async {
      final expiresAt = DateTime(2021, 03, 08);

      final frontendToken = TokenHelper.buildFrontendToken(secret, 'userId',
          expiresAt: expiresAt);
      final jwt = JsonWebToken.unverified(frontendToken.token);
      expect(jwt.claims.getTyped('user_id'), 'userId');
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = frontendToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);

      expect(
        payloadJson,
        {'exp': isA<int>(), 'user_id': 'userId'},
      );
      expect(payloadJson['user_id'], 'userId');
    });

    test('buildFeedToken', () async {
      final feedToken = TokenHelper.buildFeedToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(feedToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'feed',
        'feed_id': '*',
      });
    });

    test('buildFollowToken', () async {
      final feedToken = TokenHelper.buildFollowToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(feedToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'follower',
        'feed_id': '*',
      });
    });

    test('buildReactionToken', () async {
      final reactionToken =
          TokenHelper.buildReactionToken(secret, TokenAction.any);
      final tokenParts = reactionToken.token.split('.');
      final jwt = JsonWebToken.unverified(reactionToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'reactions',
        'feed_id': '*',
      });
    });

    test('buildActivityToken', () async {
      final activityToken =
          TokenHelper.buildActivityToken(secret, TokenAction.write);
      final jwt = JsonWebToken.unverified(activityToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = activityToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': 'write',
        'resource': 'activities',
        'feed_id': '*',
      });
    });

    test('buildUsersToken', () async {
      final usersToken = TokenHelper.buildUsersToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(usersToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = usersToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'users',
        'feed_id': '*',
      });
    });

    test('buildCollectionsToken', () async {
      final collectionsToken =
          TokenHelper.buildCollectionsToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(collectionsToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = collectionsToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'collections',
        'feed_id': '*',
      });
    });

    test('buildOpenGraphToken', () async {
      final openGraphToken = TokenHelper.buildOpenGraphToken(
        secret,
      );
      final jwt = JsonWebToken.unverified(openGraphToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = openGraphToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': 'read',
        'resource': 'url',
        'feed_id': '*',
      });
    });

    test('buildToTargetUpdateToken', () async {
      final toTargetUpdateToken =
          TokenHelper.buildToTargetUpdateToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(toTargetUpdateToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = toTargetUpdateToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'feed_targets',
        'feed_id': '*',
      });
    });

    test('buildAnalytics', () async {
      final filesToken = TokenHelper.buildAnalytics(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(filesToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = filesToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'analytics',
        'feed_id': '*',
      });
    });

    test('buildPersonalizationToken', () async {
      final filesToken = TokenHelper.buildPersonalizationToken(
          secret, TokenAction.any,
          userId: '*');
      final jwt = JsonWebToken.unverified(filesToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = filesToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'personalization',
        'feed_id': '*',
        'user_id': '*'
      });
    });

    test('buildAnalyticsRedirect', () async {
      final filesToken =
          TokenHelper.buildAnalyticsRedirect(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(filesToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = filesToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'redirect_and_track',
        'feed_id': '*',
      });
    });

    test('buildAnalyticsToken', () async {
      final filesToken =
          TokenHelper.buildAnalyticsToken(secret, TokenAction.write);
      final jwt = JsonWebToken.unverified(filesToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = filesToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': 'write',
        'resource': 'analytics',
        'feed_id': '*',
      });
    });
    test('buildFilesToken', () async {
      final filesToken = TokenHelper.buildFilesToken(secret, TokenAction.any);
      final jwt = JsonWebToken.unverified(filesToken.token);
      final verified = await jwt.verify(keyStore);
      expect(verified, true);
      final tokenParts = filesToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'action': '*',
        'resource': 'files',
        'feed_id': '*',
      });
    });
  });
}

// borrowed from jaquar/session package
String b64urlEncRfc7515Decode(String encoded) {
  // Detect incorrect "base64url" or normal "base64" encoding
  if (encoded.contains('=')) {
    throw const FormatException('Base64url Encoding: padding not allowed');
  }
  if (encoded.contains('+') || encoded.contains('/')) {
    throw const FormatException('Base64url Encoding: + and / not allowed');
  }

  // Add padding, if necessary
  var output = encoded;
  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw const FormatException('Base64url Encoding: invalid length');
  }

  // Decode
  return utf8
      .decode(base64Url.decode(output)); // this may throw FormatException
}
