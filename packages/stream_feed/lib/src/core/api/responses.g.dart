// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map json) => ErrorResponse(
      duration: json['duration'] as String?,
      message: json['message'] as String?,
      code: json['code'] as int?,
      statusCode: json['status_code'] as int?,
      moreInfo: json['more_info'] as String?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'code': instance.code,
      'message': instance.message,
      'status_code': instance.statusCode,
      'more_info': instance.moreInfo,
    };
