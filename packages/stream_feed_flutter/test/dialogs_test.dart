import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

void main() {
  group('Actions', () {
    testWidgets('EmojisAction', (tester) async {
      await tester.pumpWidget(
        StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: const Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: EmojisAction(),
            ),
          ),
        ),
      );

      final mediasAction = find.byIcon(Icons.emoji_emotions_outlined);
      expect(mediasAction, findsOneWidget);
    });
    testWidgets('MediasAction', (tester) async {
      await tester.pumpWidget(
        const Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediasAction(),
          ),
        ),
      );

      final mediasAction = find.byIcon(Icons.collections_outlined);
      expect(mediasAction, findsOneWidget);
    });
    testWidgets('GIFAction', (tester) async {
      await tester.pumpWidget(
        StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: const Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: GIFAction(),
            ),
          ),
        ),
      );

      final gifAction = find.byIcon(Icons.gif_outlined);
      expect(gifAction, findsOneWidget);
    });

    testWidgets('Right', (tester) async {
      await tester.pumpWidget(Material(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: RightActions(
          feedGroup: 'user',
          textEditingController: TextEditingController(),
        ),
      )));

      final postCommentButton = find.byType(PostCommentButton);
      expect(postCommentButton, findsOneWidget);
    });

    testWidgets('Left', (tester) async {
      await tester.pumpWidget(
        StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
                children: const [
                  LeftActions(),
                ],
              ),
            ),
          ),
        ),
      );

      final mediasAction = find.byType(MediasAction);
      expect(mediasAction, findsOneWidget);

      final emojisAction = find.byType(EmojisAction);
      expect(emojisAction, findsOneWidget);

      final gifAction = find.byType(GIFAction);
      expect(gifAction, findsOneWidget);
    });

    testWidgets('AlertDialog', (tester) async {
      await tester.pumpWidget(
        StreamFeedTheme(
          data: StreamFeedThemeData.light(),
          child: Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: AlertDialogActions(
                feedGroup: 'user',
                textEditingController: TextEditingController(),
              ),
            ),
          ),
        ),
      );
      final leftActions = find.byType(LeftActions);
      expect(leftActions, findsOneWidget);

      final rightActions = find.byType(RightActions);
      expect(rightActions, findsOneWidget);
    });

    group('AlertDialog', () {
      testWidgets('Comment', (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              builder: (context, child) {
                return StreamFeedTheme(
                  data: StreamFeedThemeData.light(),
                  child: child!,
                );
              },
              home: Scaffold(
                body: AlertDialogComment(
                  feedGroup: 'user',
                  activity: EnrichedActivity(
                    time: DateTime.now(),
                    actor: const User(
                      id: 'user-id',
                      data: {
                        'name': 'Rosemary',
                        'handle': '@rosemary',
                        'subtitle': 'likes playing fresbee in the park',
                        'profile_image':
                            'https://randomuser.me/api/portraits/women/20.jpg',
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
          final alertDialogActions = find.byType(AlertDialogActions);
          expect(alertDialogActions, findsOneWidget);

          final commentView = find.byType(CommentView);
          expect(commentView, findsOneWidget);
        });
      });

      group('CommentView', () {
        testWidgets('with an activity', (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                builder: (context, child) {
                  return StreamFeedTheme(
                    data: StreamFeedThemeData.light(),
                    child: child!,
                  );
                },
                home: Scaffold(
                  body: CommentView(
                    activity: EnrichedActivity(
                      time: DateTime.now(),
                      actor: const User(
                        id: 'user-id',
                        data: {
                          'name': 'Rosemary',
                          'handle': '@rosemary',
                          'subtitle': 'likes playing fresbee in the park',
                          'profile_image':
                              'https://randomuser.me/api/portraits/women/20.jpg',
                        },
                      ),
                    ),
                    textEditingController: TextEditingController(),
                  ),
                ),
              ),
            );
            final activityHeader = find.byType(ActivityHeader);
            expect(activityHeader, findsOneWidget);

            final activityContent = find.byType(ActivityContent);
            expect(activityContent, findsOneWidget);

            final commentField = find.byType(CommentField);
            expect(commentField, findsOneWidget);
          });
        });

        testWidgets('without an activity', (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(
              MaterialApp(
                builder: (context, child) {
                  return StreamFeedTheme(
                    data: StreamFeedThemeData.light(),
                    child: child!,
                  );
                },
                home: Scaffold(
                  body: CommentView(
                    textEditingController: TextEditingController(),
                  ),
                ),
              ),
            );

            final commentField = find.byType(CommentField);
            expect(commentField, findsOneWidget);
          });
        });
      });
    });
  });

  group('debugFillProperties', () {
    testWidgets('AlertDialogComment', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const AlertDialogComment(
        feedGroup: 'user',
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '"user"');
    });

    testWidgets('CommentView', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      CommentView(
        textEditingController: TextEditingController(),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });

    testWidgets('AlertDialogActions', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      final now = DateTime.now();
      AlertDialogActions(
        feedGroup: 'user',
        textEditingController: TextEditingController(),
        activity: EnrichedActivity(
          time: now,
          actor: const User(
            id: 'user-id',
            data: {
              'name': 'Rosemary',
              'handle': '@rosemary',
              'subtitle': 'likes playing frisbee in the park',
              'profile_image':
                  'https://randomuser.me/api/portraits/women/20.jpg',
            },
          ),
          extraData: const {
            'image':
                'https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg',
          },
        ),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'EnrichedActivity<dynamic, dynamic, dynamic, dynamic>(User(user-id, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, null, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
    });

    testWidgets('LeftActions', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const LeftActions().debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '60.0');
    });

    testWidgets('RightActions', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      RightActions(
        feedGroup: 'user',
        textEditingController: TextEditingController(),
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });
  });
}
