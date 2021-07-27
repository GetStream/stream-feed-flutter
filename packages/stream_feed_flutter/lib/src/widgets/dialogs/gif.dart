import 'package:flutter/material.dart';

///Opens a gif dialog
class GIFAction extends StatelessWidget {
  const GIFAction({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: Colors.blue)),
        child: Icon(
          Icons.gif_outlined, //TODO: svg icons
          color: Colors.blue,
          semanticLabel: 'GIF', //TODO: i18n
        ));
  }
}
