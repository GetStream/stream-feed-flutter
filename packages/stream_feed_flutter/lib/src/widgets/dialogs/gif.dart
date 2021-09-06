import 'package:flutter/material.dart';
import 'package:stream_feed_flutter/src/theme/gif_dialog_theme.dart';

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
      decoration: GifDialogTheme.of(context).boxDecoration,
      child: Icon(
        Icons.gif_outlined, //TODO: svg icons
        color: GifDialogTheme.of(context).iconColor,
        semanticLabel: 'GIF', //TODO: i18n
      ),
    );
  }
}
