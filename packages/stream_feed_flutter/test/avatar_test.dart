import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
  group('Avatar', () {
    testWidgets('url', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          const Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Avatar(
                  user: User(
                data: {
                  'name': 'Sloan Humfrey',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/1.jpg',
                },
              )),
            ),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testGoldens('avatar default', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(
          child: Avatar(),
        ),
        surfaceSize: const Size(50, 50),
      );
      await screenMatchesGolden(tester, 'avatar');
    });
  });
}
