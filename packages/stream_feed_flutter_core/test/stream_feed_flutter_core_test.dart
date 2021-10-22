import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void main() {
  testWidgets(
    'should render StreamFeedCore if both client and child is provided',
    (tester) async {
      final mockClient = MockClient();
      // const streamFeedCoreKey = Key('streamFeedCore');
      final childKey = GlobalKey();
      final streamFeedCore = GenericFeedProvider(
        bloc: GenericFeedBloc(
          client: mockClient,
        ),
        child: TestWidget(key: childKey),
      );

      await tester.pumpWidget(streamFeedCore);

      // expect(find.byKey(streamFeedCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
      expect(GenericFeedProvider.of(childKey.currentState!.context).bloc,
          isNotNull);
    },
  );
  testWidgets(
    'throw an error if StreamFeedCore is not in the tree',
    (tester) async {
      final childKey = GlobalKey();

      await tester.pumpWidget(TestWidget(key: childKey));

      expect(
          () => FeedProvider.of(childKey.currentState!.context),
          throwsA(predicate<AssertionError>(
              (e) => e.message == 'No FeedBlocProvider found in context')));
      // expect(find.byKey(childKey), findsOneWidget);
    },
  );
}
