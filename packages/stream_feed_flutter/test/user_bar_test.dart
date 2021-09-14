import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/icons.dart';
import 'package:stream_feed_flutter/src/widgets/user/avatar.dart';
import 'package:stream_feed_flutter/src/widgets/user/user_bar.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
  testWidgets('UserBar', (tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Scaffold(
            body: UserBar(
              kind: 'like',
              timestamp: DateTime.now(),
              user: const User(
                data: {
                  'name': 'Rosemary',
                  'handle': '@rosemary',
                  'subtitle': 'likes playing fresbee in the park',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/20.jpg',
                },
              ),
            ),
          ),
        ),
      );

      final avatar = find.byType(Avatar);
      expect(avatar, findsOneWidget);

      final username = find.text('Rosemary').first;
      expect(username, findsOneWidget);

      final timeago = find.text('a moment ago').first;
      expect(timeago, findsOneWidget);

      final icon = find.byType(StreamSvgIcon);
      final activeIcon = tester.widget<StreamSvgIcon>(icon);
      expect(activeIcon.assetName, StreamSvgIcon.loveActive().assetName);

      final by = find.text('by ').first;
      expect(by, findsOneWidget);
      final handle = find.text('@rosemary').first;
      expect(handle, findsOneWidget);
    });
  });

  testWidgets('Default UserBar debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    final now = DateTime.now();
    final userBar = UserBar(
      kind: 'like',
      timestamp: now,
      user: const User(
        data: {
          'name': 'Rosemary',
          'handle': '@rosemary',
          'subtitle': 'likes playing fresbee in the park',
          'profile_image': 'https://randomuser.me/api/portraits/women/20.jpg',
        },
      ),
    );

    // ignore: cascade_invocations
    userBar.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], 'true');
  });
}
