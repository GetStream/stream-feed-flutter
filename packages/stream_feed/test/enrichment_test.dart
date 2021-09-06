import 'package:stream_feed/src/core/util/enrichment.dart';
import 'package:test/test.dart';

void main() {
  test('createCollectionReference', () {
    expect(createCollectionReference('collection', 'id'), 'SO:collection:id');
  });
  test('createUserReference', () {
    expect(createUserReference('id'), 'SU:id');
  });

  test('createActivityReference', () {
    expect(createActivityReference('id'), 'SA:id');
  });

  test('createReactionReference', () {
    expect(createReactionReference('id'), 'SR:id');
  });
}
