import 'package:flutter/material.dart';

/// The default circular progress indicator.
class StreamCircularProgressIndicator extends StatelessWidget {
  /// Builds a [StreamCircularProgressIndicator].
  const StreamCircularProgressIndicator({
    Key? key,
    this.loadingProgress,
    required this.child,
  }) : super(key: key);

  /// The child to be displayed inside the circular progress indicator.
  final Widget child;

  /// The progress of the loading process.
  final ImageChunkEvent? loadingProgress;

  @override
  Widget build(BuildContext context) {
    if (loadingProgress == null) return child;
    return Container(
      height: 100,
      width: 100,
      color: const Color(0xFFE9EEF1),
      child: Center(
        child: CircularProgressIndicator(
          //TODO: provide a way to customize progress indicator
          value: loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                  loadingProgress!.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }
}
