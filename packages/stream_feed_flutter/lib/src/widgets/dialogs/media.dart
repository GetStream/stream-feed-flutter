import 'package:flutter/material.dart';

///Opens file explorer
class MediasAction extends StatelessWidget {
  const MediasAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.collections_outlined, //TODO: svg icons
      color: Colors.blue,
      semanticLabel: 'Medias', //TODO: i18n
    );
  }
}
