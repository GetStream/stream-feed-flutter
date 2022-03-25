// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentFile _$AttachmentFileFromJson(Map json) => AttachmentFile(
      path: json['path'] as String?,
      name: json['name'] as String?,
      bytes: _fromString(json['bytes'] as String?),
      size: json['size'] as int?,
    );

Map<String, dynamic> _$AttachmentFileToJson(AttachmentFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'bytes': _toString(instance.bytes),
      'size': instance.size,
    };
