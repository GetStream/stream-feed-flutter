import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/human_readable_timestamp.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    final now = DateTime.now();
    final builder = DiagnosticPropertiesBuilder();
    HumanReadableTimestamp(
      timestamp: now,
    ).debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toJsonMap(const DiagnosticsSerializationDelegate()))
        .toList();

    expect(description[0]['description'], '$now');
  });
}
