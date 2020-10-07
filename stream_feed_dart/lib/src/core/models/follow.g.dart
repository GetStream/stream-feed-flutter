// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Follow _$FollowFromJson(Map json) {
  return Follow(
    json['feed_id'] as String,
    json['target_id'] as String,
  );
}

Map<String, dynamic> _$FollowToJson(Follow instance) => <String, dynamic>{
      'feed_id': instance.feedId,
      'target_id': instance.targetId,
    };

UnFollow _$UnFollowFromJson(Map json) {
  return UnFollow(
    json['feed_id'] as String,
    json['target_id'] as String,
    json['keep_history'] as bool,
  );
}

Map<String, dynamic> _$UnFollowToJson(UnFollow instance) => <String, dynamic>{
      'feed_id': instance.feedId,
      'target_id': instance.targetId,
      'keep_history': instance.keepHistory,
    };
