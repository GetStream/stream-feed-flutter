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
                  activity: const EnrichedActivity(),
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
