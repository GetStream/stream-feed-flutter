import 'package:stream_feed/src/core/models/crop.dart';
import 'package:stream_feed/src/core/models/resize.dart';

/// Resize an image based on supplied [_width],[_height] and eventually [cropTypes],[resizeType]
class Thumbnail {
  /// [Thumbnail] constructor
  Thumbnail(this._width, this._height,
      {this.resizeType = ResizeType.clip,
      this.cropTypes = const [CropType.center]})
      : assert(_width > 0, 'Width should be a positive number'),
        assert(_height > 0, 'Height should be a positive number');

  final int _width;
  final int _height;
  final ResizeType resizeType;
  final List<CropType> cropTypes;

  /// Serialize params
  Map<String, Object?> get params => <String, Object?>{
        'resize': resizeType.name,
        'crop': cropTypes.map((cropType) => cropType.name).join(','),
        'w': _width,
        'h': _height,
      };
}
