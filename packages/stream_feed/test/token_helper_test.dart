import 'package:stream_feed_dart/src/core/util/token_helper.dart';
import 'package:test/test.dart';
import 'dart:convert';

main() {
  group('TokenHelper', () {
    const secret =
        // ignore: lines_longer_than_80_chars
        'AyM1SysPpbyDfgZld3umj1qzKObwVMkoqQ-EstJQLr_T-1qS0gZH75aKtMN3Yj0iPS4hcgUuTwjAzZr1Z9CAow';
    test('buildFrontendToken', () {
      final expiresAt = DateTime(2021, 03, 08);

      final frontendToken = TokenHelper.buildFrontendToken(secret, 'userId',
          expiresAt: expiresAt);
      final tokenParts = frontendToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);

      expect(payloadJson,
          {'exp': isA<int>(), 'iat': isA<int>(), 'user_id': 'userId'});
      expect(payloadJson['user_id'], 'userId');
    });

    test('buildFollowToken', () {
      final feedToken = TokenHelper.buildFollowToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'follower',
        'feed_id': '*',
      });
    });

    test('buildReactionToken', () {
      final feedToken = TokenHelper.buildReactionToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'reactions',
        'feed_id': '*',
      });
    });

    test('buildActivityToken', () {
      final feedToken = TokenHelper.buildActivityToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'activities',
        'feed_id': '*',
      });
    });

    test('buildUsersToken', () {
      final feedToken = TokenHelper.buildUsersToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'users',
        'feed_id': '*',
      });
    });

    test('buildCollectionsToken', () {
      final feedToken =
          TokenHelper.buildCollectionsToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'collections',
        'feed_id': '*',
      });
    });

    test('buildOpenGraphToken', () {
      final feedToken = TokenHelper.buildOpenGraphToken(
        secret,
      );
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': 'read',
        'resource': 'url',
        'feed_id': '*',
      });
    });

    test('buildToTargetUpdateToken', () {
      final feedToken =
          TokenHelper.buildToTargetUpdateToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
        'action': '*',
        'resource': 'feed_targets',
        'feed_id': '*',
      });
    });

    test('buildFilesToken', () {
      final feedToken = TokenHelper.buildFilesToken(secret, TokenAction.any);
      final tokenParts = feedToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      final headerdStr = b64urlEncRfc7515Decode(header);
      final headerJson = json.decode(headerdStr);
      expect(headerJson, {'alg': 'HS256', 'typ': 'JWT'});
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      expect(payloadJson, {
        'exp': isA<int>(),
        'iat': isA<int>(),
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
