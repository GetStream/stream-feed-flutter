import 'dart:typed_data';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_feed/src/core/platform_detector/platform_detector.dart'
    show CurrentPlatform;
import 'package:stream_feed/src/core/util/extension.dart';
import 'package:stream_feed/stream_feed.dart';

part 'attachment_file.g.dart';

Uint8List? _fromString(String? bytes) {
  if (bytes == null) return null;
  return Uint8List.fromList(bytes.codeUnits);
}

String? _toString(Uint8List? bytes) {
  if (bytes == null) return null;
  return String.fromCharCodes(bytes);
}

/// Contains information about an attachment file.
@JsonSerializable()
class AttachmentFile extends Equatable {
  /// Builds an [AttachmentFile].
  AttachmentFile({
    this.path,
    this.name,
    this.bytes,
    this.size,
  })  : assert(
          path != null || bytes != null,
          'Either path or bytes should be != null',
        ),
        assert(
          !CurrentPlatform.isWeb || bytes != null,
          'File by path is not supported in web, Please provide bytes',
        );

  /// Create a new instance from a JSON object
  factory AttachmentFile.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFileFromJson(json);

  /// The absolute path for a cached copy of this file.
  ///
  /// It can be used to
  /// create a file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  final String? path;

  /// File name including its extension.
  final String? name;

  /// Byte data for this file.
  ///
  /// Particularly useful if you want to manipulate
  /// its data or easily upload to somewhere else.
  @JsonKey(toJson: _toString, fromJson: _fromString)
  final Uint8List? bytes;

  /// The file size in bytes.
  final int? size;

  /// File extension for this file.
  String? get extension => name?.split('.').last;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$AttachmentFileToJson(this);

  /// Converts this into a [MultipartFile]
  Future<MultipartFile> toMultipartFile() async {
    final filename = path?.split('/').last ?? name;
    final mimeType = filename?.mimeType;

    late MultipartFile multiPartFile;

    if (CurrentPlatform.isWeb) {
      multiPartFile = MultipartFile.fromBytes(
        bytes!,
        filename: filename,
        contentType: mimeType,
      );
    } else {
      multiPartFile = await MultipartFile.fromFile(
        path!,
        filename: filename,
        contentType: mimeType,
      );
    }
    return multiPartFile;
  }

  @override
  List<Object?> get props => [path, name, bytes, size];
}
