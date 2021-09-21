
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class StreamFeedApp extends StatelessWidget {
  const StreamFeedApp({Key? key, required this.bloc, required this.widget})
      : super(key: key);

  final FeedBloc bloc;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return FeedBlocProvider(
            bloc: bloc,
            child: StreamFeedTheme(
              data: StreamFeedThemeData.light(),
              child: child!,
            ),
          );
        },
        home: widget);
  }
}