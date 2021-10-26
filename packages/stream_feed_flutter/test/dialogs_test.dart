// ignore_for_file: cascade_invocations

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter/src/widgets/activity/content.dart';
import 'package:stream_feed_flutter/src/widgets/activity/header.dart';
import 'package:stream_feed_flutter/src/widgets/comment/button.dart';
import 'package:stream_feed_flutter/src/widgets/comment/field.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/delete_activity_dialog.dart';
import 'package:stream_feed_flutter/src/widgets/dialogs/dialogs.dart';
import 'package:stream_feed_flutter/src/widgets/stream_feed_app.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

import 'mock.dart';

void main() {
  late MockStreamUser mockUser;
  late MockFeedBloc<User, String, String, String> mockFeedBloc;

  setUpAll(() {
    mockFeedBloc = MockFeedBloc();
    mockUser = MockStreamUser();
    when(() => mockFeedBloc.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('1');
    when(() => mockFeedBloc.getActivitiesStream('user')).thenAnswer(
        (_) => Stream.value(const [GenericEnrichedActivity(actor: User())]));
  });

  group('Actions', () {
    testWidgets('EmojisAction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamFeed(
              bloc: mockFeedBloc,
              themeData: StreamFeedThemeData.light(),
              child: child!,
            );
          },
          home: Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: EmojisAction(
                key: UniqueKey(),
              ),
            ),
          ),
        ),
      );

      final mediasAction = find.byIcon(Icons.emoji_emotions_outlined);
      expect(mediasAction, findsOneWidget);
    });
    testWidgets('MediasAction', (tester) async {
      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediasAction(
              key: UniqueKey(),
            ),
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
          child: Material(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: GIFAction(
                key: UniqueKey(),
              ),
            ),
          ),
        ),
      );

      final gifAction = find.byIcon(Icons.gif_outlined);
      expect(gifAction, findsOneWidget);
    });

    testWidgets('Right', (tester) async {
      await tester.pumpWidget(
        Material(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RightActions(
              feedGroup: 'user',
              textEditingController: TextEditingController(),
            ),
          ),
        ),
      );

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
                children: [
                  LeftActions(
                    key: UniqueKey(),
                  ),
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
                return StreamFeed(
                  bloc: mockFeedBloc,
                  child: child!,
                );
              },
              home: Scaffold(
                body: AlertDialogComment(
                  feedGroup: 'user',
                  activity: EnrichedActivity(
                    id: '1',
                    time: DateTime.now(),
                    actor: const User(
                      id: '1',
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
                  return StreamFeed(
                    bloc: mockFeedBloc,
                    child: child!,
                  );
                },
                home: Scaffold(
                  body: CommentView(
                    activity: GenericEnrichedActivity(
                      id: '1',
                      time: DateTime.now(),
                      actor: const User(data: {
                        'name': 'Rosemary',
                        'handle': '@rosemary',
                        'subtitle': 'likes playing fresbee in the park',
                        'profile_image':
                        'https://randomuser.me/api/portraits/women/20.jpg',
                      }),
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
                  return StreamFeed(
                    bloc: mockFeedBloc,
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
      const alertDialogComment = AlertDialogComment(
        feedGroup: 'user',
      );

      alertDialogComment.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '"user"');
    });

    testWidgets('CommentView', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      final commentView = CommentView(
        textEditingController: TextEditingController(),
      );

      commentView.debugFillProperties(builder);

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
      final alertDialogActions = AlertDialogActions(
        feedGroup: 'user',
        textEditingController: TextEditingController(),
        activity: GenericEnrichedActivity(
          time: now,
          actor: const User(
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
      );

      alertDialogActions.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'],
          'GenericEnrichedActivity<User, String, String, String>(User(null, {name: Rosemary, handle: @rosemary, subtitle: likes playing frisbee in the park, profile_image: https://randomuser.me/api/portraits/women/20.jpg}, null, null, null, null), null, null, null, null, null, null, ${now.toString()}, null, null, null, null, {image: https://handluggageonly.co.uk/wp-content/uploads/2017/08/IMG_0777.jpg}, null, null, null)');
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
      final rightActions = RightActions(
        feedGroup: 'user',
        textEditingController: TextEditingController(),
      );

      rightActions.debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], 'null');
    });
  });

  group('Delete Activity Dialog', () {
    testWidgets('Open the dialog and make sure all components are there',
        (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              return StreamFeed(
                bloc: mockFeedBloc,
                themeData: StreamFeedThemeData.light(),
                child: child!,
              );
            },
            home: Scaffold(
              body: ActivityHeader(
                feedGroup: 'timeline',
                activity: GenericEnrichedActivity(
                  id: '1',
                  time: DateTime.now(),
                  actor: const User(
                    id: '1',
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

        final popupMenuButton = find.byIcon(Icons.more_vert);
        expect(popupMenuButton, findsOneWidget);

        await tester.tap(popupMenuButton);
        await tester.pumpAndSettle();

        final deleteButton = find.text('Delete');
        expect(deleteButton, findsOneWidget);

        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        final deleteDialog = find.byType(AlertDialog);
        expect(deleteDialog, findsOneWidget);

        final yesButton = find.text('Yes');
        expect(yesButton, findsOneWidget);

        final noButton = find.text('No');
        expect(noButton, findsOneWidget);
      });
    });

    testWidgets('Open the dialog and tap "no"', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) {
              return StreamFeed(
                bloc: mockFeedBloc,
                themeData: StreamFeedThemeData.light(),
                child: child!,
              );
            },
            home: Scaffold(
              body: ActivityHeader(
                feedGroup: 'timeline',
                activity: GenericEnrichedActivity(
                  id: '1',
                  time: DateTime.now(),
                  actor: const User(
                    id: '1',
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

        final popupMenuButton = find.byIcon(Icons.more_vert);
        expect(popupMenuButton, findsOneWidget);

        await tester.tap(popupMenuButton);
        await tester.pumpAndSettle();

        final deleteButton = find.text('Delete');
        expect(deleteButton, findsOneWidget);

        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        final deleteDialog = find.byType(AlertDialog);
        expect(deleteDialog, findsOneWidget);

        final yesButton = find.text('Yes');
        expect(yesButton, findsOneWidget);

        final noButton = find.text('No');
        expect(noButton, findsOneWidget);

        await tester.tap(noButton);
        await tester.pumpAndSettle();
      });
    });

    testWidgets('Open the dialog and tap "yes"', (tester) async {
      const activityId = '1';
      const feedGroup = 'timeline';
      final mockClient = MockStreamFeedClient();
      final mockFeed = MockFlatFeed();
      when(() => mockClient.flatFeed(feedGroup)).thenReturn(mockFeed);
      when(() => mockFeed.removeActivityById(activityId))
          .thenAnswer((_) async => Future.value());

      await tester.pumpWidget(MaterialApp(
        builder: (context, child) =>
            StreamFeed(bloc: FeedBloc(client: mockClient), child: child!),
        home: const Scaffold(
          body: DeleteActivityDialog(
            activityId: activityId,
            feedGroup: feedGroup,
          ),
        ),
      ));

      final deleteDialog = find.byType(AlertDialog);
      expect(deleteDialog, findsOneWidget);

      final yesButton = find.text('Yes');
      expect(yesButton, findsOneWidget);

      final noButton = find.text('No');
      expect(noButton, findsOneWidget);

      await tester.tap(yesButton);
      await tester.pumpAndSettle();

      verify(() => mockClient.flatFeed(feedGroup)).called(1);
      verify(() => mockFeed.removeActivityById(activityId)).called(1);
    });

    testWidgets('debugFillProperties', (tester) async {
      final builder = DiagnosticPropertiesBuilder();
      const DeleteActivityDialog(
        activityId: '1',
        feedGroup: 'timeline',
      ).debugFillProperties(builder);

      final description = builder.properties
          .where((node) => !node.isFiltered(DiagnosticLevel.info))
          .map((node) =>
              node.toJsonMap(const DiagnosticsSerializationDelegate()))
          .toList();

      expect(description[0]['description'], '"1"');
    });
  });
}
