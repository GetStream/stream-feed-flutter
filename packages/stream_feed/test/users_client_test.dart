import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/users_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/user.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('Users Client', () {
    final api = MockUsersAPI();

    const token = Token('dummyToken');
    final client = UsersClient(api, userToken: token);
    test('add', () async {
      const id = 'john-doe';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      const user = User(id: id, data: data);
      when(() => api.add(token, id, data)).thenAnswer((_) async => user);
      await client.create(id, data);
      verify(() => api.add(token, id, data)).called(1);
    });

    test('delete', () async {
      const id = 'john-doe';
      when(() => api.delete(token, id)).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: '',
          ),
          statusCode: 200));
      await client.delete(id);
      verify(() => api.delete(token, id)).called(1);
    });

    test('get', () async {
      const id = 'john-doe';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      const user = User(id: id, data: data);
      when(() => api.get(token, id)).thenAnswer((_) async => user);
      await client.get(id);

      verify(() => api.get(token, id)).called(1);
    });

    test('update', () async {
      const id = 'john-doe';
      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      const user = User(id: id, data: data);
      when(() => api.update(token, id, data)).thenAnswer((_) async => user);
      await client.update(id, data);
      verify(() => api.update(token, id, data)).called(1);
    });
  });
}
