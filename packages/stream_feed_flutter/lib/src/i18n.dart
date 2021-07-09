
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interpolation/interpolation.dart';

class StreamFeedLocalizations {
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
  static LocalizationsDelegate<StreamFeedLocalizations> delegate =
      StreamFeedLocalizationsDelegate(
          interpolation: Interpolation(
              option: InterpolationOption(prefix: '{{', suffix: '}}')));

  late Map<String, String> _localizedStrings;
  late Interpolation _interpolation;

  Future<StreamFeedLocalizations> load(
      {required Interpolation interpolation, required Locale locale}) async {
    // Load the language JSON file from the "lang" folder
    String jsonString = await rootBundle.loadString(
        'packages/stream_feed_flutter/lib/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    _interpolation = interpolation;

    return this;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key, {Map<String, dynamic>? args}) {
    final translation = _localizedStrings[key]!;
    return args != null ? _interpolation.eval(translation, args) : translation;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an StreamFeedLocalizations object
class StreamFeedLocalizationsDelegate
    extends LocalizationsDelegate<StreamFeedLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const StreamFeedLocalizationsDelegate({required this.interpolation});

  final Interpolation interpolation;

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<StreamFeedLocalizations> load(Locale locale) async {
    // StreamFeedLocalizations class is where the JSON loading actually runs
    return SynchronousFuture<StreamFeedLocalizations>(
        await StreamFeedLocalizations.instance
            .load(interpolation: interpolation, locale: locale));
  }

  @override
  bool shouldReload(StreamFeedLocalizationsDelegate old) => false;
}

extension LocalizationX on String {
  String i18n({Map<String, dynamic>? args}) =>
      StreamFeedLocalizations.instance.translate(this, args: args);
}
