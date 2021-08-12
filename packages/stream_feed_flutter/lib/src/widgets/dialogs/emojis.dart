import 'package:flutter/material.dart';

///{@template emojis_action}
/// Opens an emoji dialog
/// {@endtemplate}
class EmojisAction extends StatelessWidget {
  /// Builds an [EmojiDialog].
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
