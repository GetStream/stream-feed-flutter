import 'package:stream_feed/src/core/models/crop.dart';
import 'package:stream_feed/src/core/models/resize.dart';

/// Create a Thumbnail of an image based on supplied [_width],[_height]
/// and eventually [cropTypes] and [resizeType]
class Thumbnail {
  /// [Thumbnail] constructor
  const Thumbnail(this._width, this._height,
      {this.resizeType = ResizeType.clip,
      this.cropTypes = const [CropType.center]})
      : assert(_width > 0, 'Width should be a positive number'),
        assert(_height > 0, 'Height should be a positive number');

  final int _width;
  final int _height;

  /// Type of resizing to be applied to the image
  final ResizeType resizeType;

  /// Types of cropping to be applied to the image
  final List<CropType> cropTypes;

  /// Serialize params
  Map<String, Object?> get params => <String, Object?>{
        'resize': resizeType.name,
        'crop': cropTypes.map((cropType) => cropType.name).join(','),
        'w': _width,
        'h': _height,
      };
}
