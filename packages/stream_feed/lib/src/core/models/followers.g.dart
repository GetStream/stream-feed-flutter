// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'followers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Followers _$FollowersFromJson(Map json) => Followers(
      feed: Followers._fromId(json['feed'] as String),
      count: json['count'] as int?,
      slugs:
          (json['slugs'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FollowersToJson(Followers instance) => <String, dynamic>{
      'feed': FeedId.toId(instance.feed),
      'slugs': instance.slugs,
      'count': instance.count,
    };
