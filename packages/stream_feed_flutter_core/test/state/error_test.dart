import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter_core/src/states/empty.dart';
import 'package:stream_feed_flutter_core/src/states/error.dart';

void main() {
  testWidgets('ErrorStateWidget', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: ErrorStateWidget(),
    )));
    final text = find.text("Sorry an error has occured").first;
    expect(text, findsOneWidget);
  });

  test('Default ErrorStateWidget debugFillProperties', () {
    final builder = DiagnosticPropertiesBuilder();
    final errorStateWidget = ErrorStateWidget();

    // ignore: cascade_invocations
    errorStateWidget.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toDescription())
        .toList();

    expect(description, ['"Sorry an error has occured"']);
  });
}
