// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FollowStats _$FollowStatsFromJson(Map json) {
  return FollowStats(
    following:
        Following.fromJson(Map<String, dynamic>.from(json['following'] as Map)),
    followers:
        Followers.fromJson(Map<String, dynamic>.from(json['followers'] as Map)),
  );
}

Map<String, dynamic> _$FollowStatsToJson(FollowStats instance) =>
    <String, dynamic>{
      'following': instance.following.toJson(),
      'followers': instance.followers.toJson(),
    };
