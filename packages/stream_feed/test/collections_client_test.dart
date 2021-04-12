import 'package:mocktail/mocktail.dart';
import 'package:stream_feed_dart/src/client/stream_client_impl.dart';
import 'package:stream_feed_dart/src/core/models/collection_entry.dart';
import 'package:test/test.dart';

import 'mock.dart';

main() {
  group('CollectionsClient', () {
    final collections = MockCollectionsClient();
    final client = StreamClientImpl('apiKey', secret: 'dummy')
      ..collections = collections;
    test('add', () async {
      const entryId = '123';
      const userId = 'userId';
      const entry = CollectionEntry(collection: 'users', id: entryId, data: {
        'name': 'john',
        'favorite_color': 'blue',
      });
      when(() => client.collections.add('user', entry.data!,
          entryId: entryId, userId: userId)).thenAnswer((_) async => entry);
      final addedCollection = await client.collections
          .add('user', entry.data!, entryId: entryId, userId: userId);
      expect(addedCollection, entry);
      verify(() => client.collections.add('user', entry.data!,
          entryId: entryId, userId: userId)).called(1);
    });
  });
}
