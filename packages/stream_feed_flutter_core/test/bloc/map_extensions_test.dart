import 'package:rxdart/rxdart.dart';
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

    group('Map<String, BehaviorSubject<List<Reaction>>>', () {
      late Map<String, BehaviorSubject<List<Reaction>>> ownChildren;
      late Map<String, List<Reaction>> expectedResult;

      test('increment', () async {
        ownChildren = {
          'like': BehaviorSubject.seeded([const Reaction(id: 'id')]),
          'post': BehaviorSubject.seeded([const Reaction(id: 'id2')]),
        };
        expectedResult = {
          'like': [const Reaction(id: 'id3'), const Reaction(id: 'id')]
        };
        ownChildren.unshiftById('like', const Reaction(id: 'id3'));
        await expectLater(
            ownChildren['like']!.stream, emits(expectedResult['like']));
      });

      test('decrement', () async {
        ownChildren = {
          'like':
              BehaviorSubject.seeded([const Reaction(id: 'id3'), Reaction(id: 'id')]),
          'post': BehaviorSubject.seeded([const Reaction(id: 'id2')])
        };
        expectedResult = {
          'like': [Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        ownChildren.unshiftById(
            'like', Reaction(id: 'id3'), ShiftType.decrement);
        await expectLater(
            ownChildren['like']!.stream, emits(expectedResult['like']));
      });
    });
    group('Map<String, List<Reaction>>', () {
      late Map<String, List<Reaction>> ownChildren;
      late Map<String, List<Reaction>> expectedResult;

      group('increment', () {
        test('not null', () {
          ownChildren = {
            'like': [Reaction(id: 'id')],
            'post': [Reaction(id: 'id2')],
          };
          expectedResult = {
            'like': [Reaction(id: 'id3'), Reaction(id: 'id')],
            'post': [Reaction(id: 'id2')]
          };

          expect(ownChildren.unshiftByKind('like', Reaction(id: 'id3')),
              expectedResult);
        });

        test('null', () {
          ownChildren = {
            'like': [Reaction(id: 'id')],
            'post': [Reaction(id: 'id2')],
          };
          expectedResult = {
            'like': [Reaction(id: 'id')],
            'post': [Reaction(id: 'id2')],
            'repost': [Reaction(id: 'id3')]
          };

          expect(ownChildren.unshiftByKind('repost', Reaction(id: 'id3')),
              expectedResult);
        });
      });

      test('decrement', () {
        ownChildren = {
          'like': [Reaction(id: 'id3'), Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expectedResult = {
          'like': [Reaction(id: 'id')],
          'post': [Reaction(id: 'id2')]
        };
        expect(
            ownChildren.unshiftByKind(
                'like', Reaction(id: 'id3'), ShiftType.decrement),
            expectedResult);
      });
    });
  });
}
