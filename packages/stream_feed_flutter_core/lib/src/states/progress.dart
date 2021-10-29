import 'package:flutter/material.dart';

/// {@template onProgressWidget}
/// A builder for building widgets to show on progress
///
/// [ProgressStateWidget] is the default progress indicator to display progress
/// state in [GenericFlatFeedCore]
/// {@endtemplate}
class ProgressStateWidget extends StatelessWidget {
  /// Builds a [ProgressStateWidget].
  /// {@macro onProgressWidget}
  const ProgressStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
