// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map json) {
  return Follow(
    feedId: json['feed_id'] as String,
    targetId: json['target_id'] as String,
    createdAt:
        const DateTimeUTCConverter().fromJson(json['created_at'] as String),
    updatedAt:
        const DateTimeUTCConverter().fromJson(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'feed_id': instance.feedId,
      'target_id': instance.targetId,
      'created_at': const DateTimeUTCConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeUTCConverter().toJson(instance.updatedAt),
    };
