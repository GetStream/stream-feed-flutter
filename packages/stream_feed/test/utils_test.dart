import 'package:stream_feed_dart/src/core/util/extension.dart';
import 'package:stream_feed_dart/src/core/util/serializer.dart';
import 'package:test/test.dart';

main() {
  group('extension', () {
    test('nullProtected', () {
      expect({null: 'nullKey'}.nullProtected, {});
      expect({'nullValue': null}.nullProtected, {});
    });
    test('checkNotNull', () {
      expect(
          () => checkNotNull(null, 'your custom message'),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'your custom message')));
    });
    test('checkArgument', () {
      expect(
          () => checkArgument(false, 'your custom message'),
          throwsA(predicate<ArgumentError>(
              (e) => e.message == 'your custom message')));
    });
  });

  group('Serializer', () {
    test('moveKeysToMapInPlace', () {
      final serializer =
          Serializer.moveKeysToMapInPlace({'test': 'test'}, ['test']);
      expect(serializer, {'test': 'test'});
    });

    test('moveKeysToMapInPlace', () {
      final serializer = Serializer.moveKeysToRoot({'test': 'test'}, ['test']);
      expect(serializer, {'test': 'test', 'extra_data': {}});
    });
  });
}
