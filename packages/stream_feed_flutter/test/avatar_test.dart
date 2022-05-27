import 'package:flutter/foundation.dart';
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
                ),
              ),
            ),
          ),
        );
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('tap on avatar', (tester) async {
      final log = <User>[];
      const user = User(
        data: {
          'name': 'Sloan Humfrey',
          'profile_image': 'https://randomuser.me/api/portraits/women/1.jpg',
        },
      );
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Avatar(
                onUserTap: (user) {
                  log.add(user!);
                },
                user: const User(
                  data: {
                    'name': 'Sloan Humfrey',
                    'profile_image':
                        'https://randomuser.me/api/portraits/women/1.jpg',
                  },
                ),
              ),
            ),
          ),
        );
        final theLastAirbender = find.byType(Avatar);
        await tester.tap(theLastAirbender);
        expect(log, [user]);
      });
    });

    test('Default Avatar debugFillProperties', () async {
      await mockNetworkImages(() async {
        final builder = DiagnosticPropertiesBuilder();
        const avatar = Avatar();
        avatar.debugFillProperties(builder);

        final description = builder.properties
            .where((node) => !node.isFiltered(DiagnosticLevel.info))
            .map((node) =>
                node.toJsonMap(const DiagnosticsSerializationDelegate()))
            .toList();

        expect(description[0]['description'], 'null');
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
