import 'package:stream_feed/stream_feed.dart';
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
      //TODO: null
    });

    group('Map<String, List<Reaction>>', () {
      late Map<String, List<Reaction>> latestChildren;
      late Map<String, List<Reaction>> expectedResult;
      test('increment', () {
        latestChildren = {
          'like': [Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expectedResult = {
          'like': [Reaction(id: 'id3'), Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expect(latestChildren.unshiftByKind('like', Reaction(id: 'id3')),
            expectedResult);
      });

      test('decrement', () {
        latestChildren = {
          'like': [Reaction(id: 'id3'), Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expectedResult = {
          'like': [Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expect(
            latestChildren.unshiftByKind(
                'like', Reaction(id: 'id3'), ShiftType.decrement),
            expectedResult);
      });
    });
  });
}
