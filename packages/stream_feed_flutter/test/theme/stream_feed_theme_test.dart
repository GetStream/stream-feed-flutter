import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

void main() {
  group('StreamFeedTheme tests', () {
    testWidgets('Default dark theme has Brightness.dark', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeedTheme(
              data: StreamFeedThemeData.dark(),
              child: child!,
            );
          },
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      final streamTheme = StreamFeedTheme.of(capturedContext);
      expect(streamTheme.brightness, Brightness.dark);
    });

    testWidgets('default StreamFeedThemeData debugFillProperties',
        (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const StreamFeedThemeData.raw(
        brightness: Brightness.light,
        childReactionTheme: ChildReactionThemeData(),
        galleryHeaderTheme: GalleryHeaderThemeData(),
        gifDialogTheme: GifDialogThemeData(),
        ogCardTheme: OgCardThemeData(),
        primaryIconTheme: IconThemeData(),
        reactionTheme: ReactionThemeData(),
        userBarTheme: UserBarThemeData(),
      ).debugFillProperties(builder);
      //StreamFeedThemeData().debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) => node.toString())
          .toList();

      expect(
        description,
        <String>[
          'childReactionTheme: ChildReactionThemeData#00000(hoverColor: null, toggleColor: null)',
          'reactionTheme: ReactionThemeData#00000(hoverColor: null, toggleHoverColor: null, iconHoverColor: null, hashtagTextStyle: null, mentionTextStyle: null, normalTextStyle: null)',
          'brightness: light',
          'primaryIconTheme: IconThemeData#00785',
          'gifDialogTheme: GifDialogThemeData#00000(boxDecoration: null, iconColor: null)',
          'ogCardTheme: OgCardThemeData#00000(titleTextStyle: null, descriptionTextStyle: null)',
          'userBarTheme: UserBarThemeData#007db(avatarSize: null, usernameTextStyle: null, timestampTextStyle: null)',
          'galleryHeaderTheme: GalleryHeaderThemeData#007db(closeButtonColor: null, backgroundColor: null, titleTextStyle: null)'
        ],
      );
    });

    testWidgets('StreamFeedTheme is null', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      expect(() => StreamFeedTheme.of(capturedContext), throwsAssertionError);
    });

    testWidgets('StreamFeedTheme updateShouldNotify', (tester) async {
      TestStreamFeedTheme? result;
      final builder = Builder(
        builder: (context) {
          result =
              context.dependOnInheritedWidgetOfExactType<TestStreamFeedTheme>();
          return Container();
        },
      );

      final first = TestStreamFeedTheme(
        shouldNotify: true,
        data: StreamFeedThemeData.light(),
        child: builder,
      );

      final second = TestStreamFeedTheme(
        shouldNotify: false,
        data: StreamFeedThemeData.light(),
        child: builder,
      );

      final third = TestStreamFeedTheme(
        shouldNotify: true,
        data: StreamFeedThemeData.light(),
        child: builder,
      );

      await tester.pumpWidget(first);
      expect(result, equals(first));

      await tester.pumpWidget(second);
      expect(result, equals(first));

      await tester.pumpWidget(third);
      expect(result, equals(third));
    });
  });
}

class TestStreamFeedTheme extends StreamFeedTheme {
  const TestStreamFeedTheme({
    Key? key,
    required StreamFeedThemeData data,
    required Widget child,
    required this.shouldNotify,
  }) : super(key: key, data: data, child: child);

  // ignore: diagnostic_describe_all_properties
  final bool shouldNotify;

  @override
  bool updateShouldNotify(covariant StreamFeedTheme oldWidget) {
    super.updateShouldNotify(oldWidget);
    return shouldNotify;
  }
}
