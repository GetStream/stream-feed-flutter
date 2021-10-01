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

  testWidgets('default GifDialogTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const childReactionTheme = GifDialogTheme(
      data: GifDialogThemeData(),
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
        'data: GifDialogThemeData#00000(boxDecoration: null, iconColor: null)',
      ],
    );
  });

  testWidgets('GifDialogTheme wrap', (tester) async {
    final Key inkWellKey = UniqueKey();
    const iconColor = Colors.red;
    final Widget result = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return InkWell(
              key: inkWellKey,
              hoverColor: GifDialogTheme.of(context).iconColor,
            );
          },
        ),
      ),
    );

    late BuildContext navigatorContext;

    MaterialApp buildFrame() {
      return MaterialApp(
        home: Scaffold(
          body: GifDialogTheme(
            data: const GifDialogThemeData(
              iconColor: iconColor,
            ),
            child: Builder(
              builder: (context) {
                navigatorContext = context;

                return ElevatedButton(
                  child:
                      const Text('push wrapped'), //TODO(sacha): push unwrapped
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        // Capture the shadow ChildReactionTheme.
                        builder: (BuildContext _) =>
                            InheritedTheme.captureAll(context, result),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    };

    Color inkWellColor() {
      return tester.widget<InkWell>(find.byKey(inkWellKey)).hoverColor!;
    }

    await tester.pumpWidget(buildFrame());

    // Show the route which contains InkWell which was wrapped with
    // InheritedTheme.captureAll().
    await tester.tap(find.text('push wrapped'));
    await tester.pumpAndSettle(); // route animation
    expect(inkWellColor(), iconColor);
  });

  testWidgets('GalleryHeaderTheme updateShouldNotify', (tester) async {
    TestGifDialogTheme? result;
    final builder = Builder(
      builder: (context) {
        result =
            context.dependOnInheritedWidgetOfExactType<TestGifDialogTheme>();
        return Container();
      },
    );

    final first = TestGifDialogTheme(
      shouldNotify: true,
      data: const GifDialogThemeData(),
      child: builder,
    );

    final second = TestGifDialogTheme(
      shouldNotify: false,
      data: const GifDialogThemeData(),
      child: builder,
    );

    final third = TestGifDialogTheme(
      shouldNotify: true,
      data: const GifDialogThemeData(),
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

class TestGifDialogTheme extends GifDialogTheme {
  const TestGifDialogTheme({
    Key? key,
    required GifDialogThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant GifDialogTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
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
