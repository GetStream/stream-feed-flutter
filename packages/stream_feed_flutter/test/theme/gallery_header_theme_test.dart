import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('GalleryHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(const GalleryHeaderThemeData(),
        const GalleryHeaderThemeData().copyWith());
    expect(const GalleryHeaderThemeData().hashCode,
        const GalleryHeaderThemeData().copyWith().hashCode);
  });

  group('GalleryHeaderThemeData lerp', () {
    test('Lerp from light to dark', () {
      expect(
          const GalleryHeaderThemeData()
              .lerp(_galleryHeaderTheme, _galleryHeaderThemeDark, 1),
          _galleryHeaderThemeDark);
    });

    test('Lerp halfway from light to dark', () {
      expect(
          const GalleryHeaderThemeData()
              .lerp(_galleryHeaderTheme, _galleryHeaderThemeDark, 0.5),
          _galleryHeaderThemeMidLerp);
    });

    test('Lerp from dark to light', () {
      expect(
          const GalleryHeaderThemeData()
              .lerp(_galleryHeaderThemeDark, _galleryHeaderTheme, 1),
          _galleryHeaderTheme);
    });
  });

  testWidgets('Passing no GalleryHeaderThemeData returns default values',
      (WidgetTester tester) async {
    late BuildContext _context;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: child!,
        ),
        home: Builder(
          builder: (context) {
            _context = context;
            return const Scaffold(
              appBar: GalleryHeader(),
            );
          },
        ),
      ),
    );

    final galleryHeaderTheme = GalleryHeaderTheme.of(_context);
    expect(galleryHeaderTheme.closeButtonColor,
        _galleryHeaderThemeDark.closeButtonColor);
    expect(galleryHeaderTheme.backgroundColor,
        _galleryHeaderThemeDark.backgroundColor);
    expect(galleryHeaderTheme.titleTextStyle,
        _galleryHeaderThemeDark.titleTextStyle);
  });

  testWidgets('default GalleryHeaderThemeData debugFillProperties',
      (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const GalleryHeaderThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'closeButtonColor: null',
        'backgroundColor: null',
        'titleTextStyle: null',
      ],
    );
  });
}

// Light theme test control.
const _galleryHeaderTheme = GalleryHeaderThemeData(
  closeButtonColor: Colors.black,
  backgroundColor: Colors.white,
  titleTextStyle: TextStyle(
    color: Colors.black,
  ),
);

const _galleryHeaderThemeMidLerp = GalleryHeaderThemeData(
  closeButtonColor: Color(0xff7f7f7f),
  backgroundColor: Color(0xff7f7f7f),
  titleTextStyle: TextStyle(
    color: Color(0xff7f7f7f),
  ),
);

const _galleryHeaderThemeDark = GalleryHeaderThemeData(
  closeButtonColor: Colors.white,
  backgroundColor: Colors.black,
  titleTextStyle: TextStyle(
    color: Colors.white,
  ),
);
