import 'package:flutter/material.dart';

/// {@template onProgressWidget}
/// A default loading widget to display for loading builders.
/// {@endtemplate}
class LoadingStateWidget extends StatelessWidget {
  /// Builds a [LoadingStateWidget].
  ///
  /// {@macro onProgressWidget}
  const LoadingStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
