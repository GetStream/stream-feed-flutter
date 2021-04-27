import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
part 'attachment_file.g.dart';

Uint8List? _fromString(String? bytes) {
  if (bytes == null) return null;
  return Uint8List.fromList(bytes.codeUnits);
}

String? _toString(Uint8List? bytes) {
  if (bytes == null) return null;
  return String.fromCharCodes(bytes);
}

/// The class that contains the information about an attachment file
@JsonSerializable()
class AttachmentFile {
  /// Creates a new [AttachmentFile] instance.
  const AttachmentFile({
    required this.path,
  });

  /// Create a new instance from a json
  factory AttachmentFile.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFileFromJson(json);

  /// The absolute path for a cached copy of this file. It can be used to
  /// create a file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String path;

  /// File extension for this file.
  // String? get mediaType => name?.split('.').last;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AttachmentFileToJson(this);
}
