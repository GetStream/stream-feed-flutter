import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class StreamFeedApp extends StatelessWidget {
  const StreamFeedApp(
      {Key? key, required this.bloc, required this.home, this.navigatorKey})
      : super(key: key);

  final FeedBloc bloc;
  final Widget home;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return FeedBlocProvider(
            navigatorKey: navigatorKey,
            bloc: bloc,
            child: StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
          );
        },
        home: home);
  }
}
