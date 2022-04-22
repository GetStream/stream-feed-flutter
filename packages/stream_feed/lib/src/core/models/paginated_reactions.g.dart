// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedReactions<A, Ob, T, Or> _$PaginatedReactionsFromJson<A, Ob, T, Or>(
  Map json,
  A Function(Object? json) fromJsonA,
  Ob Function(Object? json) fromJsonOb,
  T Function(Object? json) fromJsonT,
  Or Function(Object? json) fromJsonOr,
) =>
    PaginatedReactions<A, Ob, T, Or>(
      next: json['next'] as String?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Reaction.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      activity: json['activity'] == null
          ? null
          : GenericEnrichedActivity<A, Ob, T, Or>.fromJson(
              (json['activity'] as Map?)?.map(
                (k, e) => MapEntry(k as String, e),
              ),
              (value) => fromJsonA(value),
              (value) => fromJsonOb(value),
              (value) => fromJsonT(value),
              (value) => fromJsonOr(value)),
      duration: json['duration'] as String?,
    );

Map<String, dynamic> _$PaginatedReactionsToJson<A, Ob, T, Or>(
  PaginatedReactions<A, Ob, T, Or> instance,
  Object? Function(A value) toJsonA,
  Object? Function(Ob value) toJsonOb,
  Object? Function(T value) toJsonT,
  Object? Function(Or value) toJsonOr,
) =>
    <String, dynamic>{
      'next': instance.next,
      'results': instance.results?.map((e) => e.toJson()).toList(),
      'duration': instance.duration,
      'activity': instance.activity?.toJson(
        (value) => toJsonA(value),
        (value) => toJsonOb(value),
        (value) => toJsonT(value),
        (value) => toJsonOr(value),
      ),
    };
