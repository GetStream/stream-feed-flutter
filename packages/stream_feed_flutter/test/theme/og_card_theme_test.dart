import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('OgCardThemeData copyWith, ==, hashCode basics', () {
    expect(const OgCardThemeData(), const OgCardThemeData().copyWith());
    expect(const OgCardThemeData().hashCode,
        const OgCardThemeData().copyWith().hashCode);
  });

  test('OgCardThemeData lerps halfway', () {
    expect(
        const OgCardThemeData()
            .lerp(_ogCardThemeDefault, _ogCardThemeFullLerp, 0.5),
        _ogCardThemeMidLerp);
  });

  testWidgets('default OgCardThemeData debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const OgCardThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'titleTextStyle: null',
        'descriptionTextStyle: null',
      ],
    );
  });
}

const _ogCardThemeDefault = OgCardThemeData(
  titleTextStyle: TextStyle(
    color: Color(0xff007aff),
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  ),
  descriptionTextStyle: TextStyle(
    color: Color(0xff364047),
    fontSize: 13,
    overflow: TextOverflow.ellipsis,
  ),
);

const _ogCardThemeMidLerp = OgCardThemeData(
  titleTextStyle: TextStyle(
    color: Color(0xff7a5e9a),
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  ),
  descriptionTextStyle: TextStyle(
    color: Color(0xff3c4144),
    fontSize: 13,
    overflow: TextOverflow.ellipsis,
  ),
);

final _ogCardThemeFullLerp = OgCardThemeData(
  titleTextStyle: const TextStyle(
    color: Colors.red,
    fontSize: 14,
    overflow: TextOverflow.ellipsis,
  ),
  descriptionTextStyle: TextStyle(
    color: Colors.grey.shade800,
    fontSize: 13,
    overflow: TextOverflow.ellipsis,
  ),
);
