import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/stream_feed_theme.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

class StreamFeed extends StatelessWidget {
  StreamFeed({
    Key? key,
    required this.bloc,
    required this.child,
    StreamFeedThemeData? themeData,
  })  : _themeData = themeData ?? StreamFeedThemeData.light(),
        super(key: key);

  final FeedBloc bloc;
  final Widget child;
  final StreamFeedThemeData _themeData;

  @override
  Widget build(BuildContext context) {
    return FeedProvider(
      bloc: bloc,
      child: StreamFeedTheme(
        data: _themeData,
        child: child,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FeedBloc>('bloc', bloc));
  }
}
