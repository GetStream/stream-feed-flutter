// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalized_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalizedFeed _$PersonalizedFeedFromJson(Map json) {
  return PersonalizedFeed(
    version: json['version'] as String,
    offset: json['offset'] as int,
    limit: json['limit'] as int,
    next: json['next'] as String?,
    results: (json['results'] as List<dynamic>?)
        ?.map((e) => EnrichedActivity.fromJson(
            (e as Map?)?.map(
              (k, e) => MapEntry(k as String, e),
            ),
            (value) => value,
            (value) => value,
            (value) => value,
            (value) => value))
        .toList(),
    duration: json['duration'] as String?,
  );
}

Map<String, dynamic> _$PersonalizedFeedToJson(PersonalizedFeed instance) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results
          ?.map((e) => e.toJson(
                (value) => value,
                (value) => value,
                (value) => value,
                (value) => value,
              ))
          .toList(),
      'duration': instance.duration,
      'version': instance.version,
      'offset': instance.offset,
      'limit': instance.limit,
    };
