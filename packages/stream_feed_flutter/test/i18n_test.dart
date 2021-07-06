import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class StreamFeedLocalizations {
  // final Locale locale;

  static final StreamFeedLocalizations _singleton =
      StreamFeedLocalizations._internal();
  StreamFeedLocalizations._internal();
  static StreamFeedLocalizations get instance => _singleton;

  StreamFeedLocalizations(); //this.locale

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static StreamFeedLocalizations of(BuildContext context) {
    return Localizations.of<StreamFeedLocalizations>(
        context, StreamFeedLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<StreamFeedLocalizations> delegate =
      StreamFeedLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<StreamFeedLocalizations> load(Locale locale) async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString(
        'packages/stream_feed_flutter/lib/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    print(_localizedStrings.toString());

    return this;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings[key]!;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an StreamFeedLocalizations object
class StreamFeedLocalizationsDelegate
    extends LocalizationsDelegate<StreamFeedLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const StreamFeedLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<StreamFeedLocalizations> load(Locale locale) async {
    // StreamFeedLocalizations class is where the JSON loading actually runs
    return await StreamFeedLocalizations.instance.load(locale);
  }

  @override
  bool shouldReload(StreamFeedLocalizationsDelegate old) => false;
}

extension LocalisationX on String {
  String get i18n => StreamFeedLocalizations.instance.translate(this);
}

class AppLang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('1 like'.i18n)),
    );
  }
}

main() {
  testWidgets('hey', (tester) async {
    // WidgetsFlutterBinding.ensureInitialized();
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
    final test = find.text("1 J'aime");
    expect(test, findsOneWidget);
  });
}
