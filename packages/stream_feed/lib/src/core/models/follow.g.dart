// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map json) {
  return Follow(
    json['source'] as String?,
    json['target'] as String?,
  );
}

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

UnFollow _$UnFollowFromJson(Map json) {
  return UnFollow(
    json['source'] as String?,
    json['target'] as String?,
    json['keep_history'] as bool?,
  );
}

Map<String, dynamic> _$UnFollowToJson(UnFollow instance) => <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'keep_history': instance.keepHistory,
    };
