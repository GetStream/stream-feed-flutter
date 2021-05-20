// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowRelation _$FollowRelationFromJson(Map json) {
  return FollowRelation(
    source: json['source'] as String?,
    target: json['target'] as String?,
  );
}

Map<String, dynamic> _$FollowRelationToJson(FollowRelation instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

UnFollowRelation _$UnFollowRelationFromJson(Map json) {
  return UnFollowRelation(
    json['source'] as String?,
    json['target'] as String?,
    json['keep_history'] as bool?,
  );
}

Map<String, dynamic> _$UnFollowRelationToJson(UnFollowRelation instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'keep_history': instance.keepHistory,
    };
