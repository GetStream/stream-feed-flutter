// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedReactions<A, Ob, T> _$PaginatedReactionsFromJson<A, Ob, T>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
  T Function(Object? json) fromJsonT,
) {
  return PaginatedReactions<A, Ob, T>(
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
            (value) => fromJsonOb(value),
            (value) => fromJsonT(value)),
    json['duration'] as String?,
  );
}

Map<String, dynamic> _$PaginatedReactionsToJson<A, Ob, T>(
  PaginatedReactions<A, Ob, T> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results?.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'activity': instance.activity?.toJson(
        (value) => toJsonA(value),
        (value) => toJsonOb(value),
        (value) => toJsonT(value),
      ),
    };
