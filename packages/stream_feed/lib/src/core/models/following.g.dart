// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'following.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Following _$FollowingFromJson(Map json) => Following(
      feed: Following._fromId(json['feed'] as String),
      count: json['count'] as int?,
      slugs:
          (json['slugs'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FollowingToJson(Following instance) => <String, dynamic>{
      'feed': FeedId.toId(instance.feed),
      'slugs': instance.slugs,
      'count': instance.count,
    };
