// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedReactions<A, Ob> _$PaginatedReactionsFromJson<A, Ob>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
) {
  return PaginatedReactions<A, Ob>(
    json['next'] as String?,
    (json['results'] as List<dynamic>?)
        ?.map((e) => Reaction.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    json['activity'] == null
        ? null
        : EnrichedActivity.fromJson(
            (json['activity'] as Map?)?.map(
              (k, e) => MapEntry(k as String, e),
            ),
            (value) => fromJsonA(value),
            (value) => fromJsonOb(value)),
    json['duration'] as String?,
  );
}

Map<String, dynamic> _$PaginatedReactionsToJson<A, Ob>(
  PaginatedReactions<A, Ob> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results?.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'activity': instance.activity?.toJson(
        (value) => toJsonA(value),
        (value) => toJsonOb(value),
      ),
    };
