// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_relation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowRelation _$FollowRelationFromJson(Map json) => FollowRelation(
      source: json['source'] as String,
      target: json['target'] as String,
    );

Map<String, dynamic> _$FollowRelationToJson(FollowRelation instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
    };

UnFollowRelation _$UnFollowRelationFromJson(Map json) => UnFollowRelation(
      source: json['source'] as String,
      target: json['target'] as String,
      keepHistory: json['keep_history'] as bool?,
    );

Map<String, dynamic> _$UnFollowRelationToJson(UnFollowRelation instance) =>
    <String, dynamic>{
      'source': instance.source,
      'target': instance.target,
      'keep_history': instance.keepHistory,
    };
