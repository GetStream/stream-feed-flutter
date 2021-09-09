import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('GifDialogThemeData copyWith, ==, hashCode basics', () {
    expect(const GifDialogThemeData(), const GifDialogThemeData().copyWith());
    expect(const GifDialogThemeData().hashCode,
        const GifDialogThemeData().copyWith().hashCode);
  });

  test('ChildReactionThemeData lerps halfway', () {
    expect(
        const GifDialogThemeData()
            .lerp(_gifDialogThemeDefault, _gifDialogThemeFullLerp, 0.5),
        _gifDialogThemeMidLerp);
  });

  testWidgets('default GifDialogThemeData debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const GifDialogThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'boxDecoration: null',
        'iconColor: null',
      ],
    );
  });
}

final _gifDialogThemeDefault = GifDialogThemeData(
  boxDecoration: BoxDecoration(
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Colors.blue),
  ),
  iconColor: Colors.blue,
);

final _gifDialogThemeMidLerp = GifDialogThemeData(
  boxDecoration: BoxDecoration(
    borderRadius: BorderRadius.circular(7),
    border: Border.all(color: const Color(0xff8a6c94)),
  ),
  iconColor: const Color(0xff8a6c94),
);

final _gifDialogThemeFullLerp = GifDialogThemeData(
  boxDecoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.red),
  ),
  iconColor: Colors.red,
);
