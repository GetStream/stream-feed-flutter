/// The type of resize
enum ResizeType {
  /// resize by clipping the image
  clip,

  /// resize by cropping the image
  crop,

  /// resize by scaling the image
  scale,

  /// resize by filling the image
  fill,
}

/// Extensions for [ResizeType].
extension ResizeX on ResizeType {
  /// Gets the [ResizeType] as a String.
  String get name => {
        ResizeType.clip: 'clip',
        ResizeType.crop: 'crop',
        ResizeType.scale: 'scale',
        ResizeType.fill: 'fill',
      }[this]!;
}

/// Resize an image based on supplied [_width],[_height] and eventually [_type]
class Resize {
  /// [Resize] constructor
  const Resize(
    this._width,
    this._height, {
    ResizeType type = ResizeType.clip,
  })  : assert(_width > 0, 'Width should be a positive number'),
        assert(_height > 0, 'Height should be a positive number'),
        _type = type;

  final int _width;
  final int _height;
  final ResizeType _type;

  /// Serialize params
  Map<String, Object?> get params => <String, Object?>{
        'resize': _type.name,
        'w': _width,
        'h': _height,
      };
}
