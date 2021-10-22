import 'package:flutter/widgets.dart';
import 'package:stream_feed_flutter_core/src/activities_bloc.dart';

bool debugCheckHasFeedBlocProvider(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<GenericFeedBlocProvider>() ==
        null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No FeedBlocProvider widget found.'),
        ErrorDescription(
          '${context.widget.runtimeType} widgets require a FeedBlocProvider '
          'widget ancestor.\n'
          'In FeedBlocProvider design, most widgets are conceptually "printed" on '
          "a sheet of FeedBlocProvider. In Flutter's FeedBlocProvider library, that "
          'FeedBlocProvider is represented by the FeedBlocProvider widget. It is the '
          'FeedBlocProvider widget that renders ink splashes, for instance. '
          'Because of this, many FeedBlocProvider library widgets require that '
          'there be a FeedBlocProvider widget in the tree above them.',
        ),
        ErrorHint(
            'To introduce a FeedBlocProvider widget, you can either directly '
            'FeedBlocProvider('
            'bloc: FeedBloc('
            'client: mockClient,'
            ' ),'
            'child: FlatActivityListPage('
            " feedGroup: 'user',"
            ' ))'),
        ...context.describeMissingAncestor(
            expectedAncestorType: GenericFeedBlocProvider),
      ]);
    }
    return true;
  }());
  return true;
}
