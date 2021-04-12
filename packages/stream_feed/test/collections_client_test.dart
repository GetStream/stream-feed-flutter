import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';
import 'package:stream_feed_dart/src/core/api/stream_api_impl.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  group('CollectionsClient', () {
    final client = MockCollectionsClient();
    test('add', () async {
      const entryId = '123';
      const userId = 'userId';
      const entry = CollectionEntry(collection: 'users', id: entryId, data: {
        'name': 'john',
        'favorite_color': 'blue',
      });
      when(() =>
              client.add('user', entry.data!, entryId: entryId, userId: userId))
          .thenAnswer((_) async => entry);
      final addedCollection = await client.add('user', entry.data!,
          entryId: entryId, userId: userId);
      expect(addedCollection, entry);
      verify(() =>
              client.add('user', entry.data!, entryId: entryId, userId: userId))
          .called(1);
    });
  });
}
