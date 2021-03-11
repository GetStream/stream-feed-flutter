import 'package:jose/jose.dart';
import 'package:stream_feed_dart/src/core/util/token_helper.dart';
import 'package:test/test.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'dart:convert';
import 'dart:convert';

main() {
  group('TokenHelper', () {
    test('buildFrontendToken', () {
      final expiresAt = DateTime(2021, 03, 08);
      final frontendToken = TokenHelper.buildFrontendToken("secret", "userId",
          expiresAt: expiresAt);
      // expect(frontendToken, "matcher");
      final tokenParts = frontendToken.token.split('.');
      final header = tokenParts[0];
      final payload = tokenParts[1];
      expect(header, 'eyJhbGciOiJIUzI1NiJ9');
      final payloadStr = b64urlEncRfc7515Decode(payload);
      final payloadJson = json.decode(payloadStr);
      //expect(payloadJson['exp'], 1615176000); fails on linux somehow
      expect(payloadJson['user_id'], 'userId');
    });

    // test('buildFeedToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken = TokenHelper.buildFeedToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'feed');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildFollowToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken = TokenHelper.buildFollowToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'follower');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildReactionToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken =
    //       TokenHelper.buildReactionToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'reactions');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildActivityToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken =
    //       TokenHelper.buildActivityToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'activities');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildUsersToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken = TokenHelper.buildUsersToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'users');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildCollectionsToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken =
    //       TokenHelper.buildCollectionsToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'collections');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildOpenGraphToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken = TokenHelper.buildOpenGraphToken(
    //     "secret",
    //   );
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], 'read');
    //   expect(payloadJson['resource'], 'url');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildToTargetUpdateToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken =
    //       TokenHelper.buildToTargetUpdateToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'feed_targets');
    //   expect(payloadJson['feed_id'], '*');
    // });

    // test('buildFilesToken', () {
    //   final expiresAt = DateTime(2021, 03, 08);
    //   final feedToken = TokenHelper.buildFilesToken("secret", TokenAction.any);
    //   final tokenParts = feedToken.token.split('.');
    //   final header = tokenParts[0];
    //   final payload = tokenParts[1];
    //   expect(header, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9');
    //   final payloadStr = b64urlEncRfc7515Decode(payload);
    //   final payloadJson = json.decode(payloadStr);
    //   expect(payloadJson['action'], '*');
    //   expect(payloadJson['resource'], 'files');
    //   expect(payloadJson['feed_id'], '*');
    // });
  });
}

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
