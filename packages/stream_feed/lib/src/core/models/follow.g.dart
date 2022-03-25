// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map json) => Follow(
      feedId: json['feed_id'] as String,
      targetId: json['target_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'feed_id': instance.feedId,
      'target_id': instance.targetId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
