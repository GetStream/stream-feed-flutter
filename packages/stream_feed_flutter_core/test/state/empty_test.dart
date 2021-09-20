import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';

void main() {
  testWidgets('EmptyStateWidget', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: EmptyStateWidget(),
    )));
    final text = find.text("Nothing here...").first;
    expect(text, findsOneWidget);
  });

  test('Default EmptyStateWidget debugFillProperties', () {
    final builder = DiagnosticPropertiesBuilder();
    final emptyStateWidget = EmptyStateWidget();

    // ignore: cascade_invocations
    emptyStateWidget.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toDescription())
        .toList();

    expect(description, ['"Nothing here..."']);
  });
}
