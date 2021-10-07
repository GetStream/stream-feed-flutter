import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class StreamFeedApp extends StatelessWidget {
  StreamFeedApp(
      {Key? key,
      required this.bloc,
      required this.home,
      this.navigatorKey,
      this.debugShowCheckedModeBanner = false,
      StreamFeedThemeData? themeData})
      : _themeData = themeData ?? StreamFeedThemeData.light(),
        super(key: key);

  final DefaultFeedBloc bloc;
  final Widget home;
  final GlobalKey<NavigatorState>? navigatorKey;
  late StreamFeedThemeData _themeData;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return DefaultFeedBlocProvider(
            navigatorKey: navigatorKey,
            bloc: bloc,
            child: StreamFeedTheme(
              data: _themeData, //TODO: provide a way to override theme
              child: child!,
            ),
          );
        },
        home: home);
  }
}
