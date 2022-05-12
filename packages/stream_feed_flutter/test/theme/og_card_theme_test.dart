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

  testWidgets('default OgCardTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ogCardTheme = OgCardTheme(
      data: OgCardThemeData(),
      child: SizedBox(),
    );
    ogCardTheme.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        '''data: OgCardThemeData#00000(titleTextStyle: null, descriptionTextStyle: null)''',
      ],
    );
  });

  testWidgets('OgCardTheme wrap', (tester) async {
    final Key inkWellKey = UniqueKey();
    const titleTextStyle = TextStyle(color: Colors.red);

    final Widget result = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return InkWell(
              key: inkWellKey,
              hoverColor: OgCardTheme.of(context).titleTextStyle!.color,
            );
          },
        ),
      ),
    );

    MaterialApp buildFrame() {
      return MaterialApp(
        home: Scaffold(
          body: OgCardTheme(
            data: const OgCardThemeData(
              titleTextStyle: titleTextStyle,
            ),
            child: Builder(
              builder: (context) {
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
    }

    Color inkWellColor() {
      return tester.widget<InkWell>(find.byKey(inkWellKey)).hoverColor!;
    }

    await tester.pumpWidget(buildFrame());

    // Show the route which contains InkWell which was wrapped with
    // InheritedTheme.captureAll().
    await tester.tap(find.text('push wrapped'));
    await tester.pumpAndSettle(); // route animation
    expect(inkWellColor(), titleTextStyle.color);
  });

  testWidgets('OgCardTheme updateShouldNotify', (tester) async {
    TestOgCardTheme? result;
    final builder = Builder(
      builder: (context) {
        result = context.dependOnInheritedWidgetOfExactType<TestOgCardTheme>();
        return Container();
      },
    );

    final first = TestOgCardTheme(
      shouldNotify: true,
      data: const OgCardThemeData(),
      child: builder,
    );

    final second = TestOgCardTheme(
      shouldNotify: false,
      data: const OgCardThemeData(),
      child: builder,
    );

    final third = TestOgCardTheme(
      shouldNotify: true,
      data: const OgCardThemeData(),
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

class TestOgCardTheme extends OgCardTheme {
  const TestOgCardTheme({
    Key? key,
    required OgCardThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant OgCardTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
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
