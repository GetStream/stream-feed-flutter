import 'package:flutter/material.dart';

///{@template medias_action}
///Opens file explorer to select a media file.
///{@endtemplate}
class MediasAction extends StatelessWidget {
  ///{@macro medias_action}
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
