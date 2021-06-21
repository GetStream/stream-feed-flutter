import 'package:flutter/material.dart';

///Opens an emoji dialog
class EmojisAction extends StatelessWidget {
  const EmojisAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.emoji_emotions_outlined, //TODO: svg icons
      color: Colors.blue,
      semanticLabel: 'Emojis', //TODO: i18n
    );
  }
}
