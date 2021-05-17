import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'should render StreamFeedCore if both client and child is provided',
    (tester) async {
      final mockClient = MockClient();
      const streamFeedCoreKey = Key('streamFeedCore');
      const childKey = Key('child');
      final streamFeedCore = StreamFeedCore(
        key: streamFeedCoreKey,
        client: mockClient,
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(streamFeedCore);

      expect(find.byKey(streamFeedCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );
}
