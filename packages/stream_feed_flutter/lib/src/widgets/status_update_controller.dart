import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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
