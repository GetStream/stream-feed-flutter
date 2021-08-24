// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map json) {
  return ErrorResponse()
    ..duration = json['duration'] as String?
    ..code = json['code'] as int?
    ..message = json['message'] as String?
    ..statusCode = json['StatusCode'] as int?
    ..moreInfo = json['more_info'] as String?;
}

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'code': instance.code,
      'message': instance.message,
      'StatusCode': instance.statusCode,
      'more_info': instance.moreInfo,
    };
