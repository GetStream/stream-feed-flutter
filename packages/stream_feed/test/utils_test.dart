import 'package:stream_feed_dart/src/core/util/serializer.dart';
import 'package:test/test.dart';

main() {
  group('Serializer', () {
    test('moveKeysToMapInPlace', () {
    final serializer =
        Serializer.moveKeysToMapInPlace({'test': 'test'}, ['test']);
    expect(serializer, {'test': 'test'});
  });

    test('moveKeysToMapInPlace', () {
    final serializer =
        Serializer.moveKeysToRoot({'test': 'test'}, ['test']);
    expect(serializer, {'test': 'test', 'extra_data': {}});
  });
  });
}
