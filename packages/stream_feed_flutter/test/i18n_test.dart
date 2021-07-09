import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_feed_flutter/src/i18n.dart';

class AppLang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text('You have {{notificationCount}} new notifications'
              .i18n(args: {
        'notificationCount': 4
      }))), //"You have {{notificationCount}} new notifications": "Vous avez reçu {{notificationCount}} nouvelles notifications",
    );
  }
}

main() {
  testWidgets('StreamFeedLocalizations', (tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await tester.pumpWidget(MaterialApp(
        locale: Locale('fr'),
        supportedLocales: [
          Locale('en'),
          Locale('fr'),
        ],
        localizationsDelegates: [
          StreamFeedLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: AppLang()));
    await tester.pumpAndSettle();
    final test = find.text('Vous avez reçu 4 nouvelles notifications');
    expect(test, findsOneWidget);
  });
}
