// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedReactions _$PaginatedReactionsFromJson(Map json) {
  return PaginatedReactions(
    json['next'] as String?,
    (json['results'] as List<dynamic>?)
        ?.map((e) => Reaction.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    json['activity'] == null
        ? null
        : EnrichedActivity.fromJson((json['activity'] as Map?)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['duration'] as String?,
  );
}

Map<String, dynamic> _$PaginatedReactionsToJson(PaginatedReactions instance) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results?.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'activity': instance.activity?.toJson(),
    };
