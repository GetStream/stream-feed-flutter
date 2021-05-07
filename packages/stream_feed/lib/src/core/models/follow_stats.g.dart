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
