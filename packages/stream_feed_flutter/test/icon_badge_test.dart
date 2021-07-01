import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_feed_flutter/src/widgets/notification/notification.dart';

main() {
  testGoldens('IconBadge', (tester) async {
    await tester.pumpWidgetBuilder(
      Center(child: IconBadge(unseen: 3, onTap: () => print("hey"))),
      surfaceSize: const Size(50, 50),
    );
    await screenMatchesGolden(tester, 'icon_badge');
  });
}
