import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template onErrorWidget}
/// A default widget to display for error builders.
/// {@endtemplate}

class ErrorStateWidget extends StatelessWidget {
  /// Builds an [ErrorStateWidget].
  ///
  /// {@macro onErrorWidget}
  const ErrorStateWidget({
    Key? key,
    this.message = 'Sorry an error has occured',
  }) : super(key: key);

  /// The error message to display
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.announcement,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message));
  }
}
