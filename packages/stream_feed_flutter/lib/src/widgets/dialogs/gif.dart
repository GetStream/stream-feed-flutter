import 'package:flutter/material.dart';

///{@template gif_action}
///Opens a gif dialog
///{@endtemplate}
class GIFAction extends StatelessWidget {
  /// Builds a [GIFAction].
  const GIFAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue),
      ),
      child: const Icon(
        Icons.gif_outlined, //TODO: svg icons
        color: Colors.blue,
        semanticLabel: 'GIF', //TODO: i18n
      ),
    );
  }
}
