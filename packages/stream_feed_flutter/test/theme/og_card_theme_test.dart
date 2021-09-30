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
    // ignore: cascade_invocations
    ogCardTheme.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'data: OgCardThemeData#00000(titleTextStyle: null, descriptionTextStyle: null)',
      ],
    );
  });

  testWidgets('OgCardTheme wrap', (tester) async {
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
                        OgCardTheme(
                          data: const OgCardThemeData(),
                          child: Builder(
                            builder: (context) {
                              final theme = OgCardTheme.of(context);
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
