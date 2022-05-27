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

typedef CustomFeedProvider
    = GenericFeedProvider<User, CollectionEntry, String, String>;

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
    'FeedProvider',
    (tester) async {
      final mockClient = MockClient();
      final childKey = GlobalKey();
      final streamFeedCore = FeedProvider(
        bloc: FeedBloc(
          client: mockClient,
        ),
        child: TestWidget(key: childKey),
      );

      await tester.pumpWidget(streamFeedCore);

      // expect(find.byKey(streamFeedCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
      expect(FeedProvider.of(childKey.currentState!.context).bloc, isNotNull);
    },
  );

  testWidgets(
    'CustomFeedProvider',
    (tester) async {
      final mockClient = MockClient();
      final childKey = GlobalKey();
      final streamFeedCore = CustomFeedProvider(
        bloc: GenericFeedBloc(
          client: mockClient,
        ),
        child: TestWidget(key: childKey),
      );

      await tester.pumpWidget(streamFeedCore);

      // expect(find.byKey(streamFeedCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
      expect(CustomFeedProvider.of(childKey.currentState!.context).bloc,
          isNotNull);
    },
  );

  testWidgets(
    'Equatable',
    (tester) async {
      final mockClient1 = StreamFeedClient('apiKey1');
      final mockClient2 = StreamFeedClient('apiKey1');
      final mockClient3 = StreamFeedClient('apiKey2');
      final bloc1 = GenericFeedBloc(
        client: mockClient1,
      );
      final bloc2 = GenericFeedBloc(
        client: mockClient2,
      );
      final bloc3 = GenericFeedBloc(
        client: mockClient3,
      );

      expect(mockClient1 == mockClient2, true);
      expect(mockClient1 != mockClient3, true);
      expect(bloc1 == bloc2, true);
      expect(bloc1 != bloc3, true);
    },
  );
  testWidgets(
    'throw an error if StreamFeedCore is not in the tree',
    (tester) async {
      final childKey = GlobalKey();

      await tester.pumpWidget(TestWidget(key: childKey));

      expect(
          () => FeedProvider.of(childKey.currentState!.context),
          throwsA(predicate<AssertionError>((e) =>
              e.message ==
              '''No `FeedProvider` or `GenericFeedProvider<User, String, String, String>` found in context''')));
    },
  );
}
