import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_feed_flutter_core/stream_feed_flutter_core.dart';

///{@template medias_action}
///Opens file explorer to select a media file.
///{@endtemplate}
class MediasAction extends StatelessWidget {
  ///{@macro medias_action}
  const MediasAction({
    required this.statusUpdateFormController,
    Key? key,
  }) : super(key: key);
  final StatusUpdateFormController statusUpdateFormController;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.collections_outlined, //TODO: svg icons
        color: Colors.blue,
        semanticLabel: 'Medias', //TODO: i18n
      ),
      onPressed: () async {
        // Pick an image
        await statusUpdateFormController.pickImage(source: ImageSource.gallery);
      },
    );
  }
}

class StatusUpdateFormController extends ChangeNotifier {
  StatusUpdateFormController(this._picker);
  final ImagePicker _picker;
  late String? lastPickedImage;

  Future<void> pickImage({required ImageSource source}) async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final imageURI = xFile.path;
      lastPickedImage = imageURI;
    }
    notifyListeners();
  }
}
