import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///An Empty State Widget to be used for empty states
class EmptyStateWidget extends StatelessWidget {
  /// Builds an [EmptyStateWidget].
  const EmptyStateWidget({
    Key? key,
    this.message = 'Nothing here...',
  }) : super(key: key);

  ///The message to be displayed
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
