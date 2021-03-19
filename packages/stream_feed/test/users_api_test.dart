import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'package:test/test.dart';

import 'utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Users API', () {
    final mockClient = MockHttpClient();
    final usersApi = UsersApiImpl(mockClient);
    test('Get', () async {
      const token = Token('dummyToken');
      const id = 'id';
      const withFollowCounts = true;
      when(() => mockClient.get(
            Routes.buildUsersUrl('$id/'),
            headers: {'Authorization': '$token'},
            queryParameters: {'with_follow_counts': withFollowCounts},
          )).thenAnswer((_) async => Response(
          data: jsonFixture('user.json'),
          requestOptions: RequestOptions(
            path: Routes.buildUsersUrl('$id/'),
          ),
          statusCode: 200));

      await usersApi.get(token, id);

      verify(() => mockClient.get(
            Routes.buildUsersUrl('$id/'),
            headers: {'Authorization': '$token'},
            queryParameters: {'with_follow_counts': withFollowCounts},
          )).called(1);
    });
    test('Add', () async {
      const token = Token('dummyToken');

      const id = 'john-doe';

      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      const user = User(id: id, data: data);
      const getOrCreate = false;
      when(() => mockClient.post<Map>(
            Routes.buildUsersUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {'get_or_create': getOrCreate},
            data: user,
          )).thenAnswer((_) async => Response(
          data: jsonFixture('user.json'),
          requestOptions: RequestOptions(
            path: Routes.buildUsersUrl(),
          ),
          statusCode: 200));

      await usersApi.add(token, id, data);

      verify(() => mockClient.post<Map>(
            Routes.buildUsersUrl(),
            headers: {'Authorization': '$token'},
            queryParameters: {'get_or_create': getOrCreate},
            data: user,
          )).called(1);
    });

    test('Update', () async {
      const token = Token('dummyToken');

      const id = 'john-doe';

      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      const updatedUser = User(id: id, data: data);
      when(() => mockClient.put(
                Routes.buildUsersUrl('$id/'),
                headers: {'Authorization': '$token'},
                data: updatedUser,
              ))
          .thenAnswer((_) async => Response(
              data: jsonFixture('user.json'),
              requestOptions:
                  RequestOptions(path: Routes.buildUsersUrl('$id/')),
              statusCode: 200));

      await usersApi.update(token, id, data);

      verify(() => mockClient.put(
            Routes.buildUsersUrl('$id/'),
            headers: {'Authorization': '$token'},
            data: updatedUser,
          )).called(1);
    });

    test('Delete', () async {
      const token = Token('dummyToken');
      const id = 'john-doe';

      when(() => mockClient.delete(
                Routes.buildUsersUrl('$id/'),
                headers: {'Authorization': '$token'},
              ))
          .thenAnswer((_) async => Response(
              data: {},
              requestOptions:
                  RequestOptions(path: Routes.buildUsersUrl('$id/')),
              statusCode: 200));

      await usersApi.delete(token, id);

      verify(() => mockClient.delete(
            Routes.buildUsersUrl('$id/'),
            headers: {'Authorization': '$token'},
          )).called(1);
    });
  });
}
