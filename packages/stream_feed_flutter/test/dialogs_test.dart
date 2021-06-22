import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

main() {
  group('Actions', () {
    testWidgets('GIFAction', (tester) async {
      await tester.pumpWidget(Material(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: GIFAction(),
      )));

      final gifAction = find.byType(GIFAction);
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
      await tester.pumpWidget(Material(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [LeftActions()]),
      )));

      final mediasAction = find.byType(MediasAction);
      expect(mediasAction, findsOneWidget);

      final emojisAction = find.byType(EmojisAction);
      expect(emojisAction, findsOneWidget);

      final gifAction = find.byType(GIFAction);
      expect(gifAction, findsOneWidget);
    });

    testWidgets('AlertDialog', (tester) async {
      await tester.pumpWidget(Material(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialogActions(
          feedGroup: 'user',
          textEditingController: TextEditingController(),
        ),
      )));
      final leftActions = find.byType(LeftActions);
      expect(leftActions, findsOneWidget);

      final rightActions = find.byType(RightActions);
      expect(rightActions, findsOneWidget);
    });

    group('AlertDialog', () {
      testWidgets('Comment', (tester) async {
        await mockNetworkImages(() async {
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: AlertDialogComment(
                feedGroup: 'user',
                activity: EnrichedActivity(
                  time: DateTime.now(),
                  actor: EnrichableField(
                    User(data: {
                      'name': 'Rosemary',
                      'handle': '@rosemary',
                      'subtitle': 'likes playing fresbee in the park',
                      'profile_image':
                          'https://randomuser.me/api/portraits/women/20.jpg',
                    }).toJson(),
                  ),
                ),
              ),
            ),
          ));
          final alertDialogActions = find.byType(AlertDialogActions);
          expect(alertDialogActions, findsOneWidget);

          final commentView = find.byType(CommentView);
          expect(commentView, findsOneWidget);
        });
      });

      group('CommentView', () {
        testWidgets('with an activity', (tester) async {
          await mockNetworkImages(() async {
            await tester.pumpWidget(MaterialApp(
              home: Scaffold(
                body: CommentView(
                  feedGroup: 'user',
                  activity: EnrichedActivity(
                    time: DateTime.now(),
                    actor: EnrichableField(
                      User(data: {
                        'name': 'Rosemary',
                        'handle': '@rosemary',
                        'subtitle': 'likes playing fresbee in the park',
                        'profile_image':
                            'https://randomuser.me/api/portraits/women/20.jpg',
                      }).toJson(),
                    ),
                  ),
                  textEditingController: TextEditingController(),
                ),
              ),
            ));
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
            await tester.pumpWidget(MaterialApp(
              home: Scaffold(
                body: CommentView(
                  feedGroup: 'user',
                  textEditingController: TextEditingController(),
                ),
              ),
            ));

            final commentField = find.byType(CommentField);
            expect(commentField, findsOneWidget);
          });
        });
      });
    });
  });
}
