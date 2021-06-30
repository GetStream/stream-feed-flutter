import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/widgets/notification/notification.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

main() {
  group('Notification', () {
    group('Header', () {
        group('repost', () {
        const group = 'repost';
        testWidgets('actorCount < 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 1,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                })
              ]);
          final textFind = find.text('Jordan Belfair reposted your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount == 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 2,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind = find
              .text('Jordan Belfair and Jacky Davidson reposted your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount > 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 12,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind = find
              .text('Jordan Belfair and 11 other people reposted your post');

          expect(textFind, findsOneWidget);
        });
      });
      group('comment', () {
        const group = 'comment';
        testWidgets('actorCount < 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 1,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                })
              ]);
          final textFind = find.text('Jordan Belfair commented your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount == 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 2,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind = find
              .text('Jordan Belfair and Jacky Davidson commented your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount > 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 12,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind = find
              .text('Jordan Belfair and 11 other people commented your post');

          expect(textFind, findsOneWidget);
        });
      });
      group('like', () {
        const group = 'like';
        testWidgets('actorCount < 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 1,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                })
              ]);
          final textFind = find.text('Jordan Belfair liked your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount == 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 2,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind =
              find.text('Jordan Belfair and Jacky Davidson liked your post');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount > 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 12,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind =
              find.text('Jordan Belfair and 11 other people liked your post');

          expect(textFind, findsOneWidget);
        });
      });
      group('follow', () {
        const group = 'follow';
        testWidgets('actorCount < 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 1,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                })
              ]);
          final textFind = find.text('Jordan Belfair followed you');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount == 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 2,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind =
              find.text('Jordan Belfair and Jacky Davidson followed you');

          expect(textFind, findsOneWidget);
        });

        testWidgets('actorCount > 2', (tester) async {
          await buildNotificationHeader(tester,
              actorCount: 12,
              group: group,
              firstUsers: [
                User(data: {
                  'name': 'Jordan Belfair',
                  'profile_image':
                      'https://randomuser.me/api/portraits/women/72.jpg'
                }),
                User(data: {
                  'name': 'Jacky Davidson',
                  'profile_image':
                      'https://randomuser.me/api/portraits/men/72.jpg'
                })
              ]);
          final textFind =
              find.text('Jordan Belfair and 11 other people followed you');

          expect(textFind, findsOneWidget);
        });
      });
    });
  });
}

Future<void> buildNotificationHeader(WidgetTester tester,
    {required int actorCount,
    required List<User> firstUsers,
    required String group}) async {
  return await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: NotificationHeader(
        group: group,
        actorCount: actorCount,
        firstUsers: firstUsers,
      ),
    ),
  ));
}
