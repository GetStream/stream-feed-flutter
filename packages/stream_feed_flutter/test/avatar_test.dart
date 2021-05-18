import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';
// import 'package:test/test.dart';

void main() {
  group('Avatar', () {
    testWidgets('url', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(Avatar(url: 'https://via.placeholder.com/150'));
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testGoldens('avatar', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(child: Avatar()),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'avatar');
    });
  });
}
