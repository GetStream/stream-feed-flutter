import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';

import 'utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Users API', () {
    final mockClient = MockHttpClient();
    final usersApi = UsersApiImpl(mockClient);
    test('Get', () async {
      const token = Token('dummyToken');
      const targetToken = Token('dummyToken2');
      const id = 'id';
      const withFollowCounts = true;
      when(mockClient.get(
        Routes.buildUsersUrl('$id/'),
        headers: {'Authorization': '$token'},
        queryParameters: {'with_follow_counts': withFollowCounts},
      )).thenAnswer((_) async =>
          Response(data: jsonFixture('user.json'), statusCode: 200));

      await usersApi.get(token, id);

      verify(mockClient.get(
        Routes.buildUsersUrl('$id/'),
        headers: {'Authorization': '$token'},
        queryParameters: {'with_follow_counts': withFollowCounts},
      )).called(1);
    });
  });
}
