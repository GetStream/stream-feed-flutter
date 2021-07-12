import 'package:flutter/material.dart';

/// The default circular progress indicator.
class StreamCircularProgressIndicator extends StatelessWidget {
  const StreamCircularProgressIndicator({
    Key? key,
    this.loadingProgress,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final ImageChunkEvent? loadingProgress;
  @override
  Widget build(BuildContext context) {
    if (loadingProgress == null) return child;
    return Container(
      height: 100.0,
      width: 100.0,
      color: Color(0xFFE9EEF1),
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
