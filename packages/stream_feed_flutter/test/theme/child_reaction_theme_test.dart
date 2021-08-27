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

  testWidgets('', (widgetTester) async {
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
