import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template onEmptyWidget}
/// A default widget to be displayed for empty state builders.
/// {@endtemplate}
class EmptyStateWidget extends StatelessWidget {
  /// Builds an [EmptyStateWidget].
  ///
  /// {@macro onEmptyWidget}
  const EmptyStateWidget({
    Key? key,
    this.message = 'Nothing here...',
  }) : super(key: key);

  /// The message to be displayed
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}
