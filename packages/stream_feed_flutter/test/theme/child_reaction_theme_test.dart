import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('ChildReactionThemeData copyWith, ==, hashCode basics', () {
    expect(const ChildReactionThemeData(),
        const ChildReactionThemeData().copyWith());
    expect(const ChildReactionThemeData().hashCode,
        const ChildReactionThemeData().copyWith().hashCode);
  });

  test('ChildReactionThemeData lerps halfway', () {
    expect(
        const ChildReactionThemeData()
            .lerp(_childReactionThemeDefault, _childReactionThemeFullLerp, 0.5),
        _childReactionThemeMidLerp);
  });

  testWidgets('Passing no ChildReactionTheme results in default values',
      (widgetTester) async {
    late BuildContext _context;
    await widgetTester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return StreamFeedTheme(
            data: StreamFeedThemeData(),
            child: child!,
          );
        },
        home: Builder(
          builder: (context) {
            _context = context;
            return Scaffold(
              body: Center(
                child: ChildReactionButton(
                  activeIcon: StreamSvgIcon.loveActive(),
                  inactiveIcon: StreamSvgIcon.loveInactive(),
                  kind: 'like',
                  reaction: const Reaction(),
                ),
              ),
            );
          },
        ),
      ),
    );

    final childReactionThemeData = ChildReactionTheme.of(_context);
    expect(childReactionThemeData.hoverColor,
        _childReactionThemeDefault.hoverColor);
    expect(childReactionThemeData.toggleColor,
        _childReactionThemeDefault.toggleColor);
  });

  testWidgets('default ChildReactionThemeData debugFillProperties',
      (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ChildReactionThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'hoverColor: null',
        'toggleColor: null',
      ],
    );
  });

  testWidgets('default ChildReactionTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const childReactionTheme = ChildReactionTheme(
      data: ChildReactionThemeData(),
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
        'data: ChildReactionThemeData#00000(hoverColor: null, toggleColor: null)',
      ],
    );
  });

  testWidgets('ChildReactionTheme wrap', (tester) async {
    final Key inkWellKey = UniqueKey();
    final Widget childReaction = MaterialApp(home: Scaffold(body: Builder(
      builder: (BuildContext context) {
        return InkWell(
          key: inkWellKey,
          hoverColor: ChildReactionTheme.of(context).hoverColor,
        );
      },
    )));

    late BuildContext navigatorContext;

    MaterialApp buildFrame() {
      return MaterialApp(
        home: Scaffold(
          body: ChildReactionTheme(
            data: const ChildReactionThemeData(
                hoverColor: Colors.red, toggleColor: Colors.red),
            child: Builder(
              builder: (context) {
                navigatorContext = context;

                return ElevatedButton(
                  child: const Text('push wrapped'),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        // Capture the shadow ChildReactionTheme.
                        builder: (BuildContext _) =>
                            InheritedTheme.captureAll(context, childReaction),
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

    // Show the route which contains primaryBox which was wrapped with
    // InheritedTheme.captureAll().
    await tester.tap(find.text('push wrapped'));
    await tester.pumpAndSettle(); // route animation
    expect(inkWellColor(), Colors.red);

    // await tester.tap(tapButton);
    // await tester.pumpAndSettle();

    // expect((tester.firstWidget(find.byType(Container)) as Container).color,
    //     Colors.white);
  });

  testWidgets('ChildReactionTheme updateShouldNotify', (tester) async {
    TestChildReactionTheme? result;
    final builder = Builder(
      builder: (context) {
        result = context
            .dependOnInheritedWidgetOfExactType<TestChildReactionTheme>();
        return Container();
      },
    );

    final first = TestChildReactionTheme(
      shouldNotify: true,
      data: const ChildReactionThemeData(),
      child: builder,
    );

    final second = TestChildReactionTheme(
      shouldNotify: false,
      data: const ChildReactionThemeData(),
      child: builder,
    );

    final third = TestChildReactionTheme(
      shouldNotify: true,
      data: const ChildReactionThemeData(),
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

class TestChildReactionTheme extends ChildReactionTheme {
  const TestChildReactionTheme({
    Key? key,
    required ChildReactionThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant ChildReactionTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
}

const _childReactionThemeDefault = ChildReactionThemeData(
  toggleColor: Colors.lightBlue,
  hoverColor: Colors.lightBlue,
);
const _childReactionThemeMidLerp = ChildReactionThemeData(
  toggleColor: Color(0xff7b7695),
  hoverColor: Color(0xff7b7695),
);
const _childReactionThemeFullLerp = ChildReactionThemeData(
  toggleColor: Colors.red,
  hoverColor: Colors.red,
);
