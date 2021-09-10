//TODO: improve this
import 'package:flutter/material.dart';

///The default progress indicator to display progress state
class ProgressStateWidget extends StatelessWidget {
  /// Builds a [ProgressStateWidget].
  const ProgressStateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
