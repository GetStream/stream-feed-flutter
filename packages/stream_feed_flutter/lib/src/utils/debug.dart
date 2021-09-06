import 'package:flutter/widgets.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';


bool debugCheckHasActivitiesProvider(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<ActivitiesProvider>() == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No ActivitiesProvider widget found.'),
        ErrorDescription(
          '${context.widget.runtimeType} widgets require a ActivitiesProvider '
          'widget ancestor.\n'
          'In ActivitiesProvider design, most widgets are conceptually "printed" on '
          "a sheet of ActivitiesProvider. In Flutter's ActivitiesProvider library, that "
          'ActivitiesProvider is represented by the ActivitiesProvider widget. It is the '
          'ActivitiesProvider widget that renders ink splashes, for instance. '
          'Because of this, many ActivitiesProvider library widgets require that '
          'there be a ActivitiesProvider widget in the tree above them.',
        ),
        ErrorHint(
          'To introduce a ActivitiesProvider widget, you can either directly '
          'include one, or use a widget that contains ActivitiesProvider itself'
        ),
        ...context.describeMissingAncestor(
            expectedAncestorType: ActivitiesProvider),
      ]);
    }
    return true;
  }());
  return true;
}


bool debugCheckHasReactionsProvider(BuildContext context) {
  assert(() {
    if (context.findAncestorWidgetOfExactType<ReactionsProvider>() == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No ReactionsProvider widget found.'),
        ErrorDescription(
          '${context.widget.runtimeType} widgets require a ReactionsProvider '
          'widget ancestor.\n'
          'In ReactionsProvider design, most widgets are conceptually "printed" on '
          "a sheet of ReactionsProvider. In Flutter's ReactionsProvider library, that "
          'ReactionsProvider is represented by the ReactionsProvider widget. It is the '
          'ReactionsProvider widget that renders ink splashes, for instance. '
          'Because of this, many ReactionsProvider library widgets require that '
          'there be a ReactionsProvider widget in the tree above them.',
        ),
        ErrorHint(
          'To introduce a ReactionsProvider widget, you can either directly '
          'include one, or use a widget that contains ReactionsProvider itself'
        ),
        ...context.describeMissingAncestor(
            expectedAncestorType: ReactionsProvider),
      ]);
    }
    return true;
  }());
  return true;
}

