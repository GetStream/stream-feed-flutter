// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map json) {
  return Follow(
    json['feed_id'] as String?,
    json['target_id'] as String?,
  );
}

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'feed_id': instance.source,
      'target_id': instance.target,
    };
