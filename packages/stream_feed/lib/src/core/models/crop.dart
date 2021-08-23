/// The type of crop
enum CropType {
  /// Crop the top of the image
  top,

  /// Crop the bottom of the image
  bottom,

  /// Crop the left of the image
  left,

  /// Crop the right of the image
  right,

  /// Crop the center of the image
  center,
}

/// Extensions for [CropType].
extension CropX on CropType {
  /// Gets the crop type as a String.
  String? get name => {
        CropType.top: 'top',
        CropType.bottom: 'bottom',
        CropType.left: 'left',
        CropType.right: 'right',
        CropType.center: 'center',
      }[this];
}

/// Crops an image based on supplied [_width],[_height] and eventually [types]
class Crop {
  /// Builds a [Crop].
  const Crop(
    this._width,
    this._height, {
    List<CropType> types = const [CropType.center],
  })  : assert(_width > 0, 'Width should be a positive number'),
        assert(_height > 0, 'Height should be a positive number'),
        _types = types;

  final int _width;
  final int _height;
  final List<CropType> _types;

  /// Serialize [Crop] params
  Map<String, Object> get params => <String, Object>{
        'crop': _types.map((it) => it.name).join(','),
        'w': _width,
        'h': _height,
      };
}
