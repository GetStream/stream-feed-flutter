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

  testWidgets('default GalleryHeaderTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const childReactionTheme = GalleryHeaderTheme(
      data: GalleryHeaderThemeData(),
      child: SizedBox(),
    );
    // ignore: cascade_invocations
    childReactionTheme.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'data: GalleryHeaderThemeData#007db(closeButtonColor: null, backgroundColor: null, titleTextStyle: null)',
      ],
    );
  });

  testWidgets('GalleryHeaderTheme wrap', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final navigator = Navigator.of(context);

            final themes =
                InheritedTheme.capture(from: context, to: navigator.context);

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext _) {
                      // Wrap the actual child of the route in the previously
                      // captured themes.
                      return themes.wrap(
                        GalleryHeaderTheme(
                          data: const GalleryHeaderThemeData(),
                          child: Builder(
                            builder: (context) {
                              final theme = GalleryHeaderTheme.of(context);
                              return InheritedTheme.captureAll(
                                context,
                                Container(
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: const Text('Hello World'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              child: const Center(child: Text('Tap Here')),
            );
          },
        ),
      ),
    );

    final tapButton = find.text('Tap Here');
    expect(tapButton, findsOneWidget);

    await tester.tap(tapButton);
    await tester.pumpAndSettle();

    expect((tester.firstWidget(find.byType(Container)) as Container).color,
        Colors.white);
  });

  testWidgets('GalleryHeaderTheme updateShouldNotify', (tester) async {
    TestGalleryHeaderTheme? result;
    final builder = Builder(
      builder: (context) {
        result = context
            .dependOnInheritedWidgetOfExactType<TestGalleryHeaderTheme>();
        return Container();
      },
    );

    final first = TestGalleryHeaderTheme(
      shouldNotify: true,
      data: const GalleryHeaderThemeData(),
      child: builder,
    );

    final second = TestGalleryHeaderTheme(
      shouldNotify: false,
      data: const GalleryHeaderThemeData(),
      child: builder,
    );

    final third = TestGalleryHeaderTheme(
      shouldNotify: true,
      data: const GalleryHeaderThemeData(),
      child: builder,
    );

    await tester.pumpWidget(first);
    expect(result, equals(first));

    await tester.pumpWidget(second);
    expect(result, equals(first));

    await tester.pumpWidget(third);
    expect(result, equals(third));
  });
}

class TestGalleryHeaderTheme extends GalleryHeaderTheme {
  const TestGalleryHeaderTheme({
    Key? key,
    required GalleryHeaderThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant GalleryHeaderTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
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
