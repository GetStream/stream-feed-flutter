/// The type of crop
enum CropType {
  /// crop the top of the image
  top,

  /// crop the bottom of the image
  bottom,

  /// crop the left of the image
  left,

  /// crop the right of the image
  right,

  /// crop the center of the image
  center,
}

extension CropX on CropType {
  String? get name => {
        CropType.top: 'top',
        CropType.bottom: 'bottom',
        CropType.left: 'left',
        CropType.right: 'right',
        CropType.center: 'center',
      }[this];
}

/// Crop an image based on supplied [_width],[_height] and eventually [types]
class Crop {
  /// [Crop] constructor
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

  /// serialize [Crop] params
  Map<String, Object> get params => <String, Object>{
        'crop': _types.map((it) => it.name).join(','),
        'w': _width,
        'h': _height,
      };
}
