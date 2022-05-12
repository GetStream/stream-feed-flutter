import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('ReactionThemeData copyWith, ==, hashCode basics', () {
    expect(const ReactionThemeData(), const ReactionThemeData().copyWith());
    expect(const ReactionThemeData().hashCode,
        const ReactionThemeData().copyWith().hashCode);
  });

  test('ReactionThemeData lerps halfway', () {
    expect(
        const ReactionThemeData()
            .lerp(_reactionThemeDefault, _reactionThemeFullLerp, 0.5),
        _reactionThemeMidLerp);
  });

  testWidgets('Passing no ReactionTheme results in default values',
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
                child: ReactionButton(
                  activeIcon: StreamSvgIcon.loveActive(),
                  inactiveIcon: StreamSvgIcon.loveInactive(),
                  kind: 'like',
                  reaction: const Reaction(),
                  activity: const GenericEnrichedActivity(),
                ),
              ),
            );
          },
        ),
      ),
    );

    final childReactionThemeData = ReactionTheme.of(_context);
    expect(childReactionThemeData.hoverColor, _reactionThemeDefault.hoverColor);
    expect(childReactionThemeData.toggleHoverColor,
        _reactionThemeDefault.toggleHoverColor);
    expect(childReactionThemeData.iconHoverColor,
        _reactionThemeDefault.iconHoverColor);
  });

  testWidgets('default ReactionThemeData debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const ReactionThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'hoverColor: null',
        'toggleHoverColor: null',
        'iconHoverColor: null',
        'hashtagTextStyle: null',
        'mentionTextStyle: null',
        'normalTextStyle: null',
      ],
    );
  });

  testWidgets('default ReactionTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const reactionTheme = ReactionTheme(
      data: ReactionThemeData(),
      child: SizedBox(),
    );
    reactionTheme.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        '''data: ReactionThemeData#00000(hoverColor: null, toggleHoverColor: null, iconHoverColor: null, hashtagTextStyle: null, mentionTextStyle: null, normalTextStyle: null)''',
      ],
    );
  });

  testWidgets('ReactionTheme wrap', (tester) async {
    final Key inkWellKey = UniqueKey();
    const hoverColor = Colors.red;

    final Widget result = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return InkWell(
              key: inkWellKey,
              hoverColor: ReactionTheme.of(context).hoverColor,
            );
          },
        ),
      ),
    );

    late BuildContext navigatorContext;

    MaterialApp buildFrame() {
      return MaterialApp(
        home: Scaffold(
          body: ReactionTheme(
            data: const ReactionThemeData(
              hoverColor: hoverColor,
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
    }

    Color inkWellColor() {
      return tester.widget<InkWell>(find.byKey(inkWellKey)).hoverColor!;
    }

    await tester.pumpWidget(buildFrame());

    // Show the route which contains InkWell which was wrapped with
    // InheritedTheme.captureAll().
    await tester.tap(find.text('push wrapped'));
    await tester.pumpAndSettle(); // route animation
    expect(inkWellColor(), hoverColor);
  });

  testWidgets('ReactionTheme updateShouldNotify', (tester) async {
    TestReactionTheme? result;
    final builder = Builder(
      builder: (context) {
        result =
            context.dependOnInheritedWidgetOfExactType<TestReactionTheme>();
        return Container();
      },
    );

    final first = TestReactionTheme(
      shouldNotify: true,
      data: const ReactionThemeData(),
      child: builder,
    );

    final second = TestReactionTheme(
      shouldNotify: false,
      data: const ReactionThemeData(),
      child: builder,
    );

    final third = TestReactionTheme(
      shouldNotify: true,
      data: const ReactionThemeData(),
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

class TestReactionTheme extends ReactionTheme {
  const TestReactionTheme({
    Key? key,
    required ReactionThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant ReactionTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
}

const _reactionThemeDefault = ReactionThemeData(
  iconHoverColor: Colors.lightBlue,
  toggleHoverColor: Colors.lightBlue,
  hoverColor: Colors.lightBlue,
);
const _reactionThemeMidLerp = ReactionThemeData(
  iconHoverColor: Color(0xff7b7695),
  toggleHoverColor: Color(0xff7b7695),
  hoverColor: Color(0xff7b7695),
);
const _reactionThemeFullLerp = ReactionThemeData(
  iconHoverColor: Colors.red,
  toggleHoverColor: Colors.red,
  hoverColor: Colors.red,
);
