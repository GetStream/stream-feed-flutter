import 'package:stream_feed_dart/src/core/util/enrichment.dart';
import 'package:test/test.dart';

main() {
  test('createCollectionReference', () {
    expect(createCollectionReference("collection", "id"), "SO:collection:id");
  });
}

//     createCollectionReference(String? collection, String? id) =>
//     'SO:$collection:$id';

// String createUserReference(String id) => 'SU:$id';

// String createActivityReference(String id) => 'SA:$id';
