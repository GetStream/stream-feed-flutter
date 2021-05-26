import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/textarea.dart';
import 'package:stream_feed_flutter/stream_feed_flutter.dart';

class CommentField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar(),
            ),
            Expanded(child: TextArea(onSubmitted: (value) {})),
          ],
        ),
        Button(label: 'Post', onPressed: () {}, type: ButtonType.faded)
      ],
    );
  }
}
