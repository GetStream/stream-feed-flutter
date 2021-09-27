import 'package:stream_feed_flutter_core/src/extensions.dart';
import 'package:test/test.dart';

main() {
  group('unshiftByKind', () {
    group('Map<String, int>', () {
      late Map<String, int> childrenCounts;
      late Map<String, int> expectedResult;
      test('increment', () {
        childrenCounts = {'like': 10, 'post': 27, 'repost': 69};
        expectedResult = {'like': 11, 'post': 27, 'repost': 69};
        expect(childrenCounts.unshiftByKind('like'), expectedResult);
      });

      test('decrement', () {
        childrenCounts = {'like': 10, 'post': 27, 'repost': 69};
        expectedResult = {'like': 9, 'post': 27, 'repost': 69};
        expect(childrenCounts.unshiftByKind('like', ShiftType.decrement),
            expectedResult);
      });
    });
  });
}
