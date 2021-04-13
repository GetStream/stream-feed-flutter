import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/users_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  group('Users Client', () {
    final api = MockUsersApi();

    const secret = 'secret';
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
      await client.add(id, data);
      verify(() => api.add(token, id, data)).called(1);
    });
  });
}
