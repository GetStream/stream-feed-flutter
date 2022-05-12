import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  test('UserBarThemeData copyWith, ==, hashCode basics', () {
    expect(const UserBarThemeData(), const UserBarThemeData().copyWith());
    expect(const UserBarThemeData().hashCode,
        const UserBarThemeData().copyWith().hashCode);
  });

  test('UserBarThemeData lerps halfway', () {
    expect(
        const UserBarThemeData()
            .lerp(_userBarThemeDefault, _userBarThemeFullLerp, 0.5),
        _userBarThemeHalfLerp);
  });

  testWidgets('default UserBarThemeData debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const UserBarThemeData().debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        'avatarSize: null',
        'usernameTextStyle: null',
        'timestampTextStyle: null',
      ],
    );
  });

  testWidgets('default UserBarTheme debugFillProperties', (tester) async {
    final builder = DiagnosticPropertiesBuilder();
    const userBarTheme = UserBarTheme(
      data: UserBarThemeData(),
      child: SizedBox(),
    );
    userBarTheme.debugFillProperties(builder);

    final description = builder.properties
        .where((node) => !node.isFiltered(DiagnosticLevel.info))
        .map((node) => node.toString())
        .toList();

    expect(
      description,
      [
        '''data: UserBarThemeData#007db(avatarSize: null, usernameTextStyle: null, timestampTextStyle: null)''',
      ],
    );
  });

  testWidgets('UserBarTheme wrap', (tester) async {
    final Key inkWellKey = UniqueKey();
    const usernameTextStyle = TextStyle(color: Colors.red);

    final Widget result = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return InkWell(
              key: inkWellKey,
              hoverColor: UserBarTheme.of(context).usernameTextStyle!.color,
            );
          },
        ),
      ),
    );

    MaterialApp buildFrame() {
      return MaterialApp(
        home: Scaffold(
          body: UserBarTheme(
            data: const UserBarThemeData(
              usernameTextStyle: usernameTextStyle,
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
    expect(inkWellColor(), usernameTextStyle.color);
  });

  testWidgets('UserBarTheme updateShouldNotify', (tester) async {
    TestUserBarTheme? result;
    final builder = Builder(
      builder: (context) {
        result = context.dependOnInheritedWidgetOfExactType<TestUserBarTheme>();
        return Container();
      },
    );

    final first = TestUserBarTheme(
      shouldNotify: true,
      data: const UserBarThemeData(),
      child: builder,
    );

    final second = TestUserBarTheme(
      shouldNotify: false,
      data: const UserBarThemeData(),
      child: builder,
    );

    final third = TestUserBarTheme(
      shouldNotify: true,
      data: const UserBarThemeData(),
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

class TestUserBarTheme extends UserBarTheme {
  const TestUserBarTheme({
    Key? key,
    required UserBarThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant UserBarTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
}

const _userBarThemeDefault = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Color(0xff0ba8e0),
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Color(0xff7a8287),
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);

const _userBarThemeHalfLerp = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Color(0xff7f758b),
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Color(0xff8c9092),
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);

const _userBarThemeFullLerp = UserBarThemeData(
  usernameTextStyle: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  ),
  timestampTextStyle: TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontSize: 14,
  ),
  avatarSize: 46,
);
