enum CropType {
  top,
  bottom,
  left,
  right,
  center,
}

extension _CropX on CropType {
  String get name => {
        CropType.top: 'top',
        CropType.bottom: 'bottom',
        CropType.left: 'left',
        CropType.right: 'right',
        CropType.center: 'center',
      }[this];
}

///
class Crop {
  ///
  const Crop(
    this._width,
    this._height, {
    List<CropType> types = const [CropType.center],
  })  : assert(types != null, 'Missing crop type'),
        assert(_width > 0, 'Width should be a positive number'),
        assert(_height > 0, 'Height should be a positive number'),
        _types = types;

  final int _width;
  final int _height;
  final List<CropType> _types;

  ///
  Map<String, Object> get params {
    return <String, Object>{
      'crop': _types.map((it) => it.name).join(','),
      'w': _width,
      'h': _height,
    };
  }
}
